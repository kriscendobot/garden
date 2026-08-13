#!/bin/bash
# unblock.sh — the deterministic unblock trigger for parked `gate: blocked` plans.
#
# Usage: unblock.sh
#
# The proxy parks a blocked job as a `gate: blocked` plan carrying a `blocked_on:`
# artifact (a PR URL or a blocking job's basename — see scripts/jobs/proxy.sh
# § park_blocked_jobs). This timer-driven oneshot is the trigger that promotes such
# a plan back to todo/ when its blocker COMPLETES. It is deterministic and uses NO
# `claude -p`.
#
# The plan file's `blocked_on:` field is the SINGLE SOURCE OF TRUTH for the
# dependency edge; this watcher scans the plan dir, reads each blocked plan's
# blocker, and:
#   - blocker is a JOB basename → if that job is in jobs/tada/ (completed) AND its
#     report does NOT carry the "completed-but-declined" marker (tada_failed,
#     common.sh), promote plan/<base> → todo/. If the blocker COMPLETED but its
#     report marks the gated outcome as NOT achieved — the canonical case is a
#     conductor whose `merge` job correctly REFUSES to merge (CI red, base frozen,
#     ferry-required) yet still finishes — the dependent is NOT satisfied: instead
#     of promoting it onto a base that never landed, this watcher HOLDS the plan
#     (flips its gate to `blocked-failed` so it stops re-scanning it) and surfaces
#     the stalled dependency to the maintainer exactly once.
#   - blocker is a PR (URL or owner/repo#n) → read its state via the PR-state
#     handler (default: the gh/jq reader shared with mirror-closer); if the PR is
#     merged OR closed, promote plan/<base> → todo/.
#   - otherwise leave it parked.
# Promotion reuses promote-plan.sh, which strips the blocked frontmatter so the
# todo job is the clean work body a gardener claims — the edge record is cleaned up
# by construction (the plan file, the only record, ceases to exist).
#
# Part of the garden's autonomous posture: SILENT until an error; only promotions
# and the watcher's own failures surface.
#
# Pluggable for tests:
#   GARDEN_UNBLOCK_CLONE       this service's journal clone.
#   GARDEN_UNBLOCK_PR_STATE    PR-state reader; invoked "<owner/repo> <num>",
#                              prints "<state>\t<merged>" (state ∈ open|closed).
#                              Default: handlers/mirror-pr-state-gh.sh.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="unblock"
: "${GARDEN_UNBLOCK_PR_STATE:=$HERE/handlers/mirror-pr-state-gh.sh}"

require_tools git

fleet_draining && exit 0

DIR="${GARDEN_UNBLOCK_CLONE:-$GARDEN_STATE/unblock/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# A blocker's PR is "done" (merge or plain close both unblock) when its state is
# closed. Returns 0 if the PR-state handler says closed, 1 if open, 2 if the read
# failed (so we leave the plan parked rather than guess — the silent-jq lesson).
pr_is_done() {
  local repo="$1" num="$2" out state
  if out="$("$GARDEN_UNBLOCK_PR_STATE" "$repo" "$num" 2>/dev/null)"; then
    state="$(printf '%s' "$out" | cut -f1)"
    [ "$state" = "closed" ] && return 0
    return 1
  fi
  return 2
}

# Surface a stalled dependency to the maintainer inbox (best-effort; a notify
# failure must never wedge the tick). Body on stdin. Mirrors orchestrate.sh's
# orch_notify so a declined predecessor surfaces the same way a failed child does.
notify_maintainer() {  # <subject> ; body on stdin
  local subject="$1"
  GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="unblock:${subject}" \
    "$HERE/inbox-send.sh" maintainer >/dev/null 2>&1 || \
    log "maintainer notify failed (non-fatal): $subject"
}

