---
ts: 2026-05-22T18:54:33Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/062833Z-result-liaison-6c7e30.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 352
    role: source
  - repo: endojs/endo
    pr: 3274
    role: target
---

Re-ferry `endojs/endo-but-for-bots#352` over `endojs/endo#3274`. **Recompute-from-master force-push-with-lease**. Source #352 is the fresh redo of #67 after the bot accidentally squash-merged #67 and reset bot-master per the source body. Dispatched in parallel with #253 ferry.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #352 (OPEN, non-draft, MERGEABLE).
- Branch: `design/issue-2390-harden-exports-patterns`
- Head: `2e8b3f89ad67d6a6bf8c96caef05eef41a8fff47`
- 1 commit: `2e8b3f89 fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)` by `endolinbot <main.barn5084@fastmail.com>` (rewrite to `kriskowal@kriskowal.com`).
- The source body explains: predecessor PR #67 was accidentally squash-merged at 2026-05-22T02:22Z, bot-master was reset to `6804b7dc8`, and the branch was rebased onto current master with zero conflicts. This is the resubmission.

## Upstream

- Repo: `endojs/endo`, PR #3274.
- Branch: `kriskowal-harden-exports-2390`
- Current head: `c2f53e866648e8ca0918483fb56f14f0de0d6f7d`
- State: OPEN, non-draft, MERGEABLE, **APPROVED**. Branch unprotected; approval should persist across force-push.
- Title (leave untouched): `fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)`.

## Human

`Kris Kowal <kriskowal@kriskowal.com>`. **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-harden-exports-352--20260522-185420--f549ee/`. Project worktree on `endojs/endo:kriskowal-harden-exports-2390` (detached at `c2f53e866`).

## Boatman direction

- Detach at `origin/master` (`6804b7dc8aafe56a0812039d77f2b01a625b7a0e`).
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- Cherry-pick `2e8b3f89`. Single commit.
- `git commit --amend --reset-author --no-edit` to rewrite author + committer.
- **Subject**: keep verbatim — `fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)` (already upstream-correct; `(#2390)` resolves to `endojs/endo#2390`).
- **Body**: preserve the substance; drop any bot trailers (`Co-Authored-By: Claude` etc. — the prior #67 ferry had these and the boatman caught them). Ensure `Fixes #2390` or `Closes #2390` is in the body.
- **Trailer-strip discipline**: `git interpret-trailers --parse`. Always.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows one commit, `Kris Kowal <kriskowal@kriskowal.com>`.
- **Path-restricted tree-identity check**: per the standing lesson.
- **Pre-flight ancestor/lease check**: refetch `origin/kriskowal-harden-exports-2390`; verify still at `c2f53e866`.
- **Force-push with lease**: `git push origin HEAD:kriskowal-harden-exports-2390 --force-with-lease=kriskowal-harden-exports-2390:c2f53e866648e8ca0918483fb56f14f0de0d6f7d`.
- **Title and body untouched** on #3274 (user did not ask for changes).
- **Approval-persistence verification** post-push.
- Source-side cross-link on `endojs/endo-but-for-bots#352`: post under kriskowal. Name new upstream head SHA, the 1→1 cherry-pick + amend, the predecessor-#67 context.
- **Identity discipline on `endojs/endo#3274`**: NO direct comments.

## Expected report

≤250 words: upstream head SHA + new commit SHA, attribution verified, path-restricted tree-identity, pre-flight + push mode, approval persistence, source-side cross-link URL, one-line self-improvement.
