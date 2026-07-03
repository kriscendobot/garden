#!/bin/bash
# scheduler-preflight-deploy-lag-test.sh — coverage for the scheduler's hardening
# of a named-but-MISSING preflight gate (scheduler.sh note_missing_preflight /
# clear_missing_preflight).
#
# A schedule whose `preflight:` names a script that is ABSENT from this host's
# deployed root fails OPEN (dispatches unconditionally — real work is never
# starved). Before this hardening it also logged a WARN on EVERY due tick for the
# whole deploy-lag window, silently burying the cause. The hardening:
#   (1) the WARN is de-duplicated per (schedule, resolved-path) via a marker under
#       $GARDEN_STATE, so it fires ONCE per breakage, not every tick; and
#   (2) when the SAME script exists on origin/$GARDEN_MAIN_BRANCH but not in the
#       deployed root, that is diagnosed as DEPLOY-LAG and surfaced ONCE as a
#       distinct note in the deploy state dir (next to the upgrade-ready marker),
#       pointing at the pending deploy as the cause.
# The marker + note are cleared the moment the gate is found again, re-arming the
# one-shot signal per breakage.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2; a throwaway
# git repo stands in for the deployed GARDEN_ROOT, whose origin/main2 CARRIES the
# preflight script the deployed working tree LACKS (the exact deploy-lag shape).
#
# Usage: scheduler-preflight-deploy-lag-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub any ambient garden env so a live gardener running this test cannot splice
# the real journal/root underneath the hermetic fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-scheduler-preflight-deploy-lag-test
rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

JBARE="$TR/journal.git"          # stands in for origin/journal2
ROOT="$TR/root"                  # stands in for the deployed GARDEN_ROOT
RBARE="$TR/root.git"             # stands in for the ROOT's origin (carries main2)
STATE="$TR/state"                # $GARDEN_STATE (per-host, never committed)
SCHED=deploylag-test.md
PF_REL=scripts/jobs/gardening/deploylag-preflight.sh   # named by the schedule
BRANCH=journal2
MAIN=main2

# --- deployed GARDEN_ROOT whose origin/main2 carries the missing preflight -----
# ROOT's committed tree is the CURRENT scripts/ (so it runs THIS scheduler.sh) but
# WITHOUT the preflight; origin/main2 gets a follow-on commit that ADDS the
# preflight — i.e. the script landed on the dev branch but has not been deployed
# here yet. deployed_sha (marker) points at the pre-preflight commit, so the
# deploy-lag diagnosis reports a real ahead-by count.
setup_root() {
  rm -rf "$ROOT" "$RBARE"
  git init -q --bare "$RBARE"
  git init -q "$ROOT"; git -C "$ROOT" checkout -q -b "$MAIN"
  mkdir -p "$ROOT/scripts"
  cp -a "$JOBS/../." "$ROOT/scripts/"        # copy scripts/ (this worktree's) into ROOT
  rm -f "$ROOT/$PF_REL"                       # deployed root LACKS the gate
  git -C "$ROOT" "${git_id[@]}" add -A
  git -C "$ROOT" "${git_id[@]}" commit -q -m "deployed root (no preflight)"
  git -C "$ROOT" remote add origin "$RBARE"
  git -C "$ROOT" push -q -u origin "$MAIN"
  DEP_SHA="$(git -C "$ROOT" rev-parse HEAD)"
  # A follow-on commit on origin/main2 ADDS the gate (present on branch, not here).
  local wt="$TR/rootedit"; git clone -q --branch "$MAIN" "$RBARE" "$wt"
  mkdir -p "$wt/$(dirname "$PF_REL")"
  printf '#!/bin/bash\nexit 2\n' > "$wt/$PF_REL"; chmod +x "$wt/$PF_REL"
  git -C "$wt" "${git_id[@]}" add -A
  git -C "$wt" "${git_id[@]}" commit -q -m "add deploylag-preflight.sh on main2"
  git -C "$wt" push -q origin "$MAIN"
  rm -rf "$wt"
}

# --- throwaway journal origin with the deploy-lagged schedule -----------------
setup_journal() {  # $1=last_dispatched ISO
  rm -rf "$JBARE" "$TR/seed"
  git init -q --bare "$JBARE"
  local SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
  mkdir -p "$SEED/schedules" "$SEED/jobs/todo" "$SEED/inbox/maintainer/unread"
  touch "$SEED/jobs/todo/.gitkeep" "$SEED/inbox/maintainer/unread/.gitkeep"
  {
    printf 'cadence: 30m\nlast_dispatched: %s\njob_basename_prefix: deploylag-test\n' "$1"
    printf 'preflight: gardening/deploylag-preflight.sh\n---\nrun the deploy-lagged task\n'
  } > "$SEED/schedules/$SCHED"
  git -C "$SEED" "${git_id[@]}" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed deploy-lag schedule"
  git -C "$SEED" remote add origin "$JBARE"
  git -C "$SEED" push -q -u origin "$BRANCH"
}

# Run one scheduler tick at a given epoch, capturing its log. Env pins the
# hermetic fixture; GARDEN_ROOT is the deployed root whose scheduler.sh we run.
run_tick() {  # $1=epoch  -> writes log to $2
  local now="$1" out="$2"
  GARDEN=testhost \
  GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$STATE" \
  GARDEN_MAIN_BRANCH="$MAIN" \
  JOURNAL_REMOTE="$JBARE" \
  JOURNAL_BRANCH="$BRANCH" \
  GARDEN_SCHEDULER_CLONE="$STATE/scheduler/journal" \
  GARDEN_DEPLOYED_SHA_MARKER="$STATE/deploy/deployed-sha" \
  GARDEN_SCHEDULER_NOW="$now" \
    "$ROOT/scripts/jobs/scheduler.sh" >"$out" 2>&1 || true
}

