---
ts: 2026-05-22T20:54:38Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/22/012857Z-result-liaison-a98757.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 64
    role: source
  - repo: endojs/endo
    pr: 3277
    role: target
---

Re-ferry `endojs/endo-but-for-bots#64` over `endojs/endo#3277`. Source rebased to new SHAs (same 3 commits content-wise) on fresh master; upstream is CONFLICTING with master. Recompute-from-master force-push-with-lease, 3→1 squash. Same shape as the original #64 ferry at `entries/2026/05/22/012857Z-result-liaison-a98757.md`.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #64. State OPEN, MERGEABLE.
- Branch: `design/issue-2632-harden-exports-pattern-makers`
- Head: `937c81eacd71361975fa852cfae57ae5dbcfad41`
- 3 commits, all `Kris Kowal <kriskowal@kriskowal.com>`:
  1. `2806a81d feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)`
  2. `20c3e93d feat(eslint-plugin): no-harden-pattern-maker rule (#2632)`
  3. `937c81ea chore: drop UNNECESSARY-HARDENS.md (moved to PR comment per #64 review)`

## Upstream

- Repo: `endojs/endo`, PR #3277.
- Branch: `kriskowal-harden-exports-pattern-makers-2632`
- Current head: `7d853dc825668ad56339f4909df41a88b51c0f3e`
- State: OPEN, CONFLICTING with master `455ce4749`, REVIEW_REQUIRED. Branch unprotected.
- Title (leave untouched).

## Human

`Kris Kowal <kriskowal@kriskowal.com>`. **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-pattern-makers-64-rebase--20260522-205425--9d5c78/`. Project worktree on `endojs/endo:kriskowal-harden-exports-pattern-makers-2632` (detached at `7d853dc8`).

## Boatman direction

- Detach at `origin/master` (`455ce4749`), NOT at upstream tip.
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- `git cherry-pick --no-commit 2806a81d 20c3e93d 937c81ea` to stage combined diff.
- **Compose subject + body** with `git commit --amend -F <cleaned-msg>` (per the #352 self-improvement: `--no-edit` preserves Claude `Co-Authored-By:` trailers; pre-build cleaned message instead).
  - **Subject**: `feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)` (verbatim).
  - **Body**: substance for both lint rules; @erights's comment quote (cite the correct ID — verify directly via `gh api repos/endojs/endo/issues/2632/comments`; my prior dispatch used `#issuecomment-2479055797` which the boatman flagged as wrong; the correct ID is `#issuecomment-2477602697`); `Fixes #2632`. Drop test-plan checklists and any bot-internal references.
- **Path-restricted tree-identity check**: `PATHS=$(git diff origin/master..HEAD --name-only)`; `git diff 937c81ea HEAD -- $PATHS` should be empty.
- **Trailer-strip discipline**: `git interpret-trailers --parse`. Always.
- **Verify attribution**: one commit, all `Kris Kowal <kriskowal@kriskowal.com>`.
- **Pre-flight ancestor/lease check**: refetch `origin/kriskowal-harden-exports-pattern-makers-2632`; verify still at `7d853dc8`.
- **Force-push with lease**: `git push origin HEAD:kriskowal-harden-exports-pattern-makers-2632 --force-with-lease=kriskowal-harden-exports-pattern-makers-2632:7d853dc825668ad56339f4909df41a88b51c0f3e`.
- **Title and body untouched** on #3277.
- **Mergeability check** post-push: expect CONFLICTING → MERGEABLE.
- Source-side cross-link on #64: post under kriskowal. Name new upstream head + 3→1 squash + CONFLICTING→MERGEABLE.
- **Identity discipline on #3277**: NO direct comments.

## Expected report

≤300 words: upstream head SHA + new commit SHA, attribution, path-restricted tree-identity check, pre-flight + push mode, mergeability state, source-side cross-link URL, one-line `Self-improvement: ...`.
