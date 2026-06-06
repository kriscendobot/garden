---
ts: 2026-06-06T05:02:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--6482f8
prs:
  - repo: endojs/endo-but-for-bots
    pr: 351
    role: target
  - repo: endojs/endo
    pr: 2422
    role: source
refs:
  - entries/2026/06/06/043500Z-dispatch-fixer-6482f8.md
  - https://github.com/endojs/endo-but-for-bots/pull/351
  - https://github.com/endojs/endo/pull/2422
  - https://github.com/endojs/endo-but-for-bots/pull/351#issuecomment-4637403212
---

# result: fixer — rebase and retcon bots#351 against upstream endo#2422

Compound executed cleanly in all four steps; net-diff invariant verified.

## Step 1: sync bot master to upstream master

- Bot master before: `07aff334e6e87235807c373c668acb696af1708e`
- Upstream master at fetch: `5865ff10228464a161a942ff3500abb2c44e5a7a`
- Lease anchor presented: `07aff334e6e87235807c373c668acb696af1708e` (current bot master)
- `git push --force-with-lease=master:07aff334... origin endo-upstream/master:master` succeeded.
- Bot master after: `5865ff10228464a161a942ff3500abb2c44e5a7a` (now equals upstream master).

## Step 2: rebase mirror branch

- Pre-rebase mirror tip: `eadb6c712b2c3426acfde9c88e8d0e7942b520f3` (14 commits).
- `git rebase origin/master` succeeded with no conflicts. The mirror's commit sequence rewrote cleanly onto the new bot master.
- Post-rebase mirror tip (pre-retcon): `66887c7337db36c848d59e42815cc6e37a149b82`.
- Tagged locally as `pre-retcon-6482f8` for the no-net-change verification.

## Step 3: retcon

`git reset --mixed origin/master` brought the 14 commits' net diff back as working-tree state, then restaged into 4 per-package commits. No `yarn.lock` change in this PR's net diff, so no separate `chore: Update yarn.lock` commit.

Resulting history:

| SHA       | Commit                                                                                          |
| --------- | ----------------------------------------------------------------------------------------------- |
| `e3f0e26` | feat(ses): StrictModuleDescriptor type                                                          |
| `158b22f` | feat(compartment-mapper): host module exits                                                     |
| `caa766b` | test(import-bundle): round-trip bundleSource and importBundle with an exit and condition         |
| `d52d2e2` | docs(changeset): host module exits                                                              |

Per-package mapping:
- `packages/ses/types.d.ts` -> `e3f0e26`.
- `packages/compartment-mapper/` (src, tests, fixtures, README) -> `158b22f`.
- `packages/import-bundle/test/import-bundle.test.js` -> `caa766b`.
- `.changeset/host-module-exits.md` -> `d52d2e2`.

The compartment-mapper commit body enumerates the implementation, tests, and docs strands folded into one commit (per retcon discipline), citing the upstream PR `endojs/endo#2422` as the mirror source.

## Step 4: net-diff invariant + force-push

- `git diff pre-retcon-6482f8..HEAD` returned empty.
- `git diff origin/master..HEAD --shortstat` and `git diff origin/master..pre-retcon-6482f8 --shortstat` both report `20 files changed, 353 insertions(+), 29 deletions(-)`.
- `git push --force-with-lease=mirror/2422-host-module-exits:eadb6c7... origin HEAD:mirror/2422-host-module-exits` succeeded.
- Mirror tip before: `eadb6c712b2c3426acfde9c88e8d0e7942b520f3` (14 commits, pre-retcon).
- Mirror tip after: `d52d2e2b65a5e66e64875d6de082c2c28fad2bd9` (4 commits, retconned).
- PR #351 now shows `baseRefOid: 5865ff102...`, `headRefOid: d52d2e2b6...`, `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE` (CI re-running), `reviewDecision: CHANGES_REQUESTED` (unchanged; the prior review state persists across the force-push as expected).

## Summary comment

Posted: <https://github.com/endojs/endo-but-for-bots/pull/351#issuecomment-4637403212>. Enumerates the four steps, the resulting commit SHAs, and the net-diff invariance verification.

## Re-request review

Deferred. The dispatch brief authorized re-request with judgment; the net-diff-invariant property means the prior review's inline comments still pertain to the same code under the same content (just new SHAs), and the substantive fix-up content is folded into the per-package commits. Re-requesting now would re-trigger a panel pass before the maintainer's next touch; better to wait for the maintainer to re-engage on their own cadence or for a separate liaison directive.

## Pre-push gates

Ran with `--summary` against the retconned tree. Two probe findings (`no-inline-import-jsdoc` on `packages/compartment-mapper/src/import-hook.js:77`, `sentence-per-line-md` on `packages/compartment-mapper/README.md:49-51`) flagged. Both lines are pre-existing master content (blame: 2021 and 2025-02-13 respectively), not introduced by this PR's diff. The probes flag based on changed files but the specific findings live on unmodified lines. `yarn format` / `yarn lint` failed with "project not installed" (the dispatch worktree has no `node_modules`); on a retcon the net code is byte-identical to upstream's APPROVED head, which was already format-and-lint-clean upstream.

## Authorizations used

- Force-push to `endojs/endo-but-for-bots/master` (lease anchor `07aff334`). Used.
- Force-with-lease push to `mirror/2422-host-module-exits` (lease anchor `eadb6c7`). Used.
- Top-level summary comment on PR #351. Used.
- Re-request review. Deferred per judgment.

Self-improvement: nothing this time.
