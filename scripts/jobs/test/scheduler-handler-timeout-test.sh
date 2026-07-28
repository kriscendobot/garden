#!/bin/bash
# scheduler-handler-timeout-test.sh — schedule-declared handler budgets survive
# scheduler rewrites and become per-job frontmatter only when safe.
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
TR="$(mktemp -d /tmp/garden-scheduler-handler-timeout.XXXXXX)"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
JBARE="$TR/journal.git"
ROOT="$TR/root"
STATE="$TR/state"
BRANCH=journal2
MAIN=main2

setup_root() {
  git init -q "$ROOT"
  git -C "$ROOT" checkout -q -b "$MAIN"
  mkdir -p "$ROOT/scripts"
  cp -a "$JOBS/../." "$ROOT/scripts/"
  git -C "$ROOT" "${git_id[@]}" add -A
  git -C "$ROOT" "${git_id[@]}" commit -q -m "deployed root"
}

setup_journal() { # $1=handler-timeout
  rm -rf "$JBARE" "$TR/seed" "$STATE"
  git init -q --bare "$JBARE"
  local seed="$TR/seed"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  mkdir -p "$seed/schedules" "$seed/jobs/todo"
  touch "$seed/jobs/todo/.gitkeep"
  {
    printf 'cadence: hourly\nlast_dispatched: \njob_basename_prefix: timeout-test\n'
    printf 'handler-timeout: %s\n---\nrun the scheduled task\n' "$1"
  } > "$seed/schedules/timeout-test.md"
  git -C "$seed" "${git_id[@]}" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed schedule"
  git -C "$seed" remote add origin "$JBARE"
  git -C "$seed" push -q -u origin "$BRANCH"
}

run_tick() {
  GARDEN=testhost GARDEN_ROOT="$ROOT" GARDEN_STATE="$STATE" \
  GARDEN_MAIN_BRANCH="$MAIN" JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN_SCHEDULER_CLONE="$STATE/scheduler/journal" GARDEN_SCHEDULER_NOW=2000000000 \
    bash "$ROOT/scripts/jobs/scheduler.sh" >"$TR/tick.log" 2>&1
}

peek() {
  rm -rf "$TR/peek"
  git clone -q --branch "$BRANCH" "$JBARE" "$TR/peek"
}

setup_root
setup_journal 7200
printf 'updated schedule body\n' | \
  GARDEN_STATE="$STATE" JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN_SCHEDULE_HANDLER_TIMEOUT=7200 \
  bash "$ROOT/scripts/jobs/set-schedule.sh" timeout-test hourly timeout-test >/dev/null
peek
grep -qx 'handler-timeout: 7200' "$TR/peek/schedules/timeout-test.md" \
  && ok "set-schedule writes a declared timeout" \
  || bad "set-schedule did not write declared timeout"
printf 'preserved schedule body\n' | \
  GARDEN_STATE="$STATE" JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH="$BRANCH" \
  bash "$ROOT/scripts/jobs/set-schedule.sh" timeout-test hourly timeout-test >/dev/null
peek
grep -qx 'handler-timeout: 7200' "$TR/peek/schedules/timeout-test.md" \
  && ok "set-schedule preserves timeout on later edits" \
  || bad "set-schedule dropped timeout on later edit"
run_tick
peek
job="$(find "$TR/peek/jobs/todo" -type f ! -name .gitkeep | head -1)"
grep -qx 'handler-timeout: 7200' "$TR/peek/schedules/timeout-test.md" \
  && ok "valid timeout survives last_dispatched rewrite" \
  || bad "valid timeout was dropped from schedule"
[ -n "$job" ] && grep -q '^handler-timeout: 7200$' "$job" \
  && ok "valid timeout is stamped into dispatched job frontmatter" \
  || bad "valid timeout was not stamped into dispatched job"

setup_journal 0
run_tick
peek
job="$(find "$TR/peek/jobs/todo" -type f ! -name .gitkeep | head -1)"
grep -q "invalid handler-timeout '0'" "$TR/tick.log" \
  && ok "non-positive timeout is logged and ignored" \
  || bad "non-positive timeout did not produce validation warning"
[ -n "$job" ] && ! grep -q '^handler-timeout:' "$job" \
  && ok "non-positive timeout is not stamped into dispatched job" \
  || bad "non-positive timeout reached dispatched job"

setup_journal 14340
run_tick
peek
job="$(find "$TR/peek/jobs/todo" -type f ! -name .gitkeep | head -1)"
grep -q 'exceeds claim budget max 14339s' "$TR/tick.log" \
  && ok "over-limit timeout is logged and ignored" \
  || bad "over-limit timeout did not produce validation warning"
[ -n "$job" ] && ! grep -q '^handler-timeout:' "$job" \
  && ok "over-limit timeout is not stamped into dispatched job" \
  || bad "over-limit timeout reached dispatched job"

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
