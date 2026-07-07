#!/bin/bash
# deploy-garden-test.sh — coverage for the deliberate, drained deploy
# (deploy-garden.sh) and the shared restart library (deploy-restart.sh).
#
# The root checkout is a DEPLOYED version, advanced ONLY by deploy-garden.sh:
# drain → quiesce (no gardener busy marker) → ff-merge origin/main2 → record the
# deployed sha → lift the drain → restart the long-running fleet. See
# designs/deliberate-deploy.md. This replaces the retired deploy-sync-test.sh; the
# restart half it used to cover now lives in deploy-restart.sh and is exercised
# here through a real deploy.
#
# Hermetic: a throwaway git origin+checkout stands in for the garden tree, and a
# mocked `systemctl --user` (mock-systemctl.sh) records the restart calls. No real
# systemd, no real journal, no broadcast (GARDEN_DEPLOY_NO_BROADCAST=1).
#
# Usage: deploy-garden-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
DEPLOY="$JOBS/deploy-garden.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors deploy-sync-test).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-deploy-garden-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/origin.git"
git_id=(-c user.name=test -c user.email=test@localhost)

setup_fixture() {
  rm -rf "$BARE" "$TR/root" "$TR/seed" "$TR/state" "$TR/config" "$TR/armed" "$TR/log"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b main2
  mkdir -p "$SEED/scripts/jobs"
  printf '# placeholder\n' > "$SEED/README.md"
  printf 'echo old\n'      > "$SEED/scripts/jobs/worker-lib.sh"
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin main2
  git clone -q --branch main2 "$BARE" "$TR/root"
  mkdir -p "$TR/state" "$TR/config"
  : > "$TR/armed"; : > "$TR/log"
  printf '%s\n' garden-gardener@1.service garden-gardener@2.service garden-bulletin.service > "$TR/armed"
}

# push a commit to origin/main2 (advancing it ahead of ROOT).
origin_commit() {  # origin_commit <relpath> <content> <msg>
  local wt; wt="$(mktemp -d "$TR/push.XXXXXX")"
  git clone -q --branch main2 "$BARE" "$wt"
  mkdir -p "$(dirname "$wt/$1")"; printf '%s\n' "$2" > "$wt/$1"
  git -C "$wt" add -A; git -C "$wt" "${git_id[@]}" commit -q -m "$3"
  git -C "$wt" push -q origin main2
  rm -rf "$wt"
}

run_deploy() {  # run_deploy [extra env assignments...] ; returns rc, fills $OUT
  set +e
  OUT="$(env GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" GARDEN_MAIN_BRANCH=main2 \
             GARDEN_UNIT_CTL="$HERE/mock-systemctl.sh" \
             GARDEN_MOCK_STATE="$TR/armed" GARDEN_MOCK_LOG="$TR/log" \
             GARDEN_DEPLOY_NO_BROADCAST=1 \
             XDG_CONFIG_HOME="$TR/config" \
             "$@" bash "$DEPLOY" 2>&1)"
  RC=$?
  set -e
}
root_head()    { git -C "$TR/root" rev-parse HEAD; }
origin_head()  { git -C "$BARE" rev-parse main2; }
deployed_marker() { cat "$TR/state/deploy/deployed-sha" 2>/dev/null || true; }
draining()     { [ -e "$TR/state/draining" ]; }
log_has()      { grep -qF "$1" "$TR/log"; }

# ============================================================================
hr; echo "STATIC — the scripts parse (bash -n)"; hr
bash -n "$DEPLOY" && ok "deploy-garden.sh parses" || bad "deploy-garden.sh syntax error"
bash -n "$JOBS/deploy-restart.sh" && ok "deploy-restart.sh parses" || bad "deploy-restart.sh syntax error"
bash -n "$JOBS/upgrade-monitor.sh" && ok "upgrade-monitor.sh parses" || bad "upgrade-monitor.sh syntax error"

