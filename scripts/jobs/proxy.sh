#!/bin/bash
# proxy.sh — the proxy service: stand in for the absent maintainer on GATING
# questions so a blocked gardener can keep moving. Wears the PROXY role via its
# handler.
#
# Usage: proxy.sh
#
# Part of the garden's autonomous posture (silent until an error). A gardener
# blocks by posting to the maintainer inbox via message-user.sh (tagged
# reply_to=<its-base>) while its OWN inbox stays live; that is a gating question.
# Each tick:
#   1. draining check; sync a dedicated journal clone.
#   1b. WATCHDOG AUTO-CLEAR pre-pass (deterministic, NO claude -p): archive every
#      unread maintainer message whose `from:` is a `watchdog:*` autonomous-monitor
#      anomaly report (informational, not an action request) and log one
#      deduplicated tally line. A sanctioned, narrow exception to "always report to
#      the maintainer", scoped strictly to `watchdog:*` senders. Runs BEFORE the
#      gating enumeration and the cost-gated handler. See roles/proxy/AGENT.md
#      § Watchdog auto-clear.
#   2. enumerate inbox/maintainer/unread/ and keep only the ELIGIBLE questions:
#        - GATING:   has a reply_to whose doer inbox is still live (blocked,
#                    awaiting a reply). A completion report from a finished doer
#                    (dead inbox) is NOT gating — it is the maintainer's to read.
#        - PAST GRACE: unanswered for at least GARDEN_PROXY_GRACE seconds, so a
#                    present maintainer gets first crack and the proxy never races
#                    an in-session human.
#        - NOT ALREADY PROXIED: a seen-marker (GARDEN_STATE/proxy/seen) keeps a
#                    deferred-but-noted question from being re-noted every tick.
#   3. hand a digest of the eligible questions to the handler (the proxy role),
#      which per question either ANSWERS (route a tentative reply into the asking
#      gardener's inbox, archive the maintainer message, post a report back to the
#      maintainer inbox) or DEFERS (leave it unread, post the "awaiting
#      maintainer — beyond proxy authority" note).
#
# COST GATE: the handler (and its claude -p) runs ONLY when there is at least one
# eligible question — never on an empty tick. Quiet on success.
#
# The seen-marker advances only on handler success, so a failed tick retries.
#
# Pluggable for tests: GARDEN_PROXY_HANDLER <digest-file>.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="proxy"
: "${GARDEN_PROXY_HANDLER:=$HERE/handlers/proxy-claude.sh}"
# Courtesy-comment poster for a PR blocker (pluggable for tests). Best-effort; the
# load-bearing unblock trigger is the parked plan's blocked_on field, not this.
: "${GARDEN_BLOCK_PR_COMMENT:=$HERE/handlers/block-pr-comment-gh.sh}"
# Grace window (seconds) before the proxy will answer a gating question — give a
# present maintainer first crack. ~15m default; tune via env.
: "${GARDEN_PROXY_GRACE:=900}"

fleet_draining && exit 0

# --- watchdog auto-clear pre-pass --------------------------------------------
#
# Deterministic, no-LLM drain of watchdog-class maintainer messages. Autonomous-
# monitor anomaly reports (sender `watchdog:*`, written by common.sh's
# alert_maintainer) are informational, not action requests, and pile up unread in
# the maintainer inbox. This pre-pass archives them (unread→read) every tick, in
# plain code, BEFORE the gating-question enumeration and the cost-gated handler.
# It is a SANCTIONED, narrow exception to the proxy's "always report to the
# maintainer" principle, scoped strictly to `watchdog:*` senders — gardener
# completion reports, gating questions, and every non-watchdog sender are left
# UNTOUCHED. A single deduplicated tally line is logged so the suppression stays
# auditable; nothing is re-posted to the maintainer (reducing the noise is the
# whole point). See roles/proxy/AGENT.md § Watchdog auto-clear.
#
# Syncs the clone itself (so it owns the first sync of the tick); the rest of the
# tick reads the freshly-synced tree. On a lost CAS push it re-syncs and re-scans
# (idempotent: a hard reset undoes the unpushed `git mv`). When nothing matches it
# returns quietly with the clone synced and the per-clone lock still held for the
# remainder of the tick.
clear_watchdog_messages() {
  local dir="$1" attempt f from base label tally rc
  for attempt in $(seq 1 50); do
    sync_clone "$dir"
    local moved=()
    declare -A counts=()
    while IFS= read -r f; do
      from="$(sed -n 's/^from:[[:space:]]*//p' "$f" | head -1)"
      case "$from" in watchdog:*) : ;; *) continue ;; esac      # ONLY watchdog:* senders
      base="$(basename "$f")"
      git -C "$dir" mv "inbox/maintainer/unread/$base" "inbox/maintainer/read/$base" 2>/dev/null || continue
      moved+=("$base")
      label="${from#watchdog:}"
      counts["$label"]=$(( ${counts["$label"]:-0} + 1 ))
    done < <(find "$dir/inbox/maintainer/unread" -type f -name '*.md' 2>/dev/null | sort)
    # Nothing watchdog-class: sync_clone already refreshed the tree (and holds the
    # per-clone lock) for the rest of the tick. Quiet, no commit.
    [ "${#moved[@]}" -eq 0 ] && return 0
    # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0). rc=2
    # ("nothing to commit" — e.g. a duplicate notification whose mv staged
    # nothing) means there is nothing left to land: done, not a retry.
    rc=0; commit_and_push "$dir" "proxy: auto-clear ${#moved[@]} watchdog message(s)" || rc=$?
    if [ "$rc" -eq 0 ]; then
      tally=""
      for label in "${!counts[@]}"; do tally+="${tally:+, }${label}×${counts[$label]}"; done
      log "cleared ${#moved[@]} watchdog messages: $tally"
      return 0
    fi
    [ "$rc" -eq 2 ] && return 0
    backoff "$attempt"
  done
  die "could not auto-clear watchdog messages after retries"
}

