# local-verify parity: two divergences on endojs/endo-but-for-bots

Found while running the gate for job
`endojs-endo-but-for-bots-pr881-review-d23c8dbf` in a warm-cache project
worktree. Both are environment divergences under
[local-verify](../skills/local-verify/SKILL.md) § Parity is the contract —
the class the maintainer's standing policy says to close, not work around.

## 1. Warm-cache hit leaves yarn believing the project is not installed

`scripts/jobs/ensure-project-worktree.sh` hardlinks the cached `node_modules`
trees in and skips the install on a cache hit. For this repo
(`nodeLinker: pnpm`) that is not sufficient: yarn's link state is not inside
the copied trees, so every `yarn <script>` in the fresh worktree dies with

    Usage Error: The project in .../package.json doesn't seem to have been
    installed - running an install there might help

and `local-verify.sh` reports ALL SIX steps (format, lint, build, codegen,
test, docs) as FAILED with that one message. The gate is unrunnable for this
repo on a warm-cache worktree, which is a strong incentive for a gardener to
push without it.

Evidence: `node_modules/.yarn-state.yml` is present in
`project-wt-issue-kriskowal-garden-67-4a2df716` and absent from every
`project-wt-*endo-but-for-bots*` worktree checked (5/5).

Confirmed remedy: a plain `yarn install --immutable` in the worktree takes
4.8 seconds on a warm cache (the store is already populated; it only relinks
and writes the state), and every step then runs. So the fix is cheap: after a
WARM-CACHE hit, run the package manager's install to reconcile its link state,
rather than assuming the copied trees are the whole install. Verify it does not
defeat the cache's purpose — time it on a cold vs warm worktree and log the
delta the way the hit is already logged.

## 2. `@endo/agentry` conflict-rebase eval test fails locally, passes on CI

With (1) worked around, `format`/`lint`/`build`/`codegen`/`docs` all pass and
only `test` fails, on:

    eval > conflict-rebase > outcome assertion fails when conflicted worktree
    is left mid-rebase
    Error: Command failed: git rebase integration

`packages/agentry/test/eval/conflict-rebase.test.js:406` deliberately runs a
rebase it expects to conflict, catches the failure, and rethrows unless
`git status --porcelain` contains `UU app.txt`. So locally the rebase fails
WITHOUT leaving an unmerged `app.txt` — a different git behavior, not a
different assertion. Prime suspects: a `rerere` or merge-driver setting
reachable from the fixture repo, or a git-version default difference in the
container. Note this is adjacent to `b6cffb8d17` (run verification steps
against repo-local git config only) and may be a regression from it or may be
what that change was reaching for; check both directions.

This one failure aborts the whole monorepo `test` step, so it masks every
package downstream of `@endo/agentry` — including the package actually under
change. CI's `test` job is green on the same tree, so this is squarely an
environment divergence.

## Done when

Both are closed such that `scripts/jobs/gardening/local-verify.sh` runs to a
real verdict in a fresh warm-cache worktree of `endojs/endo-but-for-bots`, and
the local-verify skill's field notes record each with its tell (the
`_2026-07-28_` entries are the format to follow).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: gardener
  claimed_at: 2026-07-28T21:51:59Z