# ============================================================================
hr; echo "CLEAN DEPLOY — quiesced fleet, scripts change: merge + record + lift + restart"; hr
setup_fixture
origin_commit scripts/jobs/worker-lib.sh "echo new" "fix: worker-lib"
target="$(origin_head)"
run_deploy
[ "$RC" -eq 0 ] && ok "exit 0 on a clean deploy" || bad "exit $RC on clean deploy: $OUT"
[ "$(root_head)" = "$target" ] && ok "root fast-forwarded to origin/main2" || bad "root not advanced"
[ "$(deployed_marker)" = "$target" ] && ok "deployed-sha marker recorded = new HEAD" || bad "deployed marker '$(deployed_marker)' != '$target'"
draining && bad "drain marker still present after a successful deploy" || ok "drain lifted after deploy"
log_has "restart garden-gardener@1.service" && ok "gardener 1 restarted (re-exec onto new code)" || bad "gardener 1 NOT restarted"
log_has "restart garden-gardener@2.service" && ok "gardener 2 restarted (no busy-gate post-quiesce)" || bad "gardener 2 NOT restarted"
log_has "restart garden-bulletin.service" && ok "bulletin restarted" || bad "bulletin NOT restarted"
grep -q "fleet quiesced" <<<"$OUT" && ok "quiesce reached (no mid-job gardeners)" || bad "quiesce not logged"

# ============================================================================
hr; echo "NO-OP — origin == root: nothing to deploy, drain lifted, no restart"; hr
setup_fixture
before="$(root_head)"
run_deploy
[ "$RC" -eq 0 ] && ok "exit 0 on no change" || bad "exit $RC on no change"
[ "$(root_head)" = "$before" ] && ok "root unchanged" || bad "root moved on no change"
[ "$(deployed_marker)" = "$before" ] && ok "deployed-sha recorded even on a no-op" || bad "deployed marker not recorded on no-op"
draining && bad "drain still present after no-op" || ok "drain lifted on no-op"
grep -q restart "$TR/log" && bad "restarted on a no-op deploy" || ok "no restart on a no-op deploy"

# ============================================================================
hr; echo "QUIESCE-WAIT — a busy gardener clears mid-wait, then the deploy proceeds"; hr
setup_fixture
mkdir -p "$TR/state/gardeners/2"; : > "$TR/state/gardeners/2/busy"   # gardener 2 mid-job
origin_commit scripts/jobs/worker-lib.sh "echo new2" "fix: worker-lib 2"
target="$(origin_head)"
( sleep 2; rm -f "$TR/state/gardeners/2/busy" ) &   # it finishes 2s in
run_deploy GARDEN_DEPLOY_DRAIN_TIMEOUT=30 GARDEN_DEPLOY_POLL=1
wait
[ "$RC" -eq 0 ] && ok "exit 0 once the fleet quiesced" || bad "exit $RC: $OUT"
[ "$(root_head)" = "$target" ] && ok "root advanced after the busy gardener cleared" || bad "root not advanced after wait"
grep -q "waiting for 1 mid-job gardener" <<<"$OUT" && ok "the wait loop logged the busy gardener" || bad "wait not logged"

# ============================================================================
hr; echo "QUIESCE-TIMEOUT — a busy gardener that never clears aborts, drain lifted"; hr
setup_fixture
mkdir -p "$TR/state/gardeners/1"; : > "$TR/state/gardeners/1/busy"   # never cleared
origin_commit scripts/jobs/worker-lib.sh "echo new3" "fix: worker-lib 3"
before="$(root_head)"
run_deploy GARDEN_DEPLOY_DRAIN_TIMEOUT=1 GARDEN_DEPLOY_POLL=1
[ "$RC" -ne 0 ] && ok "non-zero exit on quiesce timeout" || bad "exit 0 despite a stuck fleet"
[ "$(root_head)" = "$before" ] && ok "root NOT advanced on timeout" || bad "root advanced despite timeout"
draining && bad "drain left engaged after a self-aborted deploy" || ok "drain lifted on timeout (we engaged it)"
grep -q "quiesce timed out" <<<"$OUT" && ok "timeout logged" || bad "timeout not logged"
grep -q restart "$TR/log" && bad "restarted despite an aborted deploy" || ok "no restart on a timed-out deploy"

