#!/bin/bash
# root-maintenance.sh — the ExecStart of garden-root-maintenance.service.
#
# The DETERMINISTIC, no-LLM async worker for the sysop `maintain` op
# (designs/sysop-repo-maintenance.md). It performs NO gc logic of its own: it invokes
# the existing root-repo-guard.sh with a single authorized-escalation flag
# (GARDEN_ROOT_GUARD_UNLOCK_STALE_GC=1), which lets the guard break a CONFIRMED-STALE
# git gc.pid lock and run one bounded gc on the deployed root repo. The guard records a
# one-word escalation outcome; this worker maps it to a terminal result the sysop's next
# tick reads and acks. The guard is the sanctioned actor that runs git inside
# $GARDEN_ROOT (like deploy-garden.sh); this worker never runs git there itself.
#
# The unit is a static Type=oneshot with NO [Install] section (a routine install never
# enables it) and a BOUNDED TimeoutStartSec (the guard's own per-step timeouts cap the
# work — unlike the model-pull unit's infinite budget). It is started only by an
# accepted, attested `maintain` request, with --no-block, so the sysop never waits on it.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="root-maintenance"

: "${GARDEN_SYSOP_MAINT_STATE:=$GARDEN_STATE/sysop/root-maintenance}"
: "${GARDEN_SYSOP_MAINT_GUARD:=$HERE/root-repo-guard.sh}"
RM="$GARDEN_SYSOP_MAINT_STATE"

# write_result <outcome> <detail> — atomically publish the terminal result the sysop
# poll reads. outcome ∈ applied | refused | failed. Temp file + rename so a half-written
# record is never observed.
write_result() {
  mkdir -p "$RM" 2>/dev/null || true
  {
    printf 'outcome: %s\n' "$1"
    printf 'detail: %s\n'  "$(printf '%s' "$2" | tr '\n' ' ')"
    printf 'at: %s\n'      "$(date -u +%FT%TZ)"
  } > "$RM/result.tmp" && mv -f "$RM/result.tmp" "$RM/result"
}

mkdir -p "$RM" 2>/dev/null || true
GR="$RM/guard-result"; rm -f "$GR" 2>/dev/null || true

log "running root-repo-guard with the authorized gc-lock escalation on $GARDEN_ROOT"
rc=0
GARDEN_ROOT_GUARD_UNLOCK_STALE_GC=1 \
GARDEN_ROOT_GUARD_MAINT_INTERVAL_HOURS=0 \
GARDEN_ROOT_GUARD_ESCALATION_RESULT="$GR" \
  "$GARDEN_SYSOP_MAINT_GUARD" >/dev/null 2>&1 || rc=$?

res="$(head -1 "$GR" 2>/dev/null || true)"
case "$res" in
  noop-healthy)    write_result applied "store already maintainable; no stale gc lock to break";;
  gc-ok)           write_result applied "git gc succeeded (no stale lock was in the way)";;
  unlocked-gc-ok)  write_result applied "removed a stale gc.pid lock; git gc then succeeded";;
  refused-live-gc) write_result refused "a live git gc holds the lock; nothing touched (kill it by hand if wedged, then re-issue)";;
  gc-contended)    write_result refused "another git gc took the lock after the unlock (a live concurrent gc); the store is intact and nothing was touched — retry once it clears";;
  gc-intact)       write_result failed  "git gc failed but 0 objects are missing (the store is intact, no alert raised) — a lock/transient/config issue, not damage; inspect the gc error and retry";;
  gc-failed)       write_result failed  "git gc still failing after unlock/refetch — a human alert was raised; refs and history left untouched";;
  '')              write_result applied "guard completed with no escalation outcome recorded (store needed no lock-break)";;
  *)               write_result failed  "unexpected guard escalation result '$res'";;
esac
log "root-repo maintenance finished (guard-result='${res:-<none>}', guard rc=$rc)"
exit 0
