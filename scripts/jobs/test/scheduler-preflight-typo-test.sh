#!/bin/bash
# scheduler-preflight-typo-test.sh — coverage for the scheduler's hardening of a
# named-but-MISSING preflight gate whose script exists NOWHERE (a typo in the
# schedule's `preflight:` path, or a gate that was never landed on any branch).
#
# This is the sibling of scheduler-preflight-deploy-lag-test.sh. That test drives
# the DEPLOY-LAG branch (the gate is present on origin/main2 but absent from the
# deployed root). THIS test drives the other branch of note_missing_preflight: the
# resolved path is absent from origin/$GARDEN_MAIN_BRANCH too, so it is diagnosed
# NOT as deploy-lag but as a typo / never-landed gate. Before the hardening a
# declared-but-missing preflight failed open AND logged a WARN on EVERY due tick
# forever, silently defeating the gate a maintainer opted into. The hardening:
#   (1) fail-open dispatch is preserved (real work is never starved); and
#   (2) the WARN is de-duplicated per (schedule, resolved-path) via a $GARDEN_STATE
#       marker so it fires ONCE per breakage, and on that first tick a single
#       "NOT FOUND / not executable" notice is escalated to the maintainer inbox
#       (deduped on the schedule name) so the broken reference gets FIXED instead
#       of degrading to unconditional dispatch with only recurring log noise; and
#   (3) because the gate is on NO branch, NO deploy-lag note is written (a deploy
#       would not fix a typo) — distinguishing this from the deploy-lag case.
# The marker is cleared the moment the gate is found again, re-arming the one-shot.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2; a throwaway
# git repo stands in for the deployed GARDEN_ROOT whose origin/main2 NEVER carries
# the preflight the schedule names (the exact typo / never-landed shape).
#
# Usage: scheduler-preflight-typo-test.sh
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

TR=/home/kris/.garden-scheduler-preflight-typo-test
rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

JBARE="$TR/journal.git"          # stands in for origin/journal2
ROOT="$TR/root"                  # stands in for the deployed GARDEN_ROOT
RBARE="$TR/root.git"             # stands in for the ROOT's origin (carries main2)
STATE="$TR/state"                # $GARDEN_STATE (per-host, never committed)
SCHED=typo-test.md
# A preflight path that exists NOWHERE — not in the deployed root, not on main2.
PF_REL=scripts/jobs/gardening/typoed-nonexistent-preflight.sh
BRANCH=journal2
MAIN=main2

# --- deployed GARDEN_ROOT whose origin/main2 NEVER carries the preflight -------
# ROOT's committed tree is the CURRENT scripts/ (so it runs THIS scheduler.sh) but
# WITHOUT the typo'd preflight, and origin/main2 == the deployed commit (no
# follow-on that adds it). So the branch-presence probe returns "absent" and the
# breakage is diagnosed as a typo / never-landed gate, NOT deploy-lag.
setup_root() {
  rm -rf "$ROOT" "$RBARE"
  git init -q --bare "$RBARE"
  git init -q "$ROOT"; git -C "$ROOT" checkout -q -b "$MAIN"
  mkdir -p "$ROOT/scripts"
  cp -a "$JOBS/../." "$ROOT/scripts/"        # copy scripts/ (this worktree's) into ROOT
  rm -f "$ROOT/$PF_REL"                       # ensure the typo'd gate is truly absent
  git -C "$ROOT" "${git_id[@]}" add -A
  git -C "$ROOT" "${git_id[@]}" commit -q -m "deployed root (no preflight, none on branch)"
  git -C "$ROOT" remote add origin "$RBARE"
  git -C "$ROOT" push -q -u origin "$MAIN"
  DEP_SHA="$(git -C "$ROOT" rev-parse HEAD)"
  # NO follow-on commit — origin/main2 stays at the deployed sha, so the gate is
  # absent from the branch too (the typo / never-landed shape).
}

