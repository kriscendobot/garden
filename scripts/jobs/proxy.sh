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
  local dir="$1" attempt f from base label tally
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
    if commit_and_push "$dir" "proxy: auto-clear ${#moved[@]} watchdog message(s)"; then
      tally=""
      for label in "${!counts[@]}"; do tally+="${tally:+, }${label}×${counts[$label]}"; done
      log "cleared ${#moved[@]} watchdog messages: $tally"
      return 0
    fi
    backoff
  done
  die "could not auto-clear watchdog messages after retries"
}

DIR="${GARDEN_PROXY_CLONE:-$GARDEN_STATE/proxy/journal}"
ensure_clone "$DIR"
clear_watchdog_messages "$DIR"

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
