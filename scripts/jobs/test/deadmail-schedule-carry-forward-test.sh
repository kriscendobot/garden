#!/bin/bash
# deadmail-schedule-carry-forward-test.sh — coverage for routing a dead-lettered
# reply addressed to a RECURRING scheduled fan-out's tick into that schedule's
# durable per-name mailbox, and scheduler.sh draining it into the next dispatch.
#
# Recurring drivers (e.g. the hourly endo-sturdyref-press) dispatch each tick as a
# fresh short-lived doer with a TIMESTAMPED base (<prefix>-YYYYMMDD-HHMMSS) whose
# inbox is torn down at completion, so a sub-job's completion report addressed to
# the spawning tick structurally dead-letters. Instead of the generic-gardener
# restate-and-hope path, deadmail.sh now recognizes that `to:` strips down to an
# active recurring schedule's job_basename_prefix and deposits the report into
# carry-forward/<schedule-stem>/, and scheduler.sh injects any pending report into
# the next dispatched tick body (mirroring the anchored_window context block) and
# drains it in the same CAS commit. Non-schedule recipients keep the generic path.
#
# Hermetic: one throwaway bare journal stands in for origin/journal2; a throwaway
# git repo stands in for the deployed GARDEN_ROOT. No systemd, no live journal.
#
# Usage: deadmail-schedule-carry-forward-test.sh
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
export GARDEN_TEST=1

TR=/home/kris/.garden-deadmail-cf-test
rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

JBARE="$TR/journal.git"          # stands in for origin/journal2
ROOT="$TR/root"                  # stands in for the deployed GARDEN_ROOT
STATE="$TR/state"                # $GARDEN_STATE (per-host, never committed)
BRANCH=journal2
MAIN=main2
PREFIX=endo-sturdyref-press
SCHED="$PREFIX.md"
TICK_BASE="$PREFIX-20260711-190000"      # a dispatched recurring tick's base

# --- deployed GARDEN_ROOT that runs THIS scheduler.sh -------------------------
git init -q "$ROOT"; git -C "$ROOT" checkout -q -b "$MAIN"
mkdir -p "$ROOT/scripts"; cp -a "$JOBS/../." "$ROOT/scripts/"
git -C "$ROOT" "${git_id[@]}" add -A; git -C "$ROOT" "${git_id[@]}" commit -q -m "deployed root"

# --- throwaway journal origin: recurring schedule + a dead-mail to a tick ------
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/schedules" "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada" \
         "$SEED/inbox/dead" "$SEED/inbox/maintainer/unread" "$SEED/inbox/maintainer/read"
for d in jobs/todo jobs/doin jobs/tada inbox/dead inbox/maintainer/unread inbox/maintainer/read; do
  touch "$SEED/$d/.gitkeep"
done
{ printf 'cadence: hourly\nlast_dispatched: \njob_basename_prefix: %s\n' "$PREFIX"
  printf -- '---\nPress the next sturdyref and report.\n'; } > "$SEED/schedules/$SCHED"
# A dead-mail addressed to a DISPATCHED tick of the recurring schedule.
{ printf 'from: %s-child-abc\nto: %s\nsent_at: 2026-07-11T19:20:00Z\n' "$PREFIX" "$TICK_BASE"
  printf -- '---\nSTURDYREF-PRESS RESULT: pressed ref XYZ, persistence OK.\n'; } \
  > "$SEED/inbox/dead/child-abc.md"
# A dead-mail addressed to a NON-schedule doer (control: keeps generic promotion).
{ printf 'from: peer\nto: prune-v1-legacy\nsent_at: 2026-07-11T19:21:00Z\n'
  printf -- '---\nrebase prune-v1-legacy on master before ferrying\n'; } \
  > "$SEED/inbox/dead/other-xyz.md"
git -C "$SEED" "${git_id[@]}" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m "seed"
git init -q --bare "$JBARE"
git -C "$SEED" remote add origin "$JBARE"; git -C "$SEED" push -q -u origin "$BRANCH"

dm_env() {
  env GARDEN=cfhost GARDEN_STATE="$STATE" JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_ROOT="$ROOT" GARDEN_MAIN_BRANCH="$MAIN" "$@"
}
peek() {  # clone a fresh read-only view of origin
  local wt="$TR/peek"; rm -rf "$wt"; git clone -q --branch "$BRANCH" "$JBARE" "$wt" 2>/dev/null; echo "$wt"
}

