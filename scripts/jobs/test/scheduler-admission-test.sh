#!/bin/bash
# scheduler-admission-test.sh — coverage for recommendation 8 of the cybernetics
# audit (§ 3.4): the scheduler now sends scheduled dispatch through the fleet's one
# admission gate.
#
# Three behaviors, all on the RECURRING path (the `once:` path is unchanged):
#   1. Budget-hold routing — when every bounded budget pool is at high water
#      (budget_fleet_status = backoff), a due dispatch is PARKED in plan/ under the
#      shared budget-hold envelope instead of landing in todo/, and last_dispatched
#      is still stamped in the SAME commit (dispatch stays exactly-once per cadence).
#   2. Occupancy dedup — with `occupancy: skip`, a due tick whose previous instance
#      is still live on the board advances the clock but posts NOTHING (no per-period
#      accumulation); with `occupancy: carry-forward` it posts nothing AND leaves the
#      clock unadvanced (stays due); with no occupancy field it always dispatches.
#   3. Drain posture — under a fleet drain the scheduler dispatches NOTHING and
#      advances NO clock, and resumes with exactly one fire per due schedule on lift.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2; a throwaway git
# repo stands in for the deployed GARDEN_ROOT. No systemd, no live journal.
#
# Usage: scheduler-admission-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient garden env so a live gardener running this test cannot splice the
# real journal/root underneath the hermetic fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-scheduler-admission-test
rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

JBARE="$TR/journal.git"          # stands in for origin/journal2
ROOT="$TR/root"                  # stands in for the deployed GARDEN_ROOT
STATE="$TR/state"                # $GARDEN_STATE (per-host, never committed)
BRANCH=journal2
MAIN=main2
CADENCE=hourly

# --- deployed GARDEN_ROOT that runs THIS scheduler.sh -------------------------
setup_root() {
  rm -rf "$ROOT"
  git init -q "$ROOT"; git -C "$ROOT" checkout -q -b "$MAIN"
  mkdir -p "$ROOT/scripts"
  cp -a "$JOBS/../." "$ROOT/scripts/"
  git -C "$ROOT" "${git_id[@]}" add -A
  git -C "$ROOT" "${git_id[@]}" commit -q -m "deployed root"
}

# --- throwaway journal origin -------------------------------------------------
# $1=schedule name  $2=last_dispatched ISO  $3=extra schedule frontmatter line(s)
# $4=budget-pool file content (empty → no pools file → admission off)
# Optional preseeded live instances are added by the caller after this.
SEED="$TR/seed"
setup_journal() {
  local sname="$1" last="$2" extra="$3" pools="$4"
  rm -rf "$JBARE" "$SEED"
  git init -q --bare "$JBARE"
  git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
  mkdir -p "$SEED/schedules" "$SEED/jobs/todo" "$SEED/jobs/plan" "$SEED/jobs/doin" \
           "$SEED/jobs/tada" "$SEED/inbox/maintainer/unread" "$SEED/config"
  touch "$SEED/jobs/todo/.gitkeep" "$SEED/jobs/plan/.gitkeep" "$SEED/jobs/doin/.gitkeep" \
        "$SEED/jobs/tada/.gitkeep" "$SEED/inbox/maintainer/unread/.gitkeep"
  {
    printf 'cadence: %s\nlast_dispatched: %s\njob_basename_prefix: %s\n' "$CADENCE" "$last" "$sname"
    [ -n "$extra" ] && printf '%s\n' "$extra"
    printf -- '---\nDo the scheduled thing.\n'
  } > "$SEED/schedules/$sname.md"
  [ -n "$pools" ] && printf '%s\n' "$pools" > "$SEED/config/budget-pools"
  git -C "$SEED" "${git_id[@]}" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed schedule $sname"
  git -C "$SEED" remote add origin "$JBARE"
  git -C "$SEED" push -q -u origin "$BRANCH"
}

# Add a preseeded file to the origin (e.g. a still-live prior instance).
seed_file() {  # $1=path-under-journal  $2=content
  local wt="$TR/seedwt"; rm -rf "$wt"
  git clone -q --branch "$BRANCH" "$JBARE" "$wt"
  mkdir -p "$(dirname "$wt/$1")"
  printf '%s\n' "$2" > "$wt/$1"
  git -C "$wt" "${git_id[@]}" add -A
  git -C "$wt" "${git_id[@]}" commit -q -m "seed $1"
  git -C "$wt" push -q
  rm -rf "$wt"
}

run_tick() {  # $1=epoch  $2=out  [extra env assignments...]
  local epoch="$1" out="$2"; shift 2
  env GARDEN=testhost \
    GARDEN_ROOT="$ROOT" \
    GARDEN_STATE="$STATE" \
    GARDEN_MAIN_BRANCH="$MAIN" \
    JOURNAL_REMOTE="$JBARE" \
    JOURNAL_BRANCH="$BRANCH" \
    GARDEN_SCHEDULER_CLONE="$STATE/scheduler/journal" \
    GARDEN_BUDGET_LEVEL_ENABLED=0 \
    GARDEN_SCHEDULER_NOW="$epoch" \
    "$@" \
    "$ROOT/scripts/jobs/scheduler.sh" >"$out" 2>&1 || true
}