# --- throwaway journal origin with the typo'd-preflight schedule --------------
setup_journal() {  # $1=last_dispatched ISO
  rm -rf "$JBARE" "$TR/seed"
  git init -q --bare "$JBARE"
  local SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
  mkdir -p "$SEED/schedules" "$SEED/jobs/todo" "$SEED/inbox/maintainer/unread"
  touch "$SEED/jobs/todo/.gitkeep" "$SEED/inbox/maintainer/unread/.gitkeep"
  {
    printf 'cadence: 30m\nlast_dispatched: %s\njob_basename_prefix: typo-test\n' "$1"
    printf 'preflight: gardening/typoed-nonexistent-preflight.sh\n---\nrun the typo-gated task\n'
  } > "$SEED/schedules/$SCHED"
  git -C "$SEED" "${git_id[@]}" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed typo-preflight schedule"
  git -C "$SEED" remote add origin "$JBARE"
  git -C "$SEED" push -q -u origin "$BRANCH"
}

# Run one scheduler tick at a given epoch, capturing its log.
run_tick() {  # $1=epoch  $2=out
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
hr; echo "SETUP: typo'd schedule (gate on NO branch, absent from deployed root)"
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

hr; echo "CHECK: NOT diagnosed as deploy-lag (a deploy would not fix a typo)"
d="$(grep -c "deploy-lag: preflight" "$TR/logs" || true)"
[ "$d" = "0" ] && ok "no deploy-lag diagnosis logged (count=$d)" \
                || bad "expected NO deploy-lag log for a typo, got $d"
[ ! -f "$NOTE" ] && ok "no deploy-surface note written for a typo" \
                 || bad "unexpected deploy-surface note at $NOTE (typo must not write one)"

hr; echo "CHECK: per-(schedule,path) marker records the resolved path"
if [ -f "$MARKER" ]; then
  ok "dedup marker written: $MARKER"
  grep -q "$ROOT/$PF_REL" "$MARKER" && ok "marker records resolved preflight path" \
                                     || bad "marker does not record resolved path ($(cat "$MARKER"))"
else
  bad "expected dedup marker at $MARKER (not created)"
fi

hr; echo "CHECK (best-effort): a one-shot NOT-FOUND notice hit the maintainer inbox"
mwt="$TR/msgcount"; rm -rf "$mwt"
if git clone -q --branch "$BRANCH" "$JBARE" "$mwt" 2>/dev/null; then
  m="$(grep -rl "NOT FOUND / not executable" "$mwt/inbox/maintainer" 2>/dev/null | wc -l)"
  [ "$m" -ge 1 ] && ok "not-found notice delivered to maintainer inbox (count=$m)" \
                 || echo "  NOTE: no maintainer message found (message-bus delivery is best-effort; not a hard requirement)"
  # if any message was delivered, there must be exactly one (deduped per breakage)
  [ "$m" -le 1 ] && ok "at most one not-found notice per breakage (count=$m)" \
                 || bad "expected at most one not-found notice, got $m"
  rm -rf "$mwt"
fi

# =============================================================================
hr; echo "PHASE 2: the gate becomes present (path corrected/landed) → signal re-arms"
mkdir -p "$ROOT/$(dirname "$PF_REL")"
printf '#!/bin/bash\nexit 2\n' > "$ROOT/$PF_REL"; chmod +x "$ROOT/$PF_REL"   # present, says no-work
T3=$(date -u -d 2026-07-03T03:00:00Z +%s)
run_tick "$T3" "$TR/log3"

hr; echo "CHECK: gate present → no-work gate honored, marker cleared"
grep -q "preflight gated: no work for $SCHED" "$TR/log3" && ok "no-work gate now honored (no dispatch)" \
                                                          || bad "expected 'preflight gated: no work' on gate-present tick"
n="$(todo_count)"
[ "$n" = "2" ] && ok "no new dispatch on the no-work tick (todo still $n)" \
                || bad "expected todo to stay 2, got $n"
[ ! -f "$MARKER" ] && ok "dedup marker cleared (WARN re-armed)" || bad "marker NOT cleared after gate found"

hr
echo "RESULT: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
