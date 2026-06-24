---
ts: 2026-05-22T18:54:32Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/005247Z-result-liaison-1a7ad4.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 253
    role: source
  - repo: endojs/endo
    pr: 3258
    role: target
---

Re-ferry `endojs/endo-but-for-bots#253` over `endojs/endo#3258`. **Recompute-from-master force-push-with-lease**. Source has been re-rebased; upstream is APPROVED but CONFLICTING with current master. Dispatched in parallel with #352 ferry.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #253 (OPEN, MERGEABLE).
- Branch: `chore/package-uniformity-master`
- Head: `f5ad0c1ea09e71d2e340e0131837ccddc7f69f95`
- 6 commits, all `endolinbot <main.barn5084@fastmail.com>` (need attribution rewrite to `Kris Kowal <kriskowal@kriskowal.com>`), authored 2026-05-22T04:10-04:11Z:
  1. `58bfc486 ci: enforce general package uniformity across workspace`
  2. `06ff3f22 chore: align SECURITY.md across packages`
  3. `a31d87e3 chore: add LICENSE to packages that were missing it`
  4. `797828e1 chore(packages): fix repository/bugs fields and document type exception`
  5. `57bdb189 chore(packages): fill in descriptions for ocapn and ocapn-noise`
  6. `f5ad0c1e chore(packages): align .author on SES-heritage packages to 'Endo contributors'` (revertible per the prior #253 ferry's note)

## Upstream

- Repo: `endojs/endo`, PR #3258.
- Branch: `chore/security-md-uniformity`
- Current head: `e98151eda59f3e92651b3aed3aa165ef714f77e7` (from prior ferry).
- State: OPEN, **APPROVED**, CONFLICTING with master (`6804b7dc8`). Branch unprotected; approval should persist across force-push.
- Title (leave untouched): `chore: enforce general package uniformity across workspace`.

## Human

`Kris Kowal <kriskowal@kriskowal.com>`. **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-package-uniformity-253-rebase--20260522-185408--f5f4b6/`. Project worktree on `endojs/endo:chore/security-md-uniformity` (detached at `e98151eda`).

## Boatman direction

- Detach at `origin/master` (`6804b7dc8aafe56a0812039d77f2b01a625b7a0e`).
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- Cherry-pick all 6 commits in order. Preserve as 6 commits (deliberate per-aspect split; the SES-heritage `.author` flip in commit 6 stays revertible).
- `cherry-pick + git commit --amend --reset-author --no-edit` per commit.
- **Trailer-strip discipline**: `git interpret-trailers --parse` per commit. Always.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows 6 commits, all `Kris Kowal <kriskowal@kriskowal.com>`.
- **Path-restricted tree-identity check**: per the standing lesson, compute via `PATHS=$(git diff origin/master..HEAD --name-only)` then `git diff f5ad0c1e HEAD -- $PATHS`. Should be empty.
- **Conflict handling**: yarn.lock and per-package package.json files may conflict with the 8 new master commits since `bf951df3`. If non-trivial, regenerate yarn.lock via `YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install --mode=update-lockfile` with `enableScripts: false` / `nodeLinker: node-modules`.
- **Pre-flight ancestor/lease check**: refetch `origin/chore/security-md-uniformity`; verify still at `e98151eda`.
- **Force-push with lease**: `git push origin HEAD:chore/security-md-uniformity --force-with-lease=chore/security-md-uniformity:e98151eda59f3e92651b3aed3aa165ef714f77e7`.
- **Title and body untouched** (user didn't ask).
- **Approval-persistence verification** post-push.
- Source-side cross-link on `endojs/endo-but-for-bots#253`: post under kriskowal. Name new upstream head SHA + 6-commit shape + the CONFLICTING→MERGEABLE expectation.
- **Identity discipline on `endojs/endo#3258`**: NO direct comments.

## Expected report

≤300 words: upstream head SHA + 6 new commit SHAs in order, attribution, path-restricted tree-identity, pre-flight + push mode, approval persistence, mergeability state after push, source-side cross-link URL, one-line self-improvement.
