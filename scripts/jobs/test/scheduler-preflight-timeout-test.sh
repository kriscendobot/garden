#!/bin/bash
# scheduler-preflight-timeout-test.sh — coverage for the wall-clock bound on a
# schedule's `preflight:` gate. Before the bound, scheduler.sh ran the gate with no
# timeout, so one wedged gate consumed the whole garden-scheduler oneshot start
# budget (TimeoutStartSec) and the unit timed out. The bound:
#   (1) kills a gate that outlives GARDEN_SCHEDULER_PREFLIGHT_TIMEOUT;
#   (2) logs the schedule name on expiry;
#   (3) preserves fail-open dispatch (the wedged schedule still posts its job);
#   (4) discards the partial context the killed gate wrote; and
#   (5) leaves later schedules in the same tick unaffected.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2.
#
# Usage: scheduler-preflight-timeout-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="${TMPDIR:-/tmp}/garden-scheduler-preflight-timeout-test.$$"
rm -rf "$TR"; mkdir -p "$TR/root" "$TR/state" "$TR/bin"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
JBARE="$TR/journal.git"
BRANCH=journal2

# A gate that writes routing context and then wedges far past the bound.
cat > "$TR/bin/wedged-preflight.sh" <<'PF'
#!/bin/bash
printf 'WEDGED-CONTEXT-MUST-NOT-DISPATCH\n' > "$GARDEN_PREFLIGHT_CONTEXT_FILE"
exec sleep 300
PF
# A healthy gate that says "work present" with context.
cat > "$TR/bin/ok-preflight.sh" <<'PF'
#!/bin/bash
printf 'OK-CONTEXT\n' > "$GARDEN_PREFLIGHT_CONTEXT_FILE"
exit 0
PF
chmod +x "$TR/bin/"*.sh

SEED="$TR/seed"
git init -q --bare "$JBARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/schedules" "$SEED/jobs/todo"
touch "$SEED/jobs/todo/.gitkeep"
printf 'cadence: 30m\nlast_dispatched: 2026-07-03T00:00:00Z\njob_basename_prefix: a-wedged\npreflight: %s\n---\nrun the wedged task\n' \
  "$TR/bin/wedged-preflight.sh" > "$SEED/schedules/a-wedged.md"
printf 'cadence: 30m\nlast_dispatched: 2026-07-03T00:00:00Z\njob_basename_prefix: b-healthy\npreflight: %s\n---\nrun the healthy task\n' \
  "$TR/bin/ok-preflight.sh" > "$SEED/schedules/b-healthy.md"
git -C "$SEED" "${git_id[@]}" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$JBARE"
git -C "$SEED" push -q -u origin "$BRANCH"

hr; echo "RUN: one tick with a 2s preflight bound"
T1=$(date -u -d 2026-07-03T01:00:00Z +%s)
start=$(date +%s)
GARDEN=testhost \
GARDEN_ROOT="$TR/root" \
GARDEN_STATE="$TR/state" \
JOURNAL_REMOTE="$JBARE" \
JOURNAL_BRANCH="$BRANCH" \
GARDEN_SCHEDULER_CLONE="$TR/state/scheduler/journal" \
GARDEN_SCHEDULER_NOW="$T1" \
GARDEN_SCHEDULER_PREFLIGHT_TIMEOUT=2 \
GARDEN_SCHEDULER_PREFLIGHT_KILL_AFTER=1 \
  "$JOBS/scheduler.sh" >"$TR/log" 2>&1 || true
elapsed=$(( $(date +%s) - start ))

hr; echo "CHECK"
[ "$elapsed" -lt 60 ] && ok "tick finished in ${elapsed}s (wedged gate did not hold it)" \
                      || bad "tick took ${elapsed}s — the preflight was not bounded"
grep -q "WARN schedule a-wedged.md preflight .* exceeded 2s" "$TR/log" \
  && ok "expiry logged with the schedule name" || { bad "no expiry WARN naming a-wedged.md"; cat "$TR/log"; }

wt="$TR/check"; git clone -q --branch "$BRANCH" "$JBARE" "$wt"
wedged="$(find "$wt/jobs/todo" -maxdepth 1 -name 'a-wedged*' | head -1)"
healthy="$(find "$wt/jobs/todo" -maxdepth 1 -name 'b-healthy*' | head -1)"
[ -n "$wedged" ] && ok "wedged schedule still dispatched (fail-open)" || bad "wedged schedule did not dispatch"
if [ -n "$wedged" ]; then
  grep -q WEDGED-CONTEXT "$wedged" && bad "killed gate's partial context leaked into the job" \
                                   || ok "killed gate's context discarded"
fi
[ -n "$healthy" ] && ok "later schedule in the same tick dispatched" || bad "later schedule did not dispatch"
[ -n "$healthy" ] && grep -q OK-CONTEXT "$healthy" && ok "healthy gate's context still injected" \
                  || bad "healthy gate's context missing"
leftover="$(find "${TMPDIR:-/tmp}" -maxdepth 1 -newer "$SEED/schedules/a-wedged.md" -name 'tmp.*' -type f -exec grep -l WEDGED-CONTEXT {} + 2>/dev/null | wc -l)"
[ "$leftover" = "0" ] && ok "context temp file cleaned up" || bad "context temp file left behind ($leftover)"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
