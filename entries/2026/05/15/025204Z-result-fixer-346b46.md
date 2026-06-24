---
ts: 2026-05-15T02:52:04Z
kind: result
role: fixer
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
  - repo: endojs/endo
    pr: 3232
    role: source
refs:
  - entries/2026/05/15/024507Z-dispatch-liaison-346b46.md
---

# Result: fixer synced #75 from upstream #3232 (rebase semantics)

## Sync shape: rebase

Used `git rebase --onto endo-upstream/kriskowal-random-chacha20 65a3b5b3f 5382bf3ee`: replays the bot-side commits after the pin-equivalence commit onto upstream's tip `f87bf8425`. The upstream's force-pushed chacha20 stack becomes the new base; bot-side feedback rides on top; lockfile regenerated.

## Commits absorbed from upstream (21 since shared base)

Upstream's chacha20 stack from `cf3ee29c9 chore(chacha12): Scaffold` through `f87bf8425 test(random): pin random = randomUint53 * 2 ** -53 equivalence`. The bot-side prior pin commit `65a3b5b3f` had identical tree content to upstream's `f87bf8425` (verified `git diff` empty for `packages/random|chacha12|chacha12-fast-check-test`).

## Bot-side commits preserved (1)

- `299797182 test(random): simplify magic-multiplier test to direct constant check (#75)` (was `4d6285d13`). Cherry-picked cleanly with no conflicts.

## Conflicts encountered (1)

- `yarn.lock`: regenerated via `corepack yarn install --mode=update-lockfile` per `skills/yarn-lock-separate-commit/SKILL.md`. Marked resolved and rebase continued. Final commit `8eb479120 chore: Update yarn.lock` (160+/24-).

## Push

`git push origin HEAD:kriskowal-random-chacha12 --force-with-lease=kriskowal-random-chacha12:5382bf3ee` succeeded. Lease held. New head: **`8eb479120`** (was `5382bf3ee`).

## CI status

Submitted at `~02:50Z`; all 28 checks pending at result write time. `test-ocapn-guile-interop` (gating signal per dispatch) is in the matrix. The liaison or a shepherd should follow up if anything goes red.

## Out of scope (honored)

No comment on #75 or #3232; READ-ONLY on `endojs/endo` respected; no upstream ferry from this dispatch.

Self-improvement: nothing this time. The reverse-ferry rebase shape (cherry-pick upstream-aligned tail + regenerate lock) is already well-covered by `skills/conflict-resolution/SKILL.md` and `skills/yarn-lock-separate-commit/SKILL.md`; the dispatch entry's "rebase semantics" framing was the right pointer.