# ============================================================================
hr; echo "LONG-JOB DEFER — a long mid-job gardener defers WITHOUT pausing the fleet"; hr
# The recurring fleet-pause thrash (2026-06-30, gardener-88 chain-state repro,
# gardener-30 scholar ingest): a gardener whose job outlasts the drain budget can
# never quiesce, so engaging the drain only pauses the WHOLE fleet for the full
# budget before aborting — and the persistent Upgrade-ready signal makes the next
# trigger repeat it. The defer check samples the busy marker's AGE before engaging
# the drain: a gardener already mid-job past the threshold defers the deploy with
# the drain NEVER engaged (the fleet is never paused), exit 0, nothing advanced.
setup_fixture
mkdir -p "$TR/state/gardeners/1"; : > "$TR/state/gardeners/1/busy"
touch -d "10 minutes ago" "$TR/state/gardeners/1/busy"   # a long job: busy 600s
origin_commit scripts/jobs/worker-lib.sh "echo newdefer" "fix: worker-lib defer"
before="$(root_head)"
run_deploy GARDEN_DEPLOY_LONG_JOB_THRESHOLD=300 GARDEN_DEPLOY_DRAIN_TIMEOUT=600 GARDEN_DEPLOY_POLL=1
[ "$RC" -eq 0 ] && ok "exit 0 on a deferral (not a failure)" || bad "exit $RC on deferral: $OUT"
grep -q "DEFERRED" <<<"$OUT" && ok "deferral logged" || bad "deferral not logged: $OUT"
grep -q "drain engaged" <<<"$OUT" && bad "the drain was engaged on a doomed attempt (fleet paused!)" || ok "drain NEVER engaged — the fleet was not paused"
grep -q "waiting for" <<<"$OUT" && bad "entered the quiesce wait (fleet paused)" || ok "no quiesce wait entered"
[ "$(root_head)" = "$before" ] && ok "root NOT advanced on a deferral" || bad "root advanced on a deferral"
draining && bad "drain marker present after a deferral" || ok "no drain marker (fleet untouched)"
grep -q restart "$TR/log" && bad "restarted on a deferral" || ok "no restart on a deferral"

# A drain the OPERATOR pre-engaged is honored, not short-circuited by the defer
# check (deferring would not un-pause their drain; they explicitly asked to deploy).
# The long job then fails to quiesce and the deploy aborts as before (exit != 0),
# preserving the operator's drain.
setup_fixture
: > "$TR/state/draining"                                  # operator pre-drained
mkdir -p "$TR/state/gardeners/1"; : > "$TR/state/gardeners/1/busy"
touch -d "10 minutes ago" "$TR/state/gardeners/1/busy"
origin_commit scripts/jobs/worker-lib.sh "echo newdefer2" "fix: worker-lib defer2"
run_deploy GARDEN_DEPLOY_LONG_JOB_THRESHOLD=300 GARDEN_DEPLOY_DRAIN_TIMEOUT=1 GARDEN_DEPLOY_POLL=1
[ "$RC" -ne 0 ] && ok "operator-pre-drained long job aborts (defer check skipped)" || bad "exit 0 despite operator pre-drain + stuck fleet"
grep -q "DEFERRED" <<<"$OUT" && bad "deferred despite operator pre-drain" || ok "defer check skipped while operator-drained"
draining && ok "operator's drain preserved on abort" || bad "operator's drain was lifted"

# ============================================================================
hr; echo "LONG-JOB DEFER (MID-DRAIN) — a job that crosses the threshold while we wait lifts the drain"; hr
# A gardener under the threshold at the defer check (so we DO engage the drain)
# that then grows past it mid-wait must lift the drain and defer the moment it
# crosses, rather than hold the fleet paused for the rest of the budget.
setup_fixture
mkdir -p "$TR/state/gardeners/1"; : > "$TR/state/gardeners/1/busy"
touch -d "4 seconds ago" "$TR/state/gardeners/1/busy"    # age 4 < threshold 5 at the check
origin_commit scripts/jobs/worker-lib.sh "echo newmid" "fix: worker-lib mid"
before="$(root_head)"
run_deploy GARDEN_DEPLOY_LONG_JOB_THRESHOLD=5 GARDEN_DEPLOY_DRAIN_TIMEOUT=30 GARDEN_DEPLOY_POLL=1
[ "$RC" -eq 0 ] && ok "exit 0 on a mid-drain deferral" || bad "exit $RC on mid-drain deferral: $OUT"
grep -q "drain engaged" <<<"$OUT" && ok "drain WAS engaged (job was under threshold at the check)" || bad "drain not engaged: $OUT"
grep -q "mid-drain" <<<"$OUT" && ok "mid-drain deferral logged once the job crossed the threshold" || bad "mid-drain deferral not logged: $OUT"
[ "$(root_head)" = "$before" ] && ok "root NOT advanced on a mid-drain deferral" || bad "root advanced on a mid-drain deferral"
draining && bad "drain left engaged after a mid-drain deferral" || ok "drain lifted on a mid-drain deferral (we engaged it)"
grep -q restart "$TR/log" && bad "restarted on a mid-drain deferral" || ok "no restart on a mid-drain deferral"

