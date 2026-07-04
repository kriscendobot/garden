#!/bin/bash
# scheduler-anchored-cadence-test.sh — coverage for the DST-aware, drift-free
# anchored wall-clock cadence (`daily-at-HH:MM-<TZ>`) the scheduler grew for the
# daily midnight-Pacific progress-summary periodical.
#
# The interval cadences (weekly/daily/hourly/<N>{s,m,h,d}) fire cad_s seconds after
# the previous dispatch, so a late tick drags every future fire forward. An
# ANCHORED cadence instead pins the fire to a wall-clock time in a named timezone
# and stamps last_dispatched to the ANCHOR instant (not the actual fire time), so:
#   (1) firing late in the local day does NOT shift tomorrow's anchor;
#   (2) the stamp is always local-midnight (00:00 Pacific) in UTC; and
#   (3) the day-to-day step is one LOCAL day (DST-aware), not a fixed 86400s.
# This test also asserts the scheduler injects the concrete "prior 24 hours" window
# and Pacific-date output path into the dispatched job body.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2; a throwaway git
# repo stands in for the deployed GARDEN_ROOT. No systemd, no live journal.
#
# Usage: scheduler-anchored-cadence-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient garden env so a live gardener running this test cannot splice the
# real journal/root underneath the hermetic fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-scheduler-anchored-cadence-test
rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

JBARE="$TR/journal.git"          # stands in for origin/journal2
ROOT="$TR/root"                  # stands in for the deployed GARDEN_ROOT
STATE="$TR/state"                # $GARDEN_STATE (per-host, never committed)
SCHED=daily-progress-summary.md
TZ_NAME=America/Los_Angeles
CADENCE="daily-at-00:00-$TZ_NAME"
BRANCH=journal2
MAIN=main2

# --- deployed GARDEN_ROOT that runs THIS scheduler.sh -------------------------
setup_root() {
  rm -rf "$ROOT"
  git init -q "$ROOT"; git -C "$ROOT" checkout -q -b "$MAIN"
  mkdir -p "$ROOT/scripts"
  cp -a "$JOBS/../." "$ROOT/scripts/"
  git -C "$ROOT" "${git_id[@]}" add -A
  git -C "$ROOT" "${git_id[@]}" commit -q -m "deployed root"
}

# --- throwaway journal origin with the anchored-cadence schedule --------------
setup_journal() {  # $1=last_dispatched ISO (may be empty)
  rm -rf "$JBARE" "$TR/seed"
  git init -q --bare "$JBARE"
  local SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
  mkdir -p "$SEED/schedules" "$SEED/jobs/todo" "$SEED/inbox/maintainer/unread"
  touch "$SEED/jobs/todo/.gitkeep" "$SEED/inbox/maintainer/unread/.gitkeep"
  {
    printf 'cadence: %s\nlast_dispatched: %s\njob_basename_prefix: daily-progress-summary\n' "$CADENCE" "$1"
    printf -- '---\nWrite the daily progress summary periodical.\n'
  } > "$SEED/schedules/$SCHED"
  git -C "$SEED" "${git_id[@]}" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed anchored-cadence schedule"
  git -C "$SEED" remote add origin "$JBARE"
  git -C "$SEED" push -q -u origin "$BRANCH"
}

run_tick() {  # $1=epoch  $2=out
  GARDEN=testhost \
  GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$STATE" \
  GARDEN_MAIN_BRANCH="$MAIN" \
  JOURNAL_REMOTE="$JBARE" \
  JOURNAL_BRANCH="$BRANCH" \
  GARDEN_SCHEDULER_CLONE="$STATE/scheduler/journal" \
  GARDEN_SCHEDULER_NOW="$1" \
    "$ROOT/scripts/jobs/scheduler.sh" >"$2" 2>&1 || true
}

# read a field back from origin/journal2
sched_field() {  # $1=field
  local wt="$TR/peek"; rm -rf "$wt"
  git clone -q --branch "$BRANCH" "$JBARE" "$wt" 2>/dev/null
  sed -n "s/^$1:[[:space:]]*//p" "$wt/schedules/$SCHED" | head -1
}
todo_files() {
  local wt="$TR/peek2"; rm -rf "$wt"
  git clone -q --branch "$BRANCH" "$JBARE" "$wt" 2>/dev/null
  find "$wt/jobs/todo" -maxdepth 1 -type f ! -name '.gitkeep' 2>/dev/null
}
todo_count() { todo_files | wc -l | tr -d ' '; }

# epochs (UTC) for the scenario. The anchor for TZ_NAME midnight of a given local
# day is what the stamp must equal.
EVENING_JUL3=$(date -u -d '2026-07-03T20:05:00-07:00' +%s)     # late fire, Jul 3 evening PDT
ANCHOR_JUL3=$(TZ=$TZ_NAME date -d '2026-07-03 00:00' +%s)      # intended anchor
LATER_JUL3=$(date -u -d '2026-07-03T23:30:00-07:00' +%s)       # same local day, hours later
NEXT_JUL4=$(date -u -d '2026-07-04T00:30:00-07:00' +%s)        # just past next midnight PDT
ANCHOR_JUL4=$(TZ=$TZ_NAME date -d '2026-07-04 00:00' +%s)

# =============================================================================
hr; echo "SETUP: fresh anchored schedule, never dispatched"
setup_root
setup_journal ""     # empty last_dispatched → first anchor is due

