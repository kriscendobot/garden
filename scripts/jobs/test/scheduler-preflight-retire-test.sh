#!/bin/bash
# scheduler-preflight-retire-test.sh — a `preflight:` gate that retires its own
# schedule through remove-schedule.sh and then exits 2 (dependabotany-preflight.sh
# on a drained ledger). The scheduler's clock-stamp commit then loses the CAS to
# the retirement; the retry must NOT write the schedule back. Asserts:
#   (1) the schedule is absent from the journal after the tick;
#   (2) no job was posted; and
#   (3) the scheduler logged the mid-tick retirement.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2.
#
# Usage: scheduler-preflight-retire-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="${TMPDIR:-/tmp}/garden-scheduler-preflight-retire-test.$$"
rm -rf "$TR"; mkdir -p "$TR/root" "$TR/state" "$TR/bin"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
JBARE="$TR/journal.git"
BRANCH=journal2

cat > "$TR/bin/gate.sh" <<PF
#!/bin/bash
GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" "$JOBS/remove-schedule.sh" "\${1%.md}" || exit 1
exit 2
PF
chmod +x "$TR/bin/gate.sh"

SEED="$TR/seed"
git init -q --bare "$JBARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/schedules" "$SEED/jobs/todo"
touch "$SEED/jobs/todo/.gitkeep" "$SEED/schedules/.gitkeep"
printf 'cadence: 30m\nlast_dispatched: 2026-07-03T00:00:00Z\njob_basename_prefix: retiring\npreflight: %s\n---\nrun the task\n' \
  "$TR/bin/gate.sh" > "$SEED/schedules/retiring.md"
git -C "$SEED" "${git_id[@]}" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$JBARE"
git -C "$SEED" push -q -u origin "$BRANCH"

hr; echo "TICK: gate retires its own schedule, then reports no work"
rc=0
GARDEN=testhost GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" \
  JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN_SCHEDULER_CLONE="$TR/state/scheduler/journal" \
  GARDEN_SCHEDULER_NOW="$(date -u -d 2026-07-03T01:00:00Z +%s)" \
  "$JOBS/scheduler.sh" >"$TR/log" 2>&1 || rc=$?
rm -rf "$TR/check"; git clone -q --branch "$BRANCH" "$JBARE" "$TR/check"
[ "$rc" -eq 0 ] && ok "scheduler exited cleanly" || { bad "scheduler rc=$rc"; cat "$TR/log"; }
[ ! -e "$TR/check/schedules/retiring.md" ] \
  && ok "retired schedule stays retired (stamp did not resurrect it)" \
  || { bad "schedule resurrected"; cat "$TR/check/schedules/retiring.md"; cat "$TR/log"; }
[ -z "$(find "$TR/check/jobs/todo" -maxdepth 1 -name 'retiring*' | head -1)" ] \
  && ok "no job posted" || bad "a job was posted"
grep -q "schedule retiring.md retired mid-tick; skip" "$TR/log" \
  && ok "mid-tick retirement logged" || { bad "no mid-tick retirement log"; cat "$TR/log"; }

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