# ============================================================================
hr; echo "STALE BUSY MARKER — an INACTIVE gardener's marker is swept, not honored"; hr
# The forever-defer bug (2026-07-07): a busy marker left by a gardener whose unit
# is no longer running (a worker killed mid-job during an outage, or an id above
# the pool size after a downsize) never ages out and no live process removes it,
# so honoring it as a live long job DEFERS every deploy forever (gardeners/55/busy,
# empty, 28h old, unit inactive, pool sized to 20 — blocked two deploys until an
# operator removed it by hand). The fix: check unit liveness (is-active, stubbed
# via GARDEN_UNIT_CTL) before counting a marker; an inactive unit's marker is STALE
# — swept + logged, never counted toward the defer check or the quiesce count. The
# mock's armed set stands in for the running units, so gardener 55 (NOT armed) is
# inactive while gardener 1 (armed by setup_fixture) is active.

# (a) A stale marker alone must NOT defer: it is swept and the deploy proceeds.
setup_fixture
mkdir -p "$TR/state/gardeners/55"; : > "$TR/state/gardeners/55/busy"
touch -d "10 minutes ago" "$TR/state/gardeners/55/busy"   # old enough to be a "long job" IF honored
origin_commit scripts/jobs/worker-lib.sh "echo newstale" "fix: worker-lib stale"
target="$(origin_head)"
run_deploy GARDEN_DEPLOY_LONG_JOB_THRESHOLD=300 GARDEN_DEPLOY_DRAIN_TIMEOUT=30 GARDEN_DEPLOY_POLL=1
[ "$RC" -eq 0 ] && ok "exit 0 (a stale marker did not defer)" || bad "exit $RC: $OUT"
grep -q "DEFERRED" <<<"$OUT" && bad "DEFERRED on a stale marker (should be swept, not honored)" || ok "not deferred on a stale marker"
grep -q "swept STALE busy marker: gardener 55" <<<"$OUT" && ok "the stale marker sweep is logged (id + age)" || bad "stale sweep not logged: $OUT"
[ ! -e "$TR/state/gardeners/55/busy" ] && ok "the stale busy marker was removed" || bad "stale marker lingered"
[ "$(root_head)" = "$target" ] && ok "root advanced (deploy proceeded past the stale marker)" || bad "root not advanced: $OUT"
grep -q "fleet quiesced" <<<"$OUT" && ok "quiesce reached (stale marker not counted)" || bad "quiesce not reached: $OUT"

# (b) An ACTIVE gardener's long-job marker is honored exactly as before: it defers
# and is NOT swept.
setup_fixture
mkdir -p "$TR/state/gardeners/1"; : > "$TR/state/gardeners/1/busy"   # gardener 1 IS armed → active
touch -d "10 minutes ago" "$TR/state/gardeners/1/busy"
origin_commit scripts/jobs/worker-lib.sh "echo newactive" "fix: worker-lib active"
before="$(root_head)"
run_deploy GARDEN_DEPLOY_LONG_JOB_THRESHOLD=300 GARDEN_DEPLOY_DRAIN_TIMEOUT=600 GARDEN_DEPLOY_POLL=1
[ "$RC" -eq 0 ] && ok "exit 0 on an active long job (deferred, not a failure)" || bad "exit $RC: $OUT"
grep -q "DEFERRED: gardener 1" <<<"$OUT" && ok "the active gardener still defers (honored as before)" || bad "active gardener not honored: $OUT"
grep -q "swept STALE" <<<"$OUT" && bad "swept an ACTIVE gardener's marker!" || ok "an active marker is never swept"
[ -e "$TR/state/gardeners/1/busy" ] && ok "the active gardener's marker is preserved" || bad "active marker was removed"
[ "$(root_head)" = "$before" ] && ok "root NOT advanced (deferred by the live long job)" || bad "root advanced despite a live long job"

