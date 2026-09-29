#!/bin/bash
# A remote-spend failure is one warning per pool/host/operation/reason, with
# suppressed repeats counted until a valid snapshot reports recovery.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-level-snapshot-latch.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

BARE="$TR/journal.git"
SEED="$TR/seed"
STATE="$TR/state"
LOG="$TR/level.log"
POOL=claude-test
HOST=remote
NOW=100000

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -qb journal2
mkdir -p "$SEED"/{budget/live/$POOL,budget/reset-events,config,hosts,usage,jobs/{todo,doin,plan,tada},inbox/maintainer/{unread,read}}
printf '%s\tanthropic\t%s\tweekly-tokens\t500\tusage-panel\t2026-09-29\n' "$POOL" "$HOST" > "$SEED/config/budget-pools"
printf '%s\t%s\tmonk\n' "$POOL" "$HOST" > "$SEED/config/subscription-mapping"
printf 'monk-fleet-ceiling\t1\ncleric-fleet-ceiling\t0\nhost\t%s\t1\t0\n' "$HOST" > "$SEED/config/worker-leveling"
printf 'monks: 1\nclerics: 0\n' > "$SEED/hosts/$HOST"
printf '{"cadence":"manual","reset_at":"1970-01-01T01:00:00Z"}\n' > "$SEED/budget/reset-events/$POOL.jsonl"
touch "$SEED/usage/.gitkeep" "$SEED/jobs"/{todo,doin,plan,tada}/.gitkeep \
  "$SEED/inbox/maintainer"/{unread,read}/.gitkeep

write_snapshot() { # cap sampled-at
  printf 'subscription: %s\ncap: %s\nwindow_start_epoch: 3600\nspend: 42\nsampled_at_epoch: %s\n' \
    "$POOL" "$1" "$2" > "$SEED/budget/live/$POOL/$HOST"
}
commit_seed() {
  git -C "$SEED" add -A
  git -C "$SEED" -c user.name=test -c user.email=test@example.invalid commit -qm "$1"
  git -C "$SEED" push -q origin journal2
}
run_tick() {
  env GARDEN_TEST=1 GARDEN=leader GARDEN_LEADER=leader JOURNAL_REMOTE="$BARE" \
    GARDEN_STATE="$STATE" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_USAGE_NOW="$NOW" \
    GARDEN_BUDGET_LEVEL_UP_CONFIRM=1 "$JOBS/budget-level.sh" >> "$LOG" 2>&1
}

write_snapshot 500 90000
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@example.invalid commit -qm seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -qu origin journal2

run_tick
run_tick
run_tick
[ "$(grep -c 'operation=read-remote-spend failed.*reason=stale-snapshot beyond max-age' "$LOG")" -eq 1 ] \
  || { echo "FAIL: stale snapshot did not collapse to one warning"; cat "$LOG"; exit 1; }
STALE_SUPPRESSED="$(find "$STATE/budget-level/remote-spend-failures" -name suppressed -exec cat {} \;)"
[ "$STALE_SUPPRESSED" = 2 ] \
  || { echo "FAIL: stale snapshot latch counted '$STALE_SUPPRESSED' suppressed repeats, expected 2"; exit 1; }

# A distinct remote-spend reason gets its own edge and counter under the same
# pool, host, and operation.
write_snapshot 999 99990
commit_seed mismatch
run_tick
run_tick
[ "$(grep -c 'operation=read-remote-spend failed.*reason=snapshot-field-mismatch' "$LOG")" -eq 1 ] \
  || { echo "FAIL: field mismatch did not get exactly one warning"; cat "$LOG"; exit 1; }
[ "$(find "$STATE/budget-level/remote-spend-failures" -name suppressed -exec cat {} \; | sort | tr '\n' ' ')" = "1 2 " ] \
  || { echo "FAIL: reason-keyed suppression counters are incorrect"; find "$STATE/budget-level/remote-spend-failures" -type f -print -exec cat {} \;; exit 1; }

write_snapshot 500 99990
commit_seed recovery
run_tick
grep -q 'reason=stale-snapshot beyond max-age after 2 suppressed repeat(s); valid snapshot accepted' "$LOG" \
  || { echo "FAIL: stale recovery did not summarize suppressed repeats"; cat "$LOG"; exit 1; }
grep -q 'reason=snapshot-field-mismatch (pool/cap/window/spend) after 1 suppressed repeat(s); valid snapshot accepted' "$LOG" \
  || { echo "FAIL: mismatch recovery did not summarize suppressed repeats"; cat "$LOG"; exit 1; }
[ -z "$(find "$STATE/budget-level/remote-spend-failures" -mindepth 1 -maxdepth 1 -type d -print -quit)" ] \
  || { echo "FAIL: recovery retained an open failure latch"; exit 1; }

# A healthy tick is silent, while a later stale episode is re-armed.
run_tick
[ "$(grep -c 'remote spend snapshot recovered' "$LOG")" -eq 2 ] \
  || { echo "FAIL: a second healthy tick repeated recovery"; cat "$LOG"; exit 1; }
write_snapshot 500 90000
commit_seed rearm
run_tick
[ "$(grep -c 'operation=read-remote-spend failed.*reason=stale-snapshot beyond max-age' "$LOG")" -eq 2 ] \
  || { echo "FAIL: recovery did not re-arm a later stale-snapshot edge"; cat "$LOG"; exit 1; }

echo "PASS: budget-level remote snapshot failures warn once per reason, count repeats, summarize recovery, and re-arm"
