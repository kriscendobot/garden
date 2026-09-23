#!/bin/bash
# Deterministic anomaly/remedy scenarios for journal-contention-watch.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d)"; trap 'rm -rf "$TR"' EXIT
STATE="$TR/state"; RINGS="$STATE/journal-contention"; WATCH_STATE="$STATE/journal-contention-watch"
NOTICES="$TR/notices"

NOTICE="$TR/notice.sh"
cat > "$NOTICE" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >> "$JC_NOTICES"
EOF
ENSURE="$TR/ensure.sh"
cat > "$ENSURE" <<'EOF'
#!/bin/bash
mkdir -p "$1/.git/objects/pack"
printf 'ref: refs/heads/journal2\n' > "$1/.git/HEAD"
EOF
chmod +x "$NOTICE" "$ENSURE"

reset_case() { rm -rf "$STATE"; mkdir -p "$RINGS"; : > "$NOTICES"; }
sample() { mkdir -p "$RINGS/$1"; printf '%s %s\n' "$2" "$3" >> "$RINGS/$1/$4"; }
run_watch() {
  env GARDEN_STATE="$STATE" GARDEN_CONTENTION_DIR="$RINGS" GARDEN_CONTENTION_STATE="$WATCH_STATE" \
    GARDEN_CONTENTION_RING="${GARDEN_CONTENTION_RING:-512}" \
    GARDEN_CONTENTION_NOTICE="$NOTICE" JC_NOTICES="$NOTICES" GARDEN_CONTENTION_NOW_EPOCH="$1" \
    GARDEN_JOURNAL_OUTAGE_DIR="$STATE/outage" GARDEN_JOURNAL_OUTAGE_MARKER="$STATE/outage/active" \
    GARDEN_CONTENTION_REMEDY=0 "$JOBS/journal-contention-watch.sh"
}
assert_open() { grep -q "^$1 " "$NOTICES" || { echo "FAIL: missing notice $1"; cat "$NOTICES"; exit 1; }; }

# Recorder gating and ring trimming.
reset_case
GARDEN_STATE="$STATE" GARDEN_CONTENTION_DIR="$RINGS" bash -c ". '$JOBS/common.sh'; contention_record /tmp/clone lock-steal 1"
[ "$(wc -l < "$RINGS/lock-steal/_tmp_clone")" -eq 1 ]
GARDEN_STATE="$STATE" GARDEN_CONTENTION_DIR="$RINGS" GARDEN_CONTENTION_INSTRUMENT=0 \
  bash -c ". '$JOBS/common.sh'; contention_record /tmp/clone lock-steal 1"
[ "$(wc -l < "$RINGS/lock-steal/_tmp_clone")" -eq 1 ]
for n in $(seq 2 20); do sample lock-steal "$n" 1 trim; done
GARDEN_CONTENTION_RING=5 run_watch 100
[ "$(wc -l < "$RINGS/lock-steal/trim")" -eq 5 ] || { echo 'FAIL: ring was not trimmed'; exit 1; }

# A full lock-wait window above a quiet baseline pages only on confirmation tick.
reset_case
for n in $(seq 1 9); do sample lock-wait "$n" 1000000 locky; done
sample lock-wait 10 60000000 locky
run_watch 100; if grep -q journal-lock-contention-locky "$NOTICES"; then echo 'FAIL: lock baseline paged before confirmation'; exit 1; fi
run_watch 400; assert_open journal-lock-contention-locky

# Give-up is a first-tick hard guard.
reset_case; sample lock-giveup 99 1 locky; run_watch 100
assert_open journal-lock-contention-locky

# Push retries above baseline confirm on the second tick; reaching 50 is immediate.
reset_case
for n in $(seq 1 9); do sample push-attempts "$n" 1 pushy; done
sample push-attempts 10 5 pushy
run_watch 100; if grep -q journal-push-contention-pushy "$NOTICES"; then echo 'FAIL: push baseline paged before confirmation'; exit 1; fi
run_watch 400; assert_open journal-push-contention-pushy
reset_case; sample push-attempts 1 50 wedged; run_watch 100
assert_open journal-push-contention-wedged