# (c) MIXED — one stale + one live: the live one governs, the stale one is swept.
setup_fixture
mkdir -p "$TR/state/gardeners/1"; : > "$TR/state/gardeners/1/busy"    # live long job (armed → active)
touch -d "10 minutes ago" "$TR/state/gardeners/1/busy"
mkdir -p "$TR/state/gardeners/55"; : > "$TR/state/gardeners/55/busy"  # stale, even older, NOT armed
touch -d "20 minutes ago" "$TR/state/gardeners/55/busy"
origin_commit scripts/jobs/worker-lib.sh "echo newmix" "fix: worker-lib mix"
before="$(root_head)"
run_deploy GARDEN_DEPLOY_LONG_JOB_THRESHOLD=300 GARDEN_DEPLOY_DRAIN_TIMEOUT=600 GARDEN_DEPLOY_POLL=1
[ "$RC" -eq 0 ] && ok "exit 0 (deferred by the LIVE long job, not the stale one)" || bad "exit $RC: $OUT"
grep -q "DEFERRED: gardener 1" <<<"$OUT" && ok "the LIVE gardener 1 governs the deferral (stale 55 excluded)" || bad "live gardener did not govern: $OUT"
grep -q "swept STALE busy marker: gardener 55" <<<"$OUT" && ok "the stale gardener 55 marker was swept in the mixed case" || bad "stale marker not swept in mixed case: $OUT"
[ ! -e "$TR/state/gardeners/55/busy" ] && ok "the stale marker was removed in the mixed case" || bad "stale marker lingered in mixed case"
[ -e "$TR/state/gardeners/1/busy" ] && ok "the live gardener's marker is preserved in the mixed case" || bad "the live marker was swept!"
[ "$(root_head)" = "$before" ] && ok "root NOT advanced in the mixed case (live long job defers)" || bad "root advanced despite the live long job"

# ============================================================================
hr; echo "DIRTY ABORT — a tracked edit in the root aborts without clobbering"; hr
setup_fixture
printf 'local WIP\n' >> "$TR/root/scripts/jobs/worker-lib.sh"   # tracked-dirty (invariant violation)
origin_commit scripts/jobs/other.sh "echo other" "fix: other"
before="$(root_head)"
run_deploy
[ "$RC" -ne 0 ] && ok "non-zero exit on a dirty root" || bad "exit 0 over a dirty root"
[ "$(root_head)" = "$before" ] && ok "root NOT advanced over tracked WIP (no clobber)" || bad "root advanced over tracked WIP (clobber!)"
grep -q "TRACKED changes" <<<"$OUT" && ok "dirty-root abort logged" || bad "dirty-root abort not logged"
draining && bad "drain left engaged on dirty abort" || ok "drain lifted on dirty abort (we engaged it)"

# ============================================================================
hr; echo "DIVERGED ABORT — a local commit not on origin aborts (no fast-forward)"; hr
setup_fixture
printf 'echo local-only\n' > "$TR/root/scripts/jobs/local.sh"
git -C "$TR/root" add -A; git -C "$TR/root" "${git_id[@]}" commit -q -m "local-only commit"
localhead="$(root_head)"
origin_commit scripts/jobs/worker-lib.sh "echo diverge" "fix: diverge"
run_deploy
[ "$RC" -ne 0 ] && ok "non-zero exit when diverged" || bad "exit 0 despite divergence"
[ "$(root_head)" = "$localhead" ] && ok "root NOT advanced when diverged" || bad "root moved despite divergence"
grep -q "DIVERGED" <<<"$OUT" && ok "divergence abort logged" || bad "divergence abort not logged"

# ============================================================================
hr; echo "PRE-DRAINED — operator pre-drained; success lifts, abort preserves"; hr
# (a) operator pre-drained + a clean deploy → drain is lifted (deploy completes).
setup_fixture
: > "$TR/state/draining"
origin_commit scripts/jobs/worker-lib.sh "echo new4" "fix: worker-lib 4"
target="$(origin_head)"
run_deploy
{ [ "$RC" -eq 0 ] && [ "$(root_head)" = "$target" ]; } && ok "pre-drained clean deploy completes" || bad "pre-drained clean deploy failed: $OUT"
draining && bad "drain left engaged after a successful deploy" || ok "successful deploy lifts even an operator-engaged drain"
# (b) operator pre-drained + an aborting deploy → drain is PRESERVED (we didn't engage it).
setup_fixture
: > "$TR/state/draining"
printf 'WIP\n' >> "$TR/root/scripts/jobs/worker-lib.sh"   # force a dirty abort
origin_commit scripts/jobs/other.sh "echo other2" "fix: other2"
run_deploy
[ "$RC" -ne 0 ] && ok "aborts on a dirty root while pre-drained" || bad "did not abort"
draining && ok "an aborted deploy PRESERVES an operator-engaged drain" || bad "aborted deploy lifted the operator's drain"