sched_field() {  # $1=schedule-name $2=field
  local wt="$TR/peek"; rm -rf "$wt"
  git clone -q --branch "$BRANCH" "$JBARE" "$wt" 2>/dev/null
  sed -n "s/^$2:[[:space:]]*//p" "$wt/schedules/$1.md" | head -1
}
jobs_in() {  # $1=lifecycle dir (todo|plan|doin)  $2=prefix
  local wt="$TR/peek2"; rm -rf "$wt"
  git clone -q --branch "$BRANCH" "$JBARE" "$wt" 2>/dev/null
  find "$wt/jobs/$1" -maxdepth 1 -type f -name "$2-*.md" 2>/dev/null
}
count_in() { jobs_in "$1" "$2" | wc -l | tr -d ' '; }

# A pool at high water: cap 1000, one in-window log of 900 tokens (0.85 mark).
POOLROW='anthropic:testhost anthropic testhost weekly-tokens 1000'
LOGS="$TR/logs"
make_backoff_logs() {
  rm -rf "$LOGS"; mkdir -p "$LOGS/p"
  printf '{"type":"assistant","timestamp":"2026-08-22T06:00:00Z","message":{"id":"live","usage":{"input_tokens":900,"output_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}}}\n' \
    >> "$LOGS/p/session.jsonl"
}
NOW="$(date -u -d 2026-08-22T12:00:00Z +%s)"
LATER=$(( NOW + 3600 ))       # one cadence (hourly) later
LATER2=$(( NOW + 7200 ))

# =============================================================================
hr; echo "1. BUDGET-HOLD ROUTING: fleet at backoff parks the dispatch in plan/, still stamps"
setup_root
make_backoff_logs
setup_journal budget-sched "" "" "$POOLROW"
run_tick "$NOW" "$TR/log-bh" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS"
tp="$(count_in plan budget-sched)"; tt="$(count_in todo budget-sched)"
[ "$tp" = 1 ] && [ "$tt" = 0 ] \
  && ok "due dispatch parked in plan/ (plan=$tp todo=$tt) at fleet backoff" \
  || bad "expected plan=1 todo=0, got plan=$tp todo=$tt"
JOB="$(jobs_in plan budget-sched | head -1)"
if [ -n "$JOB" ]; then
  grep -q '^budget_hold: true$' "$JOB" && ok "parked job carries the budget-hold envelope" \
    || bad "parked job missing budget_hold: true"
  grep -q '^posted_by: scheduler$' "$JOB" && ok "budget-hold envelope names the scheduler as poster" \
    || bad "parked job missing posted_by: scheduler"
  grep -q 'Do the scheduled thing.' "$JOB" && ok "schedule body preserved under the envelope" \
    || bad "schedule body missing from parked job"
else
  bad "no parked job to inspect"
fi
stamp="$(sched_field budget-sched last_dispatched)"
[ -n "$stamp" ] && ok "last_dispatched stamped in the same commit as the parked dispatch ($stamp)" \
  || bad "last_dispatched not stamped on the budget-hold path (lost the period)"

hr; echo "1b. exactly-once: a second tick in the SAME cadence period posts nothing more"
run_tick "$(( NOW + 60 ))" "$TR/log-bh2" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS"
tp2="$(count_in plan budget-sched)"
[ "$tp2" = 1 ] && ok "no second dispatch within the period (plan still $tp2)" \
  || bad "expected plan to stay 1, got $tp2 (double-dispatch)"

hr; echo "1c. no pools file → admission off → routes to todo/ (fail-open), not plan/"
setup_root
setup_journal nopools-sched "" "" ""
run_tick "$NOW" "$TR/log-np"
tt="$(count_in todo nopools-sched)"; tp="$(count_in plan nopools-sched)"
[ "$tt" = 1 ] && [ "$tp" = 0 ] \
  && ok "with no configured pools the dispatch lands in todo/ (todo=$tt plan=$tp)" \
  || bad "expected todo=1 plan=0, got todo=$tt plan=$tp"

# =============================================================================
hr; echo "2. OCCUPANCY skip: a still-live prior instance advances the clock, posts nothing"
setup_root
setup_journal occ-sched "2026-08-22T11:00:00Z" "occupancy: skip" ""
seed_file "jobs/doin/occ-sched-20260822-110000.md" $'# prior instance still running\n'
run_tick "$LATER" "$TR/log-occ"   # due (1h since last), but a live instance exists
tt="$(count_in todo occ-sched)"
[ "$tt" = 0 ] && ok "occupancy=skip posts no new instance while a prior one is live (todo=$tt)" \
  || bad "occupancy=skip still dispatched (todo=$tt)"