# Fetch approaching 70% of the cap is immediate. Slow 1.5x drift confirms twice.
reset_case; sample fetch 1 31500000 fetchy; run_watch 100
assert_open journal-fetch-slow-fetchy
reset_case
for n in 1 2 3; do sample fetch "$n" 5000000 drifty; done
for n in 4 5 6; do sample fetch "$n" 7000000 drifty; done
for n in 7 8 9; do sample fetch "$n" 10000000 drifty; done
run_watch 100; if grep -q journal-fetch-drift-drifty "$NOTICES"; then echo 'FAIL: fetch drift paged before confirmation'; exit 1; fi
run_watch 400; assert_open journal-fetch-drift-drifty

# Re-arming latch + skips opens once after ten minutes, stays coalesced, recovers.
reset_case; mkdir -p "$STATE/outage"
for now in 1000 1301 1602 1903; do
  sample outage-skip "$((now-1))" 1 host
  printf '%s\ntest\n' "$((now+900))" > "$STATE/outage/marker"
  run_watch "$now"
done
assert_open journal-outage-stuck
[ "$(grep -c '^journal-outage-stuck ' "$NOTICES")" -eq 1 ] || { echo 'FAIL: stuck latch was not coalesced'; exit 1; }
run_watch 2204
grep -q '^--recovered journal-outage-stuck ' "$NOTICES" || { echo 'FAIL: outage recovery not closed'; exit 1; }

# An oversized per-instance clone is losslessly renamed, rebuilt, and recovery closes.
# The production threshold is 2 GiB; lower it here so a real loose Git object
# drives the identical byte-accounting path without allocating a giant fixture.
reset_case
CLONE="$STATE/producer/journal"; mkdir -p "$CLONE"
git -C "$CLONE" init -q
printf '%2048s' x > "$CLONE/oversized"
git -C "$CLONE" hash-object -w oversized >/dev/null
slug="${CLONE//[!A-Za-z0-9]/_}"
env GARDEN_STATE="$STATE" GARDEN_CONTENTION_DIR="$RINGS" GARDEN_CONTENTION_STATE="$WATCH_STATE" \
  GARDEN_CONTENTION_NOTICE="$NOTICE" JC_NOTICES="$NOTICES" GARDEN_CONTENTION_NOW_EPOCH=1000 \
  GARDEN_JOURNAL_OUTAGE_DIR="$STATE/outage" GARDEN_JOURNAL_OUTAGE_MARKER="$STATE/outage/active" \
  GARDEN_CONTENTION_CLONE_MAX_BYTES=4096 \
  GARDEN_CONTENTION_ENSURE_CLONE_CMD="$ENSURE" GARDEN_CONTENTION_DELETE_SYNC=1 \
  "$JOBS/journal-contention-watch.sh"
if [ ! -d "$CLONE/.git" ] || [ -e "$CLONE/oversized" ]; then echo 'FAIL: oversized clone was not rebuilt'; exit 1; fi
assert_open "journal-clone-oversized-$slug"
sample fetch 1200 1000000 "$slug"
env GARDEN_STATE="$STATE" GARDEN_CONTENTION_DIR="$RINGS" GARDEN_CONTENTION_STATE="$WATCH_STATE" \
  GARDEN_CONTENTION_NOTICE="$NOTICE" JC_NOTICES="$NOTICES" GARDEN_CONTENTION_NOW_EPOCH=1300 \
  GARDEN_JOURNAL_OUTAGE_DIR="$STATE/outage" GARDEN_JOURNAL_OUTAGE_MARKER="$STATE/outage/active" \
  GARDEN_CONTENTION_CLONE_MAX_BYTES=4096 \
  GARDEN_CONTENTION_ENSURE_CLONE_CMD="$ENSURE" GARDEN_CONTENTION_DELETE_SYNC=1 \
  "$JOBS/journal-contention-watch.sh"
grep -q "^--recovered journal-clone-oversized-$slug " "$NOTICES" || { echo 'FAIL: clone recovery not closed'; exit 1; }

# Quiet low baselines never page.
reset_case
for n in $(seq 1 20); do sample lock-wait "$n" 1000 quiet; sample fetch "$n" 2000 quiet; sample push-attempts "$n" 1 quiet; done
run_watch 100; run_watch 400
[ ! -s "$NOTICES" ] || { echo 'FAIL: quiet baseline paged'; cat "$NOTICES"; exit 1; }

echo 'PASS: contention recorder, thresholds, drift, outage latch, clone remedy, recovery, and quiet baseline'
