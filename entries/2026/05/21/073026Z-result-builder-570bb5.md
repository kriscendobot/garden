---
ts: 2026-05-21T07:30:26Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--570bb5
refs:
  - entries/2026/05/21/072442Z-dispatch-liaison-570bb5.md
---

# Result: builder 570bb5 — endojs/endo-but-for-bots PR #336 (issue #59 mirror)

PR: https://github.com/endojs/endo-but-for-bots/pull/336 (DRAFT).

## 1. Commits cherry-picked

1 commit (the kriscendobot mirror is a single squashed commit, not the 2-3 the dispatch anticipated). Subject: `fix(ses): resolve cyclic star-export reexport rename (#59)`. Original SHA `461c392dc14535a353d4bfa793fc39b9bc7cb762`, cherry-picked clean to `f6c2f28155e817f185eeb4bcc6ca1ba036e3d07e`. Authorship preserved as `endolinbot <main.barn5084@fastmail.com>` (the kriscendobot commit was already bot-authored, so no identity rewrite was needed).

Base updated from the dispatch's snapshot (`9213d2c5`, stale) to current bot-fork `master@bf951df34` so the PR opens against live tip.

## 2. Test outcomes per package

- `yarn workspace ses lint`: clean (1 pre-existing JSDoc warning on `compartment.js:340`, unrelated)
- `yarn workspace ses test`: 502 passed + 2 known failures + 2 skipped. The new `import-gauntlet › cyclic star export with renaming reexport (issue #59)` test is among the 502 passes. (Dispatch anticipated 503; the actual count is 502, consistent with the gauntlet test being the +1 over the prior 501 baseline.)
- `yarn workspace @endo/module-source test`: 53 passed
- `yarn workspace @endo/compartment-mapper test`: 882 passed + 6 known failures (within tolerance)

## 3. Branch + head SHA pushed

`fix/issue-59-star-export-cycle` on `endojs/endo-but-for-bots` at `f6c2f28155e817f185eeb4bcc6ca1ba036e3d07e`.

## 4. PR URL

https://github.com/endojs/endo-but-for-bots/pull/336 (draft, base `master`, head `fix/issue-59-star-export-cycle`).

PR body cites endojs/endo#59 (2019), prior verification by builder 8e2aba (kriscendobot branch at `461c392dc`), the surface crash today (`TypeError: notify is not a function` at `module-instance.js:364`), the cross-fork PR-create block, the deferred forwarding notifier shape, and the regression test (with revert-and-reapply evidence captured in the commit message).

## 5. Self-improvement

Self-improvement: when the dispatch states a project worktree head SHA, check it against `origin/<base>` first; if the worktree's local branch is stale relative to the bot-fork, re-detach onto the current tip before cherry-picking so the PR opens against a live base rather than a snapshot a few hours old.
