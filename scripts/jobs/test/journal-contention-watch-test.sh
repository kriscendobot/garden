#!/bin/bash
# Deterministic anomaly/remedy scenarios for journal-contention-watch.
set -euo pipefail
export GARDEN_TEST=1
# Fixture slugs are bare names, not paths under this garden root: disable the
# foreign-slug filter except in the case that exercises it.
export GARDEN_CONTENTION_SLUG_PREFIX=
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
for n in 1 2 3 4; do sample fetch "$((n * 400))" 5000000 drifty; done
for n in 5 6 7 8; do sample fetch "$((n * 400))" 7000000 drifty; done
for n in 9 10 11 12; do sample fetch "$((n * 400))" 10000000 drifty; done
run_watch 5000; if grep -q journal-fetch-drift-drifty "$NOTICES"; then echo 'FAIL: fetch drift paged before confirmation'; exit 1; fi
run_watch 5300; assert_open journal-fetch-drift-drifty

# The floor GATES drift (2026-09-23: 1.20s -> 2.09s, projected to the guard in
# ~8h, paged under a 10s floor). A steep, long, well-sampled rise below the floor
# never pages, however near its projection.
reset_case
for n in $(seq 1 6); do sample fetch "$((n * 600))" 1200000 lowdrift; done
for n in $(seq 7 12); do sample fetch "$((n * 600))" 2100000 lowdrift; done
run_watch 8000; run_watch 8300; run_watch 8600
if grep -q journal-fetch-drift-lowdrift "$NOTICES"; then echo 'FAIL: drift paged below its floor'; cat "$NOTICES"; exit 1; fi
# Too few samples / too short a span (a short-lived per-job inbox clone) never drifts.
reset_case
for n in 1 2 3; do sample fetch "$n" 5000000 inbox; done
for n in 4 5 6; do sample fetch "$n" 12000000 inbox; done
run_watch 100; run_watch 400
if grep -q journal-fetch-drift-inbox "$NOTICES"; then echo 'FAIL: drift paged on a short-lived clone'; exit 1; fi

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

# Tick deadline: clone work stops once the budget is spent, the heartbeat is still
# written, deferred clones go first next tick, and repeated overrun pages once.
reset_case
for c in aa bb cc; do sample lock-giveup 99 1 "$c"; done
export GARDEN_CONTENTION_TICK_BUDGET=1000 GARDEN_CONTENTION_RESERVE=0 GARDEN_CONTENTION_TEST_SLUG_COST=1000
run_watch 100
assert_open journal-lock-contention-aa
if grep -q 'journal-lock-contention-bb\|journal-lock-contention-cc' "$NOTICES"; then echo 'FAIL: deferred clone was analyzed'; exit 1; fi
grep -q '^outcome: partial-poll$' "$WATCH_STATE/heartbeat" || { echo 'FAIL: partial tick lost heartbeat'; exit 1; }
grep -q '^deferred_clones: 2$' "$WATCH_STATE/heartbeat" || { echo 'FAIL: deferred count missing'; exit 1; }
[ "$(cat "$WATCH_STATE/deferred")" = $'bb\ncc' ] || { echo 'FAIL: deferred list wrong'; exit 1; }
run_watch 400
assert_open journal-lock-contention-bb; assert_open journal-contention-watch-overrun
[ "$(cat "$WATCH_STATE/deferred")" = $'cc\naa' ] || { echo 'FAIL: deferred clones were not run first'; exit 1; }
GARDEN_CONTENTION_TEST_SLUG_COST=0 run_watch 700
assert_open journal-lock-contention-cc
grep -q '^outcome: full-poll$' "$WATCH_STATE/heartbeat" || { echo 'FAIL: full tick not recorded'; exit 1; }
[ ! -e "$WATCH_STATE/deferred" ] || { echo 'FAIL: deferred list survived a full tick'; exit 1; }
grep -q '^--recovered journal-contention-watch-overrun ' "$NOTICES" || { echo 'FAIL: overrun not recovered'; exit 1; }
unset GARDEN_CONTENTION_TICK_BUDGET GARDEN_CONTENTION_RESERVE GARDEN_CONTENTION_TEST_SLUG_COST