# =============================================================================
hr; echo "TICK: deadmail routes the schedule-tick reply to the mailbox, promotes the other"
dm_env "$JOBS/deadmail.sh" >"$TR/dm.log" 2>&1 || { echo "deadmail failed:"; cat "$TR/dm.log"; }
WT="$(peek)"
CFDIR="carry-forward/$PREFIX"

n_cf=$(ls -1 "$WT/$CFDIR" 2>/dev/null | grep -vxc '.gitkeep' || true)
[ "$n_cf" -eq 1 ] && ok "schedule-tick reply deposited into $CFDIR ($n_cf file)" \
                  || bad "expected 1 carry-forward file, got $n_cf"
if [ -f "$WT/$CFDIR/child-abc.md" ]; then
  grep -q 'STURDYREF-PRESS RESULT' "$WT/$CFDIR/child-abc.md" \
    && ok "carried mailbox file preserves the full original report" \
    || bad "carried file missing the report body"
else
  bad "carried mailbox file child-abc.md not present"
fi
[ ! -e "$WT/inbox/dead/child-abc.md" ] && ok "schedule-tick dead-mail retired after carry" \
                                       || bad "schedule-tick dead-mail not retired"
# The schedule-tick reply must NOT have spawned a generic deadmail-* gardener job.
n_dm_sched=$(ls -1 "$WT/jobs/todo" | grep -c 'deadmail-child-abc' || true)
[ "$n_dm_sched" -eq 0 ] && ok "no generic gardener spawned for the schedule-tick reply" \
                        || bad "schedule-tick reply wrongly promoted to a generic job ($n_dm_sched)"
# Control: the non-schedule dead-mail keeps the generic-gardener promotion path.
n_dm_other=$(ls -1 "$WT/jobs/todo" | grep -c 'deadmail-other-xyz' || true)
[ "$n_dm_other" -eq 1 ] && ok "non-schedule dead-mail still promoted to a generic gardener job" \
                        || bad "non-schedule dead-mail promotion count=$n_dm_other"
[ ! -e "$WT/inbox/dead/other-xyz.md" ] && ok "non-schedule dead-mail retired after promotion" \
                                       || bad "non-schedule dead-mail not retired"
rm -rf "$WT"

hr; echo "IDEMPOTENT: a re-scan carries nothing new and posts no duplicate"
hb=$(git ls-remote "$JBARE" "refs/heads/$BRANCH" | awk '{print $1}')
dm_env "$JOBS/deadmail.sh" >"$TR/dm2.log" 2>&1 || true
ha=$(git ls-remote "$JBARE" "refs/heads/$BRANCH" | awk '{print $1}')
[ "$hb" = "$ha" ] && ok "deadmail re-scan is a no-op (no new commit)" \
                  || bad "re-scan changed the journal head ($hb→$ha)"

# =============================================================================
hr; echo "SCHEDULER: next tick drains the mailbox into the dispatched job body"
NOW=$(date -u -d '2026-07-11T20:30:00Z' +%s)
dm_env GARDEN_SCHEDULER_CLONE="$STATE/scheduler/journal" GARDEN_SCHEDULER_NOW="$NOW" \
  "$JOBS/scheduler.sh" >"$TR/sch.log" 2>&1 || { echo "scheduler failed:"; cat "$TR/sch.log"; }
WT="$(peek)"
JOB="$(find "$WT/jobs/todo" -maxdepth 1 -type f -name "$PREFIX-*.md" ! -name 'deadmail-*' | head -1)"
if [ -n "$JOB" ]; then
  grep -q 'CARRIED-FORWARD REPORT (child-abc)' "$JOB" \
    && ok "dispatched tick body carries the mailbox report, labelled by its id" \
    || bad "dispatched body missing the carried-forward block"
  grep -q 'STURDYREF-PRESS RESULT' "$JOB" \
    && ok "the actual prior-tick report content reached the next tick" \
    || bad "carried report content missing from the dispatched body"
  grep -q 'Press the next sturdyref and report.' "$JOB" \
    && ok "the schedule's own task body is preserved below the carried block" \
    || bad "schedule task body missing from dispatch"
else
  bad "no dispatched schedule job found to inspect"
fi
n_cf_after=$(ls -1 "$WT/$CFDIR" 2>/dev/null | grep -vxc '.gitkeep' || true)
[ "$n_cf_after" -eq 0 ] && ok "carry-forward mailbox drained (consumed exactly once)" \
                        || bad "mailbox not drained after dispatch ($n_cf_after left)"
rm -rf "$WT"

hr
echo "RESULT: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