# count job files (excluding .gitkeep) currently on origin/journal2/jobs/todo
todo_count() {
  local wt="$TR/count"; rm -rf "$wt"
  git clone -q --branch "$BRANCH" "$JBARE" "$wt" 2>/dev/null
  local n; n="$(find "$wt/jobs/todo" -maxdepth 1 -type f ! -name '.gitkeep' 2>/dev/null | wc -l)"
  rm -rf "$wt"; printf '%s\n' "$n"
}

NOTE="$STATE/deploy/preflight-deploy-lag-$SCHED"
MARKER="$STATE/scheduler/preflight-missing/$SCHED"

# =============================================================================
hr; echo "SETUP: deploy-lagged schedule (gate on main2, absent from deployed root)"
setup_root
setup_journal 2026-07-03T00:00:00Z
mkdir -p "$STATE/deploy"; printf '%s\n' "$DEP_SHA" > "$STATE/deploy/deployed-sha"

# two consecutive DUE ticks (each >30m after the previous stamp)
T1=$(date -u -d 2026-07-03T01:00:00Z +%s)
T2=$(date -u -d 2026-07-03T02:00:00Z +%s)
run_tick "$T1" "$TR/log1"
run_tick "$T2" "$TR/log2"
cat "$TR/log1" "$TR/log2" > "$TR/logs"

hr; echo "CHECK: fail-open dispatch preserved (both due ticks posted a job)"
n="$(todo_count)"
[ "$n" = "2" ] && ok "both ticks dispatched (todo=$n) — real work never starved" \
                || bad "expected 2 dispatched jobs, got $n"

hr; echo "CHECK: the not-found WARN is de-duplicated across ticks"
w="$(grep -c "WARN schedule $SCHED preflight" "$TR/logs" || true)"
[ "$w" = "1" ] && ok "WARN fired exactly once across two ticks (count=$w)" \
                || bad "expected WARN once, got $w — dedup marker not honored"

hr; echo "CHECK: deploy-lag diagnosed once (log + distinct deploy-surface note)"
d="$(grep -c "deploy-lag: preflight" "$TR/logs" || true)"
[ "$d" = "1" ] && ok "deploy-lag diagnosis logged exactly once (count=$d)" \
                || bad "expected deploy-lag log once, got $d"
if [ -f "$NOTE" ]; then
  ok "deploy-surface note written: $NOTE"
  grep -q "Scheduler preflight deploy-lag" "$NOTE" && ok "note headline present" || bad "note headline missing"
  grep -q "present on origin/$MAIN" "$NOTE" && ok "note states script present on $MAIN" || bad "note missing branch-presence line"
  grep -q "deploy-garden.sh" "$NOTE" && ok "note points at the deploy fix" || bad "note missing deploy fix pointer"
else
  bad "expected deploy-surface note at $NOTE (not created)"
fi

hr; echo "CHECK: per-(schedule,path) marker records the resolved path"
if [ -f "$MARKER" ]; then
  ok "dedup marker written: $MARKER"
  grep -q "$ROOT/$PF_REL" "$MARKER" && ok "marker records resolved preflight path" \
                                     || bad "marker does not record resolved path ($(cat "$MARKER"))"
else
  bad "expected dedup marker at $MARKER (not created)"
fi

hr; echo "CHECK (best-effort): a one-shot deploy-lag message hit the maintainer inbox"
mwt="$TR/msgcount"; rm -rf "$mwt"
if git clone -q --branch "$BRANCH" "$JBARE" "$mwt" 2>/dev/null; then
  m="$(grep -rl "DEPLOY-LAG symptom" "$mwt/inbox/maintainer" 2>/dev/null | wc -l)"
  [ "$m" -ge 1 ] && ok "deploy-lag message delivered to maintainer inbox (count=$m)" \
                 || echo "  NOTE: no maintainer message found (message-bus delivery is best-effort; not a hard requirement)"
  rm -rf "$mwt"
fi

# =============================================================================
hr; echo "PHASE 2: the gate becomes present (host deployed) → signal re-arms"
mkdir -p "$ROOT/$(dirname "$PF_REL")"
printf '#!/bin/bash\nexit 2\n' > "$ROOT/$PF_REL"; chmod +x "$ROOT/$PF_REL"   # present, says no-work
T3=$(date -u -d 2026-07-03T03:00:00Z +%s)
run_tick "$T3" "$TR/log3"

hr; echo "CHECK: gate present → no-work gate honored, marker + note cleared"
grep -q "preflight gated: no work for $SCHED" "$TR/log3" && ok "no-work gate now honored (no dispatch)" \
                                                          || bad "expected 'preflight gated: no work' on gate-present tick"
n="$(todo_count)"
[ "$n" = "2" ] && ok "no new dispatch on the no-work tick (todo still $n)" \
                || bad "expected todo to stay 2, got $n"
[ ! -f "$MARKER" ] && ok "dedup marker cleared (WARN re-armed)" || bad "marker NOT cleared after gate found"
[ ! -f "$NOTE" ]   && ok "deploy-surface note cleared (diagnosis re-armed)" || bad "note NOT cleared after gate found"

hr
echo "RESULT: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