# A blocked plan whose blocker JOB completed but DECLINED its gated outcome (its
# tada report is tada_failed — e.g. a conductor that refused to merge). Do NOT
# promote off it: flip the plan's gate blocked → blocked-failed so this watcher
# stops scanning it (notify-once by construction, since the top-of-loop filter
# requires gate=blocked), record the reason on the plan for a human, and surface
# it to the maintainer. The work survives in plan/ (held) — a human can override
# with promote-plan.sh if the decline is acceptable, or discard it. CAS-retried
# like promote-plan.sh; touches only this base.
hold_failed() {  # <base> <blocker>
  local base="$1" blocker="$2" f attempt rc
  for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
    sync_clone "$DIR"
    f="$DIR/jobs/plan/$base.md"
    [ -f "$f" ] || return 0                            # already gone / changed
    [ "$(plan_gate "$f")" = "blocked" ] || return 0    # a peer already held it
    sed -i 's/^gate:.*/gate: blocked-failed/' "$f"
    grep -q '^blocked_failed_reason:' "$f" || \
      sed -i "/^gate: blocked-failed/a blocked_failed_reason: blocker '$blocker' completed but declined its gated outcome; held for a human decision" "$f"
    git -C "$DIR" add "jobs/plan/$base.md"
    rc=0; commit_and_push "$DIR" "unblock($base) held: blocker '$blocker' declined its gated outcome by $GARDEN" || rc=$?
    if [ "$rc" -eq 0 ]; then
      printf "Blocked job '%s' will NOT be promoted: its blocker '%s' completed but DECLINED its gated outcome (e.g. a conductor that refused to merge a red / frozen-base / ferry-required PR). Promoting it would run downstream work against a base that never landed. It is HELD in plan/ under gate=blocked-failed for you: run promote-plan.sh '%s' to override if the decline is acceptable, or discard it.\n" \
        "$base" "$blocker" "$base" | notify_maintainer "$base-blocked-failed"
      log "held '$base' (blocker '$blocker' completed-but-declined); surfaced to maintainer"
      return 0
    fi
    [ "$rc" -eq 2 ] && return 0   # a peer already committed the hold — it notified
    backoff "$attempt"
  done
  log "could not hold '$base' after retries; will retry next tick"
  return 1
}

promoted=0
# while-read, not `for j in $(…)`: an unquoted expansion word-splits, so a plan
# basename containing whitespace (postable — the basename guards reject only
# -*/./slash/empty) would be scanned as fragments and silently never unblocked.
while IFS= read -r j; do
  case "$j" in *.md) ;; *) continue;; esac
  f="$DIR/jobs/plan/$j"; [ -f "$f" ] || continue
  [ "$(plan_gate "$f")" = "blocked" ] || continue
  base="${j%.md}"
  artifact="$(plan_blocked_on "$f")"
  if [ -z "$artifact" ]; then
    log "blocked plan '$base' has no blocked_on artifact; leaving parked (malformed edge)"
    continue
  fi

  do_promote=no
  if pr="$(parse_pr_ref "$artifact")"; then
    # PR blocker: the PR-state handler reads merge/close state. The DEFAULT handler
    # (handlers/mirror-pr-state-gh.sh) `require_tools gh jq` and fails LOUD on a
    # missing binary or failed call — the silent-jq-outage discipline — so a
    # swallowed error never masquerades as "open" and strands a parked job. (A
    # stubbed handler in tests bypasses gh/jq, exactly like mirror-closer.)
    repo="$(printf '%s' "$pr" | cut -f1)"; num="$(printf '%s' "$pr" | cut -f2)"
    set +e; pr_is_done "$repo" "$num"; st=$?; set -e
    case "$st" in
      0) do_promote=yes ;;
      1) : ;;  # PR still open → stay parked
      2) log "could not read PR state for '$artifact' (blocker of '$base'); leaving parked" ;;
    esac
  elif is_job_basename "$artifact"; then
    # Job blocker: completed iff it is in tada/. But a job can reach tada/ having
    # DECLINED the gated outcome the dependent keys on (a conductor that refused
    # to merge). Such a report is tada_failed → do NOT promote; hold the plan and
    # surface the stalled dependency to the maintainer instead of running the
    # dependent against an outcome that never happened.
    tada_path="$(tada_find "$DIR" "$artifact" || true)"
    if [ -n "$tada_path" ]; then
      if tada_failed "$DIR/$tada_path"; then
        # `|| true`: a hold that exhausts its CAS retries logs and is retried next
        # tick; it must never `set -e`-abort the whole scan of the other plans.
        hold_failed "$base" "$artifact" || true
        continue
      fi
      do_promote=yes
    fi
  else
    log "blocked plan '$base' has an unrecognized blocked_on artifact '$artifact'; leaving parked"
    continue
  fi

  if [ "$do_promote" = yes ]; then
    if "$HERE/promote-plan.sh" "$base" >/dev/null 2>&1; then
      log "unblocked '$base' (blocker '$artifact' completed); promoted plan→todo"
      promoted=$((promoted+1))
    else
      log "promotion of unblocked '$base' failed; will retry next tick"
    fi
  fi
done < <(list_jobs "$DIR" jobs/plan)

[ "$promoted" -gt 0 ] && log "promoted $promoted unblocked plan job(s) to todo"
exit 0
