#!/bin/bash
# deploy-sync-test.sh — coverage for the deploy reconciler (deploy-sync.sh).
#
# Regression for the 2026-06-27 dead-on-arrival defect: a gardener claim-path
# self-heal fix landed on origin/main2, yet the long-lived garden-* units kept
# running the OLD code (the checkout drifted 4 commits behind), so 9 healthy
# gardeners crash-looped on `claim failed (rc=128)` after the fix already existed.
# deploy-sync.sh advances the checkout by a strict clean fast-forward and, when
# scripts/ changed, restarts the long-running services so they re-exec — but ONLY
# gardeners that are NOT mid-job (the busy-marker gate).
#
# Hermetic: a throwaway git origin+checkout stands in for the garden tree, and a
# mocked `systemctl --user` (mock-systemctl.sh) records the restart calls. No real
# systemd and no real journal are touched.
#
# Usage: deploy-sync-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SYSTEMD_SRC="$(cd "$JOBS/../systemd" && pwd)"
DEPLOY="$JOBS/deploy-sync.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-deploy-sync-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/origin.git"
git_id=(-c user.name=test -c user.email=test@localhost)

# (re)build a fresh origin+checkout fixture. ROOT is the stand-in garden tree.
setup_fixture() {
  rm -rf "$BARE" "$TR/root" "$TR/seed" "$TR/state" "$TR/config" "$TR/armed" "$TR/log"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b main2
  mkdir -p "$SEED/scripts/jobs" "$SEED/scripts/systemd"
  printf '# placeholder\n' > "$SEED/README.md"
  printf 'echo old\n'      > "$SEED/scripts/jobs/worker-lib.sh"
  cp "$SYSTEMD_SRC"/garden-deploy-sync.* "$SEED/scripts/systemd/" 2>/dev/null || true
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin main2
  git clone -q --branch main2 "$BARE" "$TR/root"
  mkdir -p "$TR/state" "$TR/config"
  : > "$TR/armed"; : > "$TR/log"
  # Arm the units the reconciler will enumerate.
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

# A GARDEN_POST_JOB mock so a wedge-triggered resolve-wedge post never reaches the
# real journal-backed producer (which would hang on a fetch in this fixture). It
# records each posted basename to $TR/postlog.
POSTLOG="$TR/postlog"
mkpostmock() {
  cat > "$TR/post-mock.sh" <<EOF
#!/bin/bash
echo "POST \$1" >> "$POSTLOG"
exit 0
EOF
  chmod +x "$TR/post-mock.sh"
}

run_deploy() {  # run_deploy [extra env assignments...] ; returns rc, fills $OUT
  mkpostmock; : > "$POSTLOG"
  set +e
  OUT="$(env GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" GARDEN_MAIN_BRANCH=main2 \
             GARDEN_UNIT_CTL="$HERE/mock-systemctl.sh" \
             GARDEN_MOCK_STATE="$TR/armed" GARDEN_MOCK_LOG="$TR/log" \
             GARDEN_POST_JOB="$TR/post-mock.sh" \
             XDG_CONFIG_HOME="$TR/config" \
             "$@" bash "$DEPLOY" 2>&1)"
  RC=$?
  set -e
}
root_head()  { git -C "$TR/root" rev-parse HEAD; }
log_has()    { grep -qF "$1" "$TR/log"; }
posted_any() { grep -q '^POST resolve-wedge-' "$POSTLOG" 2>/dev/null; }

# ============================================================================
hr; echo "STATIC — the scripts parse (bash -n)"; hr
bash -n "$DEPLOY" && ok "deploy-sync.sh parses" || bad "deploy-sync.sh syntax error"
bash -n "$JOBS/gardener.sh" && ok "gardener.sh parses" || bad "gardener.sh syntax error"

# ============================================================================
hr; echo "NO-OP — origin == local: nothing to deploy, no restarts"; hr
setup_fixture
before="$(root_head)"
run_deploy
[ "$RC" -eq 0 ] && ok "exit 0 on no change" || bad "exit $RC on no change"
[ "$(root_head)" = "$before" ] && ok "tree unchanged" || bad "tree moved on no change"
grep -q restart "$TR/log" && bad "restarted on no change" || ok "no restart on no change"

# ============================================================================
hr; echo "DEPLOY — scripts/ change: idle gardener restarted, busy one deferred"; hr
setup_fixture
mkdir -p "$TR/state/gardeners/2"; : > "$TR/state/gardeners/2/busy"   # gardener 2 is mid-job
origin_commit scripts/jobs/worker-lib.sh "echo new" "fix: worker-lib"
upstream="$(git -C "$TR/root" rev-parse origin/main2 2>/dev/null || true)"  # pre-fetch value irrelevant
run_deploy
[ "$RC" -eq 0 ] && ok "exit 0 on a clean deploy" || bad "exit $RC on clean deploy"
log_has "restart garden-gardener@1.service" && ok "idle gardener 1 restarted" || bad "idle gardener 1 NOT restarted"
log_has "restart garden-gardener@2.service" && bad "busy gardener 2 was restarted (mid-job!)" || ok "busy gardener 2 deferred (not restarted)"
log_has "restart garden-bulletin.service" && ok "bulletin restarted" || bad "bulletin NOT restarted"
grep -q "deferring its restart" <<<"$OUT" && ok "deferral logged for the busy gardener" || bad "deferral not logged"
# tree actually advanced to origin
[ "$(root_head)" = "$(git -C "$BARE" rev-parse main2)" ] && ok "tree fast-forwarded to origin" || bad "tree not advanced"