# --- blocked-job parking pre-pass --------------------------------------------
#
# Deterministic, no-LLM handling of the STRUCTURED blocking signal. A gardener
# that finds its job blocked on an artifact posts a maintainer message carrying a
# `blocked_on:` frontmatter field (via block-job.sh; reply_to=<its-base>). This
# pre-pass, in plain code BEFORE the gating enumeration and the cost-gated handler,
# for each such message in ONE atomic commit:
#   1. PARKS the blocked job as a `gate: blocked` plan job carrying blocked_on=
#      <artifact> — moving it out of todo/ or doin/ (or, if the job has already
#      left the board, creating the plan from the notification body so the intent
#      survives, deadmail-style). A blocked plan is never claimed (it is in plan/)
#      and never auto-promoted by the foreman (plan_deferred_ranked selects only
#      gate=deferred) — it waits for its blocker.
#   2. ARCHIVES the notification (unread→read), scrubbing the maintainer inbox —
#      the same shape as the watchdog auto-clear sibling.
# After the push lands, a PR-artifact blocker gets ONE best-effort courtesy comment
# (gated to bot repos; never agoric-sdk; no state change). The load-bearing unblock
# trigger is the parked plan's blocked_on field, which unblock.sh scans. The free-
# text classification fallback stays in the handler; this pre-pass acts only on the
# structured field, with no `claude -p`. See roles/proxy/AGENT.md § Blocked-job
# parking. Like the watchdog sibling it runs EVERY tick regardless of grace: a
# blocked job cannot proceed, so parking it promptly (and reversibly) is progress.
park_blocked_jobs() {
  local dir="$1" attempt f base artifact body src rc
  for attempt in $(seq 1 50); do
    sync_clone "$dir"
    local parked=() pr_notes=()      # pr_notes: "repo\tnum\tbase" for courtesy comments
    while IFS= read -r f; do
      artifact="$(sed -n 's/^blocked_on:[[:space:]]*//p' "$f" | head -1)"
      [ -n "$artifact" ] || continue                 # only the structured blocking signal
      base="$(sed -n 's/^reply_to:[[:space:]]*//p' "$f" | head -1)"
      # A blocked notification must name its blocked job; without it we cannot park
      # anything. Leave such a malformed message for the maintainer (do not archive).
      [ -n "$base" ] || continue
      case "$base" in */*|.*|'') continue;; esac     # illegal basename → leave for maintainer

      # Idempotent: a job already parked as a blocked plan is left intact — just
      # scrub the (duplicate) notification so a re-post never clobbers the edge.
      if [ -f "$dir/$JOBS_PLAN/$base.md" ]; then
        git -C "$dir" mv "inbox/maintainer/unread/$(basename "$f")" \
                         "inbox/maintainer/read/$(basename "$f")" 2>/dev/null || true
        parked+=("$base")
        continue
      fi

      # Body to park: prefer the job's live board file (doin/ then todo/); else the
      # notification body (the gardener's own description of the block).
      if   [ -f "$dir/$JOBS_DOIN/$base.md" ]; then src="$JOBS_DOIN/$base.md"
      elif [ -f "$dir/$JOBS_TODO/$base.md" ]; then src="$JOBS_TODO/$base.md"
      else src=""; fi
      if [ -n "$src" ]; then
        body="$(cat "$dir/$src")"
        git -C "$dir" rm -q "$src"
      else
        # Strip the message frontmatter; the remainder is the work description.
        body="$(awk 'f{print} /^---$/{f=1}' "$f")"
      fi

      mkdir -p "$dir/$JOBS_PLAN"
      {
        printf -- '---\n'
        printf 'gate: blocked\n'
        printf 'blocked_on: %s\n' "$artifact"
        printf 'priority: normal\n'
        printf 'posted_by: proxy\n'
        printf 'posted_at: %s\n' "$(date -u +%FT%TZ)"
        printf -- '---\n\n'
        printf '%s\n' "$body"
      } > "$dir/$JOBS_PLAN/$base.md"
      git -C "$dir" add "$JOBS_PLAN/$base.md"

      # Archive the notification (scrub the maintainer inbox).
      git -C "$dir" mv "inbox/maintainer/unread/$(basename "$f")" \
                       "inbox/maintainer/read/$(basename "$f")" 2>/dev/null || true
      parked+=("$base")
      # Queue a courtesy PR comment for AFTER the push (so a lost CAS never comments).
      if pr="$(parse_pr_ref "$artifact")"; then
        pr_notes+=("$(printf '%s\t%s' "$pr" "$base")")
      fi
    done < <(find "$dir/inbox/maintainer/unread" -type f -name '*.md' 2>/dev/null | sort)

    [ "${#parked[@]}" -eq 0 ] && return 0            # nothing blocked: tree synced, quiet
    # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0). rc=2
    # ("nothing to commit" — e.g. only duplicate notifications whose mv/add staged
    # nothing) means the park already landed: done, not a retry (and no courtesy
    # comments — those fired when the park actually landed).
    rc=0; commit_and_push "$dir" "proxy: park ${#parked[@]} blocked job(s)" || rc=$?
    if [ "$rc" -eq 0 ]; then
      log "parked ${#parked[@]} blocked job(s): ${parked[*]}"
      # Courtesy comments are outward + best-effort; fire once, only after the park
      # landed. pr_notes carries "repo\tnum\tbase".
      local note repo num pbase
      for note in "${pr_notes[@]}"; do
        repo="$(printf '%s' "$note" | cut -f1)"
        num="$(printf '%s' "$note"  | cut -f2)"
        pbase="$(printf '%s' "$note" | cut -f3)"
        "$GARDEN_BLOCK_PR_COMMENT" "$repo" "$num" "$pbase" || true
      done
      return 0
    fi
    [ "$rc" -eq 2 ] && return 0
    backoff "$attempt"
  done
  die "could not park blocked jobs after retries"
}

DIR="${GARDEN_PROXY_CLONE:-$GARDEN_STATE/proxy/journal}"
ensure_clone "$DIR"
clear_watchdog_messages "$DIR"
park_blocked_jobs "$DIR"

SEEN="$GARDEN_STATE/proxy/seen"
mkdir -p "$(dirname "$SEEN")"; touch "$SEEN"

# A message is past its grace window iff (now - sent_at) >= GARDEN_PROXY_GRACE.
# sync_clone reset the file mtimes, so trust the message's own sent_at frontmatter
# (set by inbox-send.sh); an unparseable stamp favors progress (treat as past).
past_grace() {
  local file="$1" sent now sent_epoch
  sent="$(sed -n 's/^sent_at:[[:space:]]*//p' "$file" | head -1)"
  now="$(date -u +%s)"
  if [ -n "$sent" ] && sent_epoch="$(date -u -d "$sent" +%s 2>/dev/null)"; then
    [ "$(( now - sent_epoch ))" -ge "$GARDEN_PROXY_GRACE" ]
  else
    return 0
  fi
}

