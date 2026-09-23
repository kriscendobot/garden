#!/bin/bash
# Hermetic regression for terminal project teardown and the leader sweep.

set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/worktree-teardown.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
git_id=(-c user.name=test -c user.email=test@localhost)

GROOT="$TR/garden"; SCRATCH="$GROOT/scratch"; STATE="$TR/state"
mkdir -p "$GROOT/worktrees" "$SCRATCH"
git init -q "$GROOT"
printf 'root\n' > "$GROOT/root.txt"
git -C "$GROOT" "${git_id[@]}" add root.txt
git -C "$GROOT" "${git_id[@]}" commit -qm root
git -C "$GROOT" branch -M main2

make_bare() { # make_bare <path>
  local bare="$1" seed
  seed="$TR/seed-$(basename "$bare")"
  git init -q --bare "$bare"
  git init -q "$seed"
  printf 'project\n' > "$seed/file"
  git -C "$seed" "${git_id[@]}" add file
  git -C "$seed" "${git_id[@]}" commit -qm seed
  git -C "$seed" branch -M main
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q origin main
}

PBARE="$GROOT/worktrees/acme-proj.git"
make_bare "$PBARE"

export GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$STATE"
# shellcheck disable=SC1090
source "$JOBS/common.sh"

terminal=done-job
live=live-job
tkey="$(project_worktree_base_key "$terminal")"
lkey="$(project_worktree_base_key "$live")"
twt="$SCRATCH/project-wt-${tkey}-00000001"
lwt="$SCRATCH/project-wt-${lkey}-00000001"
prefix_wt="$SCRATCH/project-wt-${tkey}-another-job-00000001"
git --git-dir="$PBARE" worktree add -q --detach "$twt" main
git --git-dir="$PBARE" worktree add -q --detach "$lwt" main
git --git-dir="$PBARE" worktree add -q --detach "$prefix_wt" main

cleanup_terminal_project_worktrees "$terminal"
if [ ! -e "$twt" ] && ! git --git-dir="$PBARE" worktree list --porcelain | grep -qxF "worktree $twt"; then
  ok "terminal helper removes project directory and bare-repo registration"
else
  bad "terminal project checkout or registration survived"
fi
if [ -d "$lwt" ] && git --git-dir="$PBARE" worktree list --porcelain | grep -qxF "worktree $lwt"; then
  ok "terminal helper preserves a different live base"
else
  bad "terminal helper removed another base"
fi
if [ -d "$prefix_wt" ]; then
  ok "terminal helper does not confuse a base with a longer same-prefix base"
else
  bad "terminal helper removed a longer same-prefix base"
fi

# Journal fixture for the scheduled sweep.
JBARE="$TR/journal.git"; JSEED="$TR/journal-seed"
git init -q --bare "$JBARE"
git init -q "$JSEED"; git -C "$JSEED" checkout -qb journal2
mkdir -p "$JSEED/jobs/tada" "$JSEED/jobs/doin" "$JSEED/jobs/plan"
printf 'internal terminal job\n' > "$JSEED/jobs/tada/swept.md"
printf 'closed PR https://github.com/acme/proj/pull/10\n' > "$JSEED/jobs/tada/closed-pr.md"
printf 'same closed PR https://github.com/acme/proj/pull/10\n' > "$JSEED/jobs/tada/closed-pr-again.md"
printf 'open PR https://github.com/acme/proj/pull/11\n' > "$JSEED/jobs/tada/open-pr.md"
printf 'no residue https://github.com/acme/proj/pull/12\n' > "$JSEED/jobs/tada/no-residue-pr.md"
printf '%s\n' '---' 'doomed: true' '---' > "$JSEED/jobs/plan/doomed.md"
printf 'still live\n' > "$JSEED/jobs/doin/live.md"
printf '%s\n' 'complete this job' '---' 'claim:' '  host: testhost' '  gardener: 1' > "$JSEED/jobs/doin/complete-now.md"
git -C "$JSEED" "${git_id[@]}" add jobs
git -C "$JSEED" "${git_id[@]}" commit -qm journal
git -C "$JSEED" remote add origin "$JBARE"
git -C "$JSEED" push -q origin journal2

