---
posted_at: 2026-11-07T20:27:30Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: project worktrees are read-only inside the monk sandbox (EROFS), stalling every monk project job

Garden-repo fix on `main2` (no PR; push directly per CLAUDE.md conventions).

**Symptom (reproduced 2026-11-07T20:26Z on endolin-garden-ece02cb4, from inside a monk job):**
`scripts/jobs/ensure-project-worktree.sh <base> kriscendobot/minion.town main` fails:
`cannot open '/home/kris/garden/worktrees/kriscendobot-minion.town.git/FETCH_HEAD': Read-only file system`
then `fatal: could not create directory of '.../kriscendobot-minion.town.git/worktrees/project-wt-...': Read-only file system`.

**Cause:** `scripts/secrets/run-sandboxed.sh` does `--ro-bind / /` and binds read-write only the
gardener's own garden worktree (+ its git dirs), a per-job TMPDIR, a per-job GARDEN_STATE, and `--rw`
paths. Commits 36f97ae8eff (TMPDIR) and f2788117645 (GARDEN_STATE) fixed two halves of this class, but
the shared project bare repos `$GARDEN_ROOT/worktrees/*.git` and the project-worktree area
`$GARDEN_ROOT/scratch/project-wt-*` remain read-only, and the monk launcher passes no `--rw`.
So every monk conductor/fixer/weaver/builder/gauntlet job that needs a project checkout exits, requeues,
and is reaper-doomed `requeue-exhausted` / `repeated-plain-exit`. Current casualties (all minion.town,
parked in `jobs/plan/`): `screen-minion-town-pr246-93329d9-conduct-r2`,
`kriscendobot-minion-town-pr237-screen-304dd248-gauntlet-panel-1`,
`kriscendobot-minion-town-pr252-screen-528d4a1f-gauntlet-panel-1`,
`kriscendobot-minion.town-pr248-gauntlet-panel-7`, `kriscendobot-minion.town-pr248-review-edbd57fa`.

**Fix direction:** make the project-checkout path writable inside the sandbox without widening the rest
of the root, e.g. bind `$GARDEN_ROOT/worktrees` (bare repos: FETCH_HEAD, refs, `worktrees/` admin dirs,
objects) and the project-worktree parent used by `ensure-project-worktree.sh` read-write in
`run-sandboxed.sh` (or pass them as `--rw` from the monk/cleric launchers, mirroring `opencode.sh --rw`).
Check that the project-worktree repo-lock under GARDEN_STATE still serializes across jobs (the per-job
GARDEN_STATE may otherwise give each job its own lock; same reasoning as the repo-locks link-back).
Keep secret dirs tmpfs-hidden. Add a regression test beside `scripts/jobs/test/run-sandboxed-tmpdir-test.sh`
asserting the binds. Run the sandbox tests before pushing.

**Done when:** fix pushed to main2; report names the commit. After the host deploys it, the
minion.town arc supervisor re-arms the parked jobs above (do not re-arm them yourself before deploy).

<!-- garden-productive-cycle -->
<!-- garden-transient-elapsed: kind=exit0 through=0 values=165 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-07T20:28:55Z