hr; echo "TICK 1: fire LATE (Jul 3 20:05 PDT), well after the 00:00 anchor"
run_tick "$EVENING_JUL3" "$TR/log1"
n="$(todo_count)"
[ "$n" = "1" ] && ok "one job dispatched on first due tick (todo=$n)" \
                || bad "expected 1 dispatched job, got $n"

got_stamp="$(sched_field last_dispatched)"
got_epoch="$(date -u -d "$got_stamp" +%s 2>/dev/null || echo 0)"
[ "$got_epoch" = "$ANCHOR_JUL3" ] \
  && ok "last_dispatched stamped to the ANCHOR (Jul 3 00:00 PDT = $got_stamp), not the fire time" \
  || bad "stamp is $got_stamp ($got_epoch); expected anchor $ANCHOR_JUL3 (drift! stamped the fire time?)"

# The dispatched body must carry the injected window + Pacific-date output path.
JOB="$(todo_files | head -1)"
if [ -n "$JOB" ]; then
  grep -q 'window_end: 2026-07-03T07:00:00Z' "$JOB" \
    && ok "body window_end pinned to the anchor instant (07:00Z = 00:00 PDT)" \
    || bad "body missing/incorrect window_end: $(grep -i window_end "$JOB" || echo none)"
  grep -q 'window_start: 2026-07-02T07:00:00Z' "$JOB" \
    && ok "body window_start is anchor minus one LOCAL day" \
    || bad "body missing/incorrect window_start: $(grep -i window_start "$JOB" || echo none)"
  grep -q 'pacific_date: 2026-07-02' "$JOB" \
    && ok "body pacific_date is the day that just closed (2026-07-02)" \
    || bad "body pacific_date wrong: $(grep -i pacific_date "$JOB" || echo none)"
  grep -q 'journal/periodicals/2026/07/02.md' "$JOB" \
    && ok "body output path is periodicals/2026/07/02.md" \
    || bad "body output path wrong: $(grep -i output "$JOB" || echo none)"
  grep -q 'Write the daily progress summary periodical.' "$JOB" \
    && ok "original schedule body preserved below the injected context" \
    || bad "original body missing from dispatched job"
else
  bad "no dispatched job file found to inspect"
fi

hr; echo "TICK 2: SAME local day, hours later (Jul 3 23:30 PDT) → NOT due"
run_tick "$LATER_JUL3" "$TR/log2"
n="$(todo_count)"
[ "$n" = "1" ] && ok "no second dispatch same local day (todo still $n) — anchor already served" \
                || bad "expected todo to stay 1, got $n (re-fired within the same anchor day)"

hr; echo "TICK 3: just past NEXT local midnight (Jul 4 00:30 PDT) → due again"
run_tick "$NEXT_JUL4" "$TR/log3"
n="$(todo_count)"
[ "$n" = "2" ] && ok "second day dispatched exactly one new job (todo=$n)" \
                || bad "expected 2 jobs after next-day tick, got $n"
got_stamp2="$(sched_field last_dispatched)"
got_epoch2="$(date -u -d "$got_stamp2" +%s 2>/dev/null || echo 0)"
[ "$got_epoch2" = "$ANCHOR_JUL4" ] \
  && ok "stamp advanced to the NEXT anchor (Jul 4 00:00 PDT = $got_stamp2)" \
  || bad "stamp is $got_stamp2 ($got_epoch2); expected next anchor $ANCHOR_JUL4"

# The anchor step is exactly one local day; in July (no DST change) that is 86400s.
step=$(( got_epoch2 - got_epoch ))
[ "$step" = "86400" ] \
  && ok "anchor-to-anchor step is exactly one local day (86400s), drift-free despite the late TICK 1" \
  || bad "anchor step is ${step}s; expected 86400 (drift crept in)"

# =============================================================================
hr; echo "DST SPRING-FORWARD: the local day is 23h, and the anchor still lands at 00:00 local"
# 2026-03-08 is the US spring-forward day (02:00 PST -> 03:00 PDT); that local day
# is 23 hours. A fire just past the Mar 9 00:00 PDT anchor must stamp Mar 9 00:00
# local, and the Mar 8 -> Mar 9 anchor step must be 23h (not 24h).
ANCHOR_MAR8=$(TZ=$TZ_NAME date -d '2026-03-08 00:00' +%s)
ANCHOR_MAR9=$(TZ=$TZ_NAME date -d '2026-03-09 00:00' +%s)
setup_journal "$(date -u -d "@$ANCHOR_MAR8" +%FT%TZ)"        # stamped at the Mar 8 anchor
MAR9_FIRE=$(date -u -d '2026-03-09T00:30:00-07:00' +%s)      # just past Mar 9 00:00 PDT
run_tick "$MAR9_FIRE" "$TR/logdst"
dst_stamp="$(sched_field last_dispatched)"
dst_epoch="$(date -u -d "$dst_stamp" +%s 2>/dev/null || echo 0)"
[ "$dst_epoch" = "$ANCHOR_MAR9" ] \
  && ok "spring-forward anchor stamped to Mar 9 00:00 local ($dst_stamp)" \
  || bad "DST stamp is $dst_stamp ($dst_epoch); expected $ANCHOR_MAR9"
dst_step=$(( ANCHOR_MAR9 - ANCHOR_MAR8 ))
[ "$dst_step" = "82800" ] \
  && ok "spring-forward day spanned as 23h (82800s), DST handled by zoneinfo" \
  || bad "DST day step is ${dst_step}s; expected 82800 (23h)"

hr
echo "RESULT: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