# The normal completion edge removes project work only after its journal push.
ckey="$(project_worktree_base_key complete-now)"
cwt="$SCRATCH/project-wt-${ckey}-00000003"
git --git-dir="$PBARE" worktree add -q --detach "$cwt" main
printf 'completed\n' > "$TR/complete-report"
GARDEN=testhost GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$STATE" \
  GARDEN_WORKER_CLONE="$STATE/complete-worker/journal" \
  JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH=journal2 GARDEN_NO_MAINTAINER_ALERT=1 \
  bash "$JOBS/complete-job.sh" 1 complete-now "$TR/complete-report" >/dev/null 2>&1
if [ ! -e "$cwt" ] && ! git --git-dir="$PBARE" worktree list --porcelain | grep -qxF "worktree $cwt"; then
  ok "doin-to-tada completion tears down its project worktree after the push"
else
  bad "completion left its project checkout or registration behind"
fi

for base in swept doomed live closed-pr closed-pr-again open-pr; do
  # closed-pr-again exercises project-only residue detection; every other fixture
  # carries both checkout shapes.
  [ "$base" = closed-pr-again ] \
    || git -C "$GROOT" worktree add -q --detach "$SCRATCH/gardener-wt-$base" main2
  key="$(project_worktree_base_key "$base")"
  git --git-dir="$PBARE" worktree add -q --detach "$SCRATCH/project-wt-${key}-00000002" main
done

# A legacy directory with no matching bare-repo registration is an orphan.
mkdir -p "$GROOT/worktrees/acme-proj/legacy-orphan/node_modules/x"

GARDEN=testhost GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$STATE" \
  JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH=journal2 GARDEN_WORKTREE_SWEEP_MAX=100 \
  GARDEN_GH="$HERE/worktree-sweeper-gh-stub.sh" WORKTREE_SWEEPER_GH_CALLS="$TR/gh-calls" \
  bash "$JOBS/worktree-sweeper.sh" >"$TR/sweep.log" 2>&1

terminal_ok=1
for base in swept doomed; do
  [ ! -e "$SCRATCH/gardener-wt-$base" ] || terminal_ok=0
  key="$(project_worktree_base_key "$base")"
  [ ! -e "$SCRATCH/project-wt-${key}-00000002" ] || terminal_ok=0
done
[ "$terminal_ok" -eq 1 ] && ok "sweeper removes completed and doomed garden/project worktrees" \
  || bad "terminal worktree residue survived sweep"

livekey="$(project_worktree_base_key live)"
if [ -d "$SCRATCH/gardener-wt-live" ] && [ -d "$SCRATCH/project-wt-${livekey}-00000002" ]; then
  ok "sweeper preserves non-terminal doin worktrees"
else
  bad "sweeper removed a live doin worktree"
fi

[ ! -e "$GROOT/worktrees/acme-proj/legacy-orphan" ] \
  && ok "sweeper removes an unregistered legacy worktree directory" \
  || bad "legacy orphan survived sweep"

closedkey="$(project_worktree_base_key closed-pr)"
openkey="$(project_worktree_base_key open-pr)"
if [ ! -e "$SCRATCH/gardener-wt-closed-pr" ] && [ ! -e "$SCRATCH/project-wt-${closedkey}-00000002" ]; then
  ok "sweeper corroborates a completed PR against live CLOSED state"
else
  bad "closed-PR completed worktrees survived"
fi
closedagainkey="$(project_worktree_base_key closed-pr-again)"
if [ ! -e "$SCRATCH/gardener-wt-closed-pr-again" ] && [ ! -e "$SCRATCH/project-wt-${closedagainkey}-00000002" ]; then
  ok "sweeper reuses one REST disposition across jobs naming the same PR"
else
  bad "duplicate closed-PR completed worktrees survived"
fi
if [ -d "$SCRATCH/gardener-wt-open-pr" ] && [ -d "$SCRATCH/project-wt-${openkey}-00000002" ]; then
  ok "sweeper fails safe and retains a completed job whose PR is still OPEN"
else
  bad "open-PR worktrees were removed without terminal GitHub state"
fi
if [ "$(wc -l < "$TR/gh-calls")" -eq 2 ] \
   && ! grep -q 'pulls/12' "$TR/gh-calls" \
   && ! grep -q ' pr ' "$TR/gh-calls"; then
  ok "sweeper uses cached REST reads only for jobs with checkout residue"
else
  bad "sweeper made avoidable or GraphQL PR-state reads ($(tr '\n' '|' < "$TR/gh-calls"))"
fi

echo
echo "worktree teardown: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