# A clone whose object accounting outlives the remaining budget is deferred, not
# read as a healthy 0-byte clone.
reset_case
CLONE="$STATE/slowcount/journal"; mkdir -p "$CLONE"; git -C "$CLONE" init -q
slug="${CLONE//[!A-Za-z0-9]/_}"
SHIM="$TR/shim"; mkdir -p "$SHIM"
printf '#!/bin/bash\ncase " $* " in *" count-objects "*) sleep 10;; esac\nexec %q "$@"\n' "$(command -v git)" > "$SHIM/git"
chmod +x "$SHIM/git"
PATH="$SHIM:$PATH" GARDEN_CONTENTION_TICK_BUDGET=2 GARDEN_CONTENTION_RESERVE=0 run_watch 100
grep -qx "$slug" "$WATCH_STATE/deferred" || { echo 'FAIL: slow clone accounting was not deferred'; exit 1; }
[ ! -e "$WATCH_STATE/stats/$slug" ] || { echo 'FAIL: slow clone recorded partial stats'; exit 1; }

# Too little budget left for a rebuild defers the remedy without a backoff stamp.
reset_case
CLONE="$STATE/producer/journal"; mkdir -p "$CLONE"
git -C "$CLONE" init -q
printf '%2048s' x > "$CLONE/oversized"
git -C "$CLONE" hash-object -w oversized >/dev/null
slug="${CLONE//[!A-Za-z0-9]/_}"
env GARDEN_STATE="$STATE" GARDEN_CONTENTION_DIR="$RINGS" GARDEN_CONTENTION_STATE="$WATCH_STATE" \
  GARDEN_CONTENTION_NOTICE="$NOTICE" JC_NOTICES="$NOTICES" GARDEN_CONTENTION_NOW_EPOCH=1000 \
  GARDEN_JOURNAL_OUTAGE_DIR="$STATE/outage" GARDEN_JOURNAL_OUTAGE_MARKER="$STATE/outage/active" \
  GARDEN_CONTENTION_CLONE_MAX_BYTES=4096 GARDEN_CONTENTION_REMEDY_MIN=100000 \
  GARDEN_CONTENTION_ENSURE_CLONE_CMD="$ENSURE" GARDEN_CONTENTION_DELETE_SYNC=1 \
  "$JOBS/journal-contention-watch.sh"
[ -e "$CLONE/oversized" ] || { echo 'FAIL: remedy ran without enough budget'; exit 1; }
grep -q '^remedy: deferred-deadline$' "$WATCH_STATE/stats/$slug" || { echo 'FAIL: remedy deferral not recorded'; exit 1; }
[ ! -e "$WATCH_STATE/remedy/$slug" ] || { echo 'FAIL: deferred remedy stamped a backoff'; exit 1; }
assert_open "journal-clone-oversized-$slug"

# Quiet low baselines never page.
reset_case
for n in $(seq 1 20); do sample lock-wait "$n" 1000 quiet; sample fetch "$n" 2000 quiet; sample push-attempts "$n" 1 quiet; done
run_watch 100; run_watch 400
[ ! -s "$NOTICES" ] || { echo 'FAIL: quiet baseline paged'; cat "$NOTICES"; exit 1; }

# --- 2026-09-23 false-alarm flood regressions --------------------------------
# Clone guard thresholds: a healthy 57-pack, 55 MB clone (the flood's example) is
# neither flagged nor rebuilt; 1,500 packs or a gc.log still is. count-objects is
# shimmed so the fixture needs no real packs.
countshim() { # packs size-pack-KiB
  mkdir -p "$TR/cshim"
  printf '#!/bin/bash\ncase " $* " in *" count-objects "*) printf "count: 0\\nsize: 0\\nin-pack: 1\\npacks: %s\\nsize-pack: %s\\nprune-packable: 0\\ngarbage: 0\\nsize-garbage: 0\\n"; exit 0;; esac\nexec %q "$@"\n' "$1" "$2" "$(command -v git)" > "$TR/cshim/git"
  chmod +x "$TR/cshim/git"
}
run_remedy() { # now
  env PATH="$TR/cshim:$PATH" GARDEN_STATE="$STATE" GARDEN_CONTENTION_DIR="$RINGS" GARDEN_CONTENTION_STATE="$WATCH_STATE" \
    GARDEN_CONTENTION_NOTICE="$NOTICE" JC_NOTICES="$NOTICES" GARDEN_CONTENTION_NOW_EPOCH="$1" \
    GARDEN_JOURNAL_OUTAGE_DIR="$STATE/outage" GARDEN_JOURNAL_OUTAGE_MARKER="$STATE/outage/active" \
    GARDEN_CONTENTION_ENSURE_CLONE_CMD="$ENSURE" GARDEN_CONTENTION_DELETE_SYNC=1 \
    "$JOBS/journal-contention-watch.sh"
}
reset_case
CLONE="$STATE/sysop/journal"; mkdir -p "$CLONE"; git -C "$CLONE" init -q; : > "$CLONE/marker-file"
slug="${CLONE//[!A-Za-z0-9]/_}"
mkdir -p "$WATCH_STATE/alerts"; : > "$WATCH_STATE/alerts/journal-clone-oversized-$slug"  # the deployed false notice
countshim 57 54168; run_remedy 1000
if grep -q "^journal-clone-oversized-$slug " "$NOTICES"; then echo 'FAIL: healthy 57-pack clone flagged'; exit 1; fi
[ -e "$CLONE/marker-file" ] || { echo 'FAIL: healthy clone was churn-rebuilt'; exit 1; }
grep -q "^--recovered journal-clone-oversized-$slug " "$NOTICES" || { echo 'FAIL: false oversized notice not recovered'; exit 1; }
countshim 128 106420; : > "$NOTICES"; run_remedy 1300
[ ! -s "$NOTICES" ] || { echo 'FAIL: healthy-population max (128 packs) flagged'; cat "$NOTICES"; exit 1; }
countshim 1500 60000; run_remedy 1600
assert_open "journal-clone-oversized-$slug"
[ ! -e "$CLONE/marker-file" ] || { echo 'FAIL: pathological clone not rebuilt'; exit 1; }
reset_case
CLONE="$STATE/gcfail/journal"; mkdir -p "$CLONE"; git -C "$CLONE" init -q; : > "$CLONE/.git/gc.log"
slug="${CLONE//[!A-Za-z0-9]/_}"
countshim 3 100; run_remedy 1000
assert_open "journal-clone-oversized-$slug"