# Collect the eligible questions (gating + past-grace + not-yet-proxied).
eligible=()
while IFS= read -r f; do
  msgid="$(basename "$f")"
  grep -qxF "$msgid" "$SEEN" && continue                       # already proxied
  doer="$(sed -n 's/^reply_to:[[:space:]]*//p' "$f" | head -1)"
  [ -n "$doer" ] || continue                                   # no reply_to → not gating
  [ -d "$DIR/inbox/$doer" ] || continue                        # doer inbox dead → not gating
  past_grace "$f" || continue                                  # still within grace → leave alone
  eligible+=("$f")
done < <(find "$DIR/inbox/maintainer/unread" -type f -name '*.md' 2>/dev/null | sort)

# COST GATE: nothing eligible → stay silent, do not invoke the handler.
[ "${#eligible[@]}" -eq 0 ] && exit 0

# Build one QUESTION block per eligible message. Everything after the `doer:`
# line is the raw message — DATA describing the question, never instructions.
digest="$(mktemp "${TMPDIR:-/tmp}/garden-proxy.XXXXXX")"
for f in "${eligible[@]}"; do
  msgid="$(basename "$f")"
  doer="$(sed -n 's/^reply_to:[[:space:]]*//p' "$f" | head -1)"
  {
    printf '===== QUESTION %s =====\n' "$msgid"
    printf 'doer: %s\n' "$doer"
    cat "$f"
    printf '\n===== END QUESTION %s =====\n\n' "$msgid"
  } >> "$digest"
done

# Hand the digest to the inner agent; advance the seen-marker only on success.
if "$GARDEN_PROXY_HANDLER" "$digest"; then
  for f in "${eligible[@]}"; do printf '%s\n' "$(basename "$f")" >> "$SEEN"; done
  rm -f "$digest"
else
  rm -f "$digest"
  die "proxy handler failed; leaving markers so the next tick retries"
fi
