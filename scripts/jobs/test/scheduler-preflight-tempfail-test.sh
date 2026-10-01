#!/bin/bash
# scheduler-preflight-tempfail-test.sh — coverage for a schedule `preflight:` gate
# that exits 75 (EX_TEMPFAIL, "cannot decide right now", e.g. the shared gh-api
# cooldown latch is live). Before this, scheduler.sh treated rc=75 as work-present
# (fail open), so dependabotany-recheck dispatched a botanist every tick for the
# whole cooldown window (2026-10-01). Now rc=75:
#   (1) posts no job;
#   (2) leaves last_dispatched unchanged, so the schedule stays due; and
#   (3) logs the deferral; while
#   (4) the next tick, with the gate deciding (exit 0), dispatches normally.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2.
#
# Usage: scheduler-preflight-tempfail-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="${TMPDIR:-/tmp}/garden-scheduler-preflight-tempfail-test.$$"
rm -rf "$TR"; mkdir -p "$TR/root" "$TR/state" "$TR/bin"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
JBARE="$TR/journal.git"
BRANCH=journal2
LAST=2026-07-03T00:00:00Z

# The gate's verdict is read from a file so the two ticks can differ.
cat > "$TR/bin/gate.sh" <<PF
#!/bin/bash
exit "\$(cat "$TR/verdict")"
PF
chmod +x "$TR/bin/gate.sh"

SEED="$TR/seed"
git init -q --bare "$JBARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/schedules" "$SEED/jobs/todo"
touch "$SEED/jobs/todo/.gitkeep"
printf 'cadence: 30m\nlast_dispatched: %s\njob_basename_prefix: deferred\npreflight: %s\n---\nrun the task\n' \
  "$LAST" "$TR/bin/gate.sh" > "$SEED/schedules/deferred.md"
git -C "$SEED" "${git_id[@]}" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$JBARE"
git -C "$SEED" push -q -u origin "$BRANCH"

tick() {  # tick <iso-now> <log>
  GARDEN=testhost \
  GARDEN_ROOT="$TR/root" \
  GARDEN_STATE="$TR/state" \
  JOURNAL_REMOTE="$JBARE" \
  JOURNAL_BRANCH="$BRANCH" \
  GARDEN_SCHEDULER_CLONE="$TR/state/scheduler/journal" \
  GARDEN_SCHEDULER_NOW="$(date -u -d "$1" +%s)" \
    "$JOBS/scheduler.sh" >"$2" 2>&1 || true
}
inspect() {  # refresh $TR/check from the bare journal
  rm -rf "$TR/check"; git clone -q --branch "$BRANCH" "$JBARE" "$TR/check"
}

hr; echo "TICK 1: gate exits 75 (deferred)"
echo 75 > "$TR/verdict"
tick 2026-07-03T01:00:00Z "$TR/log1"
inspect
[ -z "$(find "$TR/check/jobs/todo" -maxdepth 1 -name 'deferred*' | head -1)" ] \
  && ok "no job posted on rc=75" || bad "rc=75 dispatched a job (fail-open)"
grep -q "^last_dispatched: $LAST\$" "$TR/check/schedules/deferred.md" \
  && ok "clock not advanced (schedule stays due)" \
  || { bad "last_dispatched changed"; cat "$TR/check/schedules/deferred.md"; }
grep -q "preflight deferred for deferred.md (rc=75" "$TR/log1" \
  && ok "deferral logged" || { bad "no deferral log"; cat "$TR/log1"; }

hr; echo "TICK 2: cooldown over, gate exits 0 (work present)"
echo 0 > "$TR/verdict"
tick 2026-07-03T01:05:00Z "$TR/log2"
inspect
[ -n "$(find "$TR/check/jobs/todo" -maxdepth 1 -name 'deferred*' | head -1)" ] \
  && ok "deferred schedule dispatches once the gate decides" || { bad "no dispatch on tick 2"; cat "$TR/log2"; }
grep -q "^last_dispatched: $LAST\$" "$TR/check/schedules/deferred.md" \
  && bad "clock not advanced after dispatch" || ok "clock advanced after dispatch"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
