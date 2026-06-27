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

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