occ_stamp="$(sched_field occ-sched last_dispatched)"
occ_epoch="$(date -u -d "$occ_stamp" +%s 2>/dev/null || echo 0)"
[ "$occ_epoch" -ge "$NOW" ] \
  && ok "occupancy=skip advanced the clock ($occ_stamp) so the period is not retried forever" \
  || bad "occupancy=skip did not advance the clock (stamp=$occ_stamp)"
grep -q "occupancy: skip" <(git --git-dir="$JBARE" show "$BRANCH:schedules/occ-sched.md") \
  && ok "occupancy field preserved across the re-stamp" \
  || bad "occupancy field dropped on re-stamp"

hr; echo "2b. OCCUPANCY carry-forward: live instance → no post AND clock NOT advanced"
setup_root
setup_journal occ2-sched "2026-08-22T11:00:00Z" "occupancy: carry-forward" ""
seed_file "jobs/todo/occ2-sched-20260822-110000.md" $'# prior instance still queued\n'
run_tick "$LATER" "$TR/log-occ2"
tt="$(count_in todo occ2-sched)"   # includes the preseeded one; no NEW timestamped one
# The preseeded instance is occ2-sched-20260822-110000; assert no SECOND base appeared.
distinct="$(jobs_in todo occ2-sched | sed 's#.*/##' | sort -u | wc -l | tr -d ' ')"
[ "$distinct" = 1 ] && ok "carry-forward posts no new instance while one is live (distinct=$distinct)" \
  || bad "carry-forward dispatched a new instance (distinct=$distinct)"
cf_stamp="$(sched_field occ2-sched last_dispatched)"
[ "$cf_stamp" = "2026-08-22T11:00:00Z" ] \
  && ok "carry-forward left the clock unadvanced ($cf_stamp) so it stays due" \
  || bad "carry-forward advanced the clock to $cf_stamp (should stay 11:00:00Z)"

hr; echo "2c. OCCUPANCY skip with NO live instance → dispatches normally"
setup_root
setup_journal occ3-sched "2026-08-22T11:00:00Z" "occupancy: skip" ""
run_tick "$LATER" "$TR/log-occ3"
tt="$(count_in todo occ3-sched)"
[ "$tt" = 1 ] && ok "occupancy=skip dispatches when no prior instance is live (todo=$tt)" \
  || bad "occupancy=skip failed to dispatch with a free slot (todo=$tt)"

hr; echo "2d. NO occupancy field → always dispatches even with a live instance (baseline)"
setup_root
setup_journal occ4-sched "2026-08-22T11:00:00Z" "" ""
seed_file "jobs/doin/occ4-sched-20260822-110000.md" $'# prior instance still running\n'
run_tick "$LATER" "$TR/log-occ4"
distinct="$(jobs_in todo occ4-sched | wc -l | tr -d ' ')"
[ "$distinct" = 1 ] && ok "default (no occupancy) dispatches a fresh instance regardless (todo new=$distinct)" \
  || bad "default occupancy behavior changed (todo new=$distinct)"

# =============================================================================
hr; echo "3. DRAIN posture: under a fleet drain, nothing dispatches and no clock advances"
setup_root
setup_journal drain-sched "2026-08-22T11:00:00Z" "" ""
mkdir -p "$STATE"; : > "$STATE/draining"
run_tick "$LATER" "$TR/log-drain"
tt="$(count_in todo drain-sched)"
[ "$tt" = 0 ] && ok "no dispatch while draining (todo=$tt)" || bad "dispatched under drain (todo=$tt)"
d_stamp="$(sched_field drain-sched last_dispatched)"
[ "$d_stamp" = "2026-08-22T11:00:00Z" ] \
  && ok "drain left the clock unadvanced ($d_stamp)" \
  || bad "drain advanced the clock to $d_stamp"
grep -q 'scheduled dispatch suspended' "$TR/log-drain" \
  && ok "drain logs the explicit suspension decision" \
  || bad "drain did not log the suspension: $(cat "$TR/log-drain")"

hr; echo "3b. drain LIFTED: exactly one fire for the current period, cadence resumes"
rm -f "$STATE/draining"
run_tick "$LATER2" "$TR/log-lift"
tt="$(count_in todo drain-sched)"
[ "$tt" = 1 ] && ok "exactly one dispatch on drain lift (todo=$tt), no backlog flood" \
  || bad "expected exactly 1 on lift, got $tt"
l_stamp="$(sched_field drain-sched last_dispatched)"
l_epoch="$(date -u -d "$l_stamp" +%s 2>/dev/null || echo 0)"
[ "$l_epoch" = "$LATER2" ] \
  && ok "clock advanced to the resume tick ($l_stamp), so the cadence marches forward" \
  || bad "clock did not advance to resume time (stamp=$l_stamp)"

hr
echo "RESULT: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