# ============================================================================
hr; echo "NON-SCRIPT — a non-scripts/ change advances the tree but restarts nothing"; hr
setup_fixture
origin_commit README.md "docs change" "docs: readme"
run_deploy
[ "$RC" -eq 0 ] && ok "exit 0" || bad "exit $RC"
[ "$(root_head)" = "$(git -C "$BARE" rev-parse main2)" ] && ok "tree advanced" || bad "tree not advanced"
grep -q restart "$TR/log" && bad "restarted on a non-scripts change" || ok "no restart on a non-scripts change"

# ============================================================================
hr; echo "DRAINING — scripts change advances the tree but defers all restarts"; hr
setup_fixture
: > "$TR/state/draining"
origin_commit scripts/jobs/worker-lib.sh "echo new2" "fix: worker-lib 2"
run_deploy
[ "$(root_head)" = "$(git -C "$BARE" rev-parse main2)" ] && ok "tree advanced while draining" || bad "tree not advanced while draining"
grep -q restart "$TR/log" && bad "restarted while fleet draining" || ok "no restart while fleet draining"
grep -q "fleet draining" <<<"$OUT" && ok "draining deferral logged" || bad "draining deferral not logged"

# ============================================================================
hr; echo "DRAINING (legacy) — the deprecated NOPE marker still defers restarts"; hr
setup_fixture
: > "$TR/state/NOPE"
origin_commit scripts/jobs/worker-lib.sh "echo new3" "fix: worker-lib 3"
run_deploy
[ "$(root_head)" = "$(git -C "$BARE" rev-parse main2)" ] && ok "tree advanced under legacy marker" || bad "tree not advanced under legacy marker"
grep -q restart "$TR/log" && bad "restarted while legacy marker set" || ok "no restart while legacy marker set (compat)"
grep -q "fleet draining" <<<"$OUT" && ok "legacy marker honored by fleet_draining" || bad "legacy marker not honored"

# ============================================================================
hr; echo "DIRTY — tracked WIP in the tree blocks the fast-forward (skip-and-log)"; hr
setup_fixture
before="$(root_head)"
printf 'local WIP\n' >> "$TR/root/scripts/jobs/worker-lib.sh"   # tracked-dirty
origin_commit scripts/jobs/other.sh "echo other" "fix: other"
run_deploy
[ "$(root_head)" = "$before" ] && ok "tree NOT advanced while dirty" || bad "tree advanced over tracked WIP (clobber!)"
grep -q "TRACKED changes" <<<"$OUT" && ok "dirty-tree skip logged" || bad "dirty-tree skip not logged"
grep -q restart "$TR/log" && bad "restarted despite a skipped deploy" || ok "no restart on a skipped (dirty) deploy"
posted_any && ok "a resolve-wedge job was posted (autonomous resolution, not a wedge)" || bad "no resolve-wedge job posted on a dirty tree"
grep -Eq 'message-user|deploy is frozen' <<<"$OUT" && bad "deploy-sync paged the maintainer on a wedge" || ok "maintainer NOT paged on a dirty wedge"

# ============================================================================
hr; echo "UNTRACKED — a stray untracked file does NOT block the deploy"; hr
setup_fixture
printf 'junk\n' > "$TR/root/scratch-junk.txt"   # untracked; must not wedge
origin_commit scripts/jobs/worker-lib.sh "echo new3" "fix: worker-lib 3"
run_deploy
[ "$(root_head)" = "$(git -C "$BARE" rev-parse main2)" ] && ok "tree advanced past an untracked file" || bad "untracked file wedged the deploy"
log_has "restart garden-gardener@1.service" && ok "restart proceeded with untracked file present" || bad "untracked file blocked the restart"

# ============================================================================
hr; echo "DIVERGED — a local commit not on origin is not fast-forwardable (skip)"; hr
setup_fixture
before_div() { :; }
printf 'echo local-only\n' > "$TR/root/scripts/jobs/local.sh"
git -C "$TR/root" add -A; git -C "$TR/root" "${git_id[@]}" commit -q -m "local-only commit"
localhead="$(root_head)"
origin_commit scripts/jobs/worker-lib.sh "echo diverge" "fix: diverge"
run_deploy
[ "$(root_head)" = "$localhead" ] && ok "tree NOT advanced when diverged" || bad "tree moved despite divergence"
grep -q "DIVERGED" <<<"$OUT" && ok "divergence skip logged" || bad "divergence skip not logged"
grep -q restart "$TR/log" && bad "restarted despite divergence" || ok "no restart when diverged"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