# Old samples age out: one lock give-up no longer pages forever, and its open
# notice recovers once the sample leaves the window.
reset_case; sample lock-giveup 1000 1 aged; run_watch 1100
assert_open journal-lock-contention-aged
: > "$NOTICES"; run_watch $(( 1000 + 21600 + 1 ))
grep -q '^--recovered journal-lock-contention-aged ' "$NOTICES" || { echo 'FAIL: aged-out give-up did not recover'; cat "$NOTICES"; exit 1; }

# Foreign slugs (a test fixture's path, not this garden's) are purged, not paged,
# and an already-open notice for one closes.
reset_case
sample lock-giveup 99 1 _home_kris__garden_fetch_test_clone
sample lock-giveup 99 1 _mine_journal
mkdir -p "$WATCH_STATE/alerts"; : > "$WATCH_STATE/alerts/journal-lock-contention-_home_kris__garden_fetch_test_clone"
GARDEN_CONTENTION_SLUG_PREFIX=_mine_ run_watch 100
grep -q '^--recovered journal-lock-contention-_home_kris__garden_fetch_test_clone ' "$NOTICES" || { echo 'FAIL: foreign-slug notice not closed'; exit 1; }
if grep -q '^journal-lock-contention-_home_kris__garden_fetch_test_clone ' "$NOTICES"; then echo 'FAIL: foreign slug paged'; exit 1; fi
[ ! -e "$RINGS/lock-giveup/_home_kris__garden_fetch_test_clone" ] || { echo 'FAIL: foreign ring not purged'; exit 1; }
assert_open journal-lock-contention-_mine_journal

# A test context with no explicit ring dir records NOTHING into (live) state.
reset_case
env -u GARDEN_CONTENTION_DIR GARDEN_TEST=1 GARDEN_STATE="$STATE" bash -c ". '$JOBS/common.sh'; contention_record /tmp/clone lock-steal 1"
[ ! -e "$STATE/journal-contention/lock-steal/_tmp_clone" ] || { echo 'FAIL: test context wrote the live rings'; exit 1; }

# Storm guard: 7 clones hitting one class in a tick -> ONE summary, no individuals;
# 5 stay individual; the summary closes when the burst subsides.
reset_case
for c in s1 s2 s3 s4 s5 s6 s7; do sample lock-giveup 99 1 "$c"; done
run_watch 100
[ "$(grep -c '^journal-contention-storm-lock-contention ' "$NOTICES")" -eq 1 ] || { echo 'FAIL: storm not collapsed'; cat "$NOTICES"; exit 1; }
if grep -q '^journal-lock-contention-s' "$NOTICES"; then echo 'FAIL: storming class opened individual notices'; exit 1; fi
rm -f "$RINGS/lock-giveup/s6" "$RINGS/lock-giveup/s7"
: > "$NOTICES"; run_watch 400
grep -q '^--recovered journal-contention-storm-lock-contention ' "$NOTICES" || { echo 'FAIL: storm summary not recovered'; exit 1; }
[ "$(grep -c '^journal-lock-contention-s[1-5] ' "$NOTICES")" -eq 5 ] || { echo 'FAIL: sub-storm notices not individual'; cat "$NOTICES"; exit 1; }

echo 'PASS: contention recorder, thresholds, drift, outage latch, clone remedy, recovery, tick deadline, and quiet baseline'