# ============================================================================
hr; echo "UNIT RECONCILE — a deploy disables + removes a stale RETIRED_UNITS unit"; hr
# Simulate a host that still carries a retired unit (garden-deploy-sync) enabled
# and rendered into DEST from a prior install. A tree-advancing deploy must run
# enable-services, which disables it AND removes the lingering rendered file so it
# can never fire again (the rc-127 loop fix, 2026-06-27).
setup_fixture
DEST="$TR/config/systemd/user"; mkdir -p "$DEST"
printf '[Unit]\n' > "$DEST/garden-deploy-sync.timer"      # stale rendered file lingers
printf '[Unit]\n' > "$DEST/garden-deploy-sync.service"
printf '%s\n' garden-deploy-sync.timer garden-deploy-sync.service >> "$TR/armed"  # still enabled
origin_commit scripts/jobs/worker-lib.sh "echo new5" "fix: worker-lib 5"
run_deploy
[ "$RC" -eq 0 ] && ok "deploy succeeds while reconciling units" || bad "exit $RC: $OUT"
log_has "disable --now garden-deploy-sync.timer" && ok "stale timer disabled during reconcile" || bad "stale timer NOT disabled"
log_has "disable --now garden-deploy-sync.service" && ok "stale service disabled during reconcile" || bad "stale service NOT disabled"
[ ! -e "$DEST/garden-deploy-sync.timer" ] && ok "stale rendered timer file removed from DEST" || bad "stale timer file lingered"
[ ! -e "$DEST/garden-deploy-sync.service" ] && ok "stale rendered service file removed from DEST" || bad "stale service file lingered"

# ============================================================================
hr; echo "CONCURRENT FLEET RESTART — every active gardener restarts in one wave"; hr
# Regression for the ~14-min deploy (2026-06-29): the fleet restart must issue a
# restart for EVERY active gardener (not stop at the first), and the restarts run
# concurrently so the per-unit stop windows overlap rather than sum.
setup_fixture
printf '%s\n' garden-gardener@1.service garden-gardener@2.service \
             garden-gardener@3.service garden-gardener@4.service \
             garden-gardener@5.service garden-bulletin.service > "$TR/armed"
origin_commit scripts/jobs/worker-lib.sh "echo newfleet" "fix: worker-lib fleet"
run_deploy
[ "$RC" -eq 0 ] && ok "exit 0 on the multi-gardener deploy" || bad "exit $RC: $OUT"
allrestarted=1
for n in 1 2 3 4 5; do
  grep -qF "restart garden-gardener@$n.service" "$TR/log" || { allrestarted=0; break; }
done
[ "$allrestarted" -eq 1 ] && ok "all 5 gardeners restarted (none skipped)" || bad "not every gardener restarted: $(cat "$TR/log")"
grep -q "restart complete: restarted=6 " <<<"$OUT" && ok "restart count = 6 (5 gardeners + bulletin)" || bad "restart count wrong: $(grep 'restart complete' <<<"$OUT")"

# ============================================================================
hr; echo "RESTART FAILURE ISOLATION — one failing unit is counted, the rest restart"; hr
# A single unit whose restart fails must NOT abort the wave: the others still
# restart and the failure is accounted (failed=1), not fatal to the deploy.
setup_fixture
printf '%s\n' garden-gardener@1.service garden-gardener@2.service \
             garden-gardener@3.service > "$TR/armed"
origin_commit scripts/jobs/worker-lib.sh "echo newiso" "fix: worker-lib iso"
run_deploy GARDEN_MOCK_FAIL_UNIT=garden-gardener@2.service
[ "$RC" -eq 0 ] && ok "deploy still succeeds despite one failed unit restart" || bad "exit $RC: $OUT"
grep -qF "restart garden-gardener@1.service" "$TR/log" && grep -qF "restart garden-gardener@3.service" "$TR/log" \
  && ok "the non-failing gardeners still restarted" || bad "a sibling restart was skipped after the failure"
grep -q "WARN: restart of garden-gardener@2.service failed" <<<"$OUT" && ok "the failed unit is logged as a WARN" || bad "failed unit not logged"
grep -q "restart complete: restarted=2 deferred(mid-job)=0 failed=1 " <<<"$OUT" && ok "accounting: restarted=2 failed=1" || bad "accounting wrong: $(grep 'restart complete' <<<"$OUT")"

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
