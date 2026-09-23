---
ts: 2026-05-14T05:01:23Z
kind: result
role: fixer
project: endo-but-for-bots
worktree: dispatches/fixer--carry-3232-feedback-to-75--20260514-044728--d0c5ed/project/
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
  - repo: endojs/endo
    pr: 3232
    role: source-of-feedback
refs:
  - entries/2026/05/14/044729Z-dispatch-liaison-d0c5ed.md
---

# Result: fixer carried endo#3232 feedback to endo-but-for-bots#75

Read kriskowal's 9 inline review comments on endojs/endo#3232 (read-only over there), located the equivalent file/line on this PR's branch, applied the fixes, rebased onto current `endojs/endo-but-for-bots@master` (no conflicts), and force-pushed the result to `kriskowal-random-chacha12`. Then posted one summary comment on PR #75 with per-comment citations.

## Carried fixes (commit -> kriskowal comment IDs)

- `35039ccee` `fixup(ocapn)!: revert gratuitous randomNumber rename (#75)` -- comments `3239081576` (`packages/ocapn/test/codecs/passable-fuzz.test.js:128`) and `3239082370` (`packages/ocapn/test/syrup/fuzz.test.js:102`). Renamed `randomNumber` back to `random` in both fuzz tests; verified no shadowing with the `random as randomFloat` import (the imported name `random` is not introduced into the value namespace).
- `ccb207c46` `chore(changeset): consolidate chacha12 changesets per #75 review` -- comments `3239072009` (consolidation), `3239062983` (omit gratuitous process comment), `3239068864` (drop "Rewires the `@endo/hex` ..." paragraph), `3239067688` (update `makeChaCha12` interface to `ChaCha12Generator` record with `fillRandomBytes`), `3239064618` (drop pure-rand v5 wording in favor of v8 / fast-check v4). Folded `.changeset/chacha12-next-getstate.md` into `.changeset/endo-chacha12.md`; the consolidated changeset describes the actual landed shape.
- `bb24053ae` `test(random): pin random = randomUint53 * 2 ** -53 equivalence (#75)` -- comment `3239085874` (`packages/random/src/random.js:10`). Added a test with three fixed-byte mock `RandomSource`s (uint53 = 1, `2 ** 53 - 1`, mid-range `0x12345 * 2 ** 32 + 0xdeadbeef`) asserting `random(mock) === uint53 * 2 ** -53` exactly. Pins the multiplier so the magic constant in `random.js` cannot silently drift off `2 ** -53`.

## Out-of-scope / deferred

- Comment `3223144963` on `packages/chacha12/test/chacha12.test.js:14` ("Could break the cycle with a/the hex-test package"). Soft suggestion that would require a new `@endo/hex-test` workspace package; deferred for a separate refactor.
- gibson042's review on #3232 and the Copilot review on #3232. Per the dispatch, this fixer was scoped to kriskowal's inline comments only.

## Local validation

- `yarn lint` clean (two pre-existing warnings in unrelated packages: `evasive-transform`, `ses`).
- `yarn lint:types` clean in `packages/random`, `packages/chacha12`, `packages/ocapn`.
- `yarn test` (= `ses-ava`) clean in `packages/random` (15 tests, including the new equivalence test) and `packages/chacha12` (32 tests).
- Both touched ocapn fuzz tests (`syrup/fuzz.test.js`, `codecs/passable-fuzz.test.js`) pass under `yarn test` (lockdown, unsafe, and endo configs).
- Pre-existing failures in `packages/ocapn` unrelated to this carry: a `sliceToImmutable is not a function` error from `src/buffer-utils.js` and an `assert is not defined` from `@endo/eventual-send/src/message-breakpoints.js` under raw `yarn ava`; both reproduce on the prior head `836928335` before any of these commits. Pre-existing ava-runner timeout on `chacha12/test/fill-random-bytes.bench.js`.

## Push

`git push origin HEAD:kriskowal-random-chacha12 --force-with-lease=kriskowal-random-chacha12:836928335...` succeeded; PR #75 head is now `bb24053ae`.

## Summary comment

Posted on #75 at https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4447700790. Lists each carried comment ID with the equivalent commit SHA and the file/line touched.

## Self-improvement

The fixer's `review-feedback-followup-commits` skill names "one concern per commit" but the changeset comments here (5 kriskowal comment IDs on .changeset/ files) naturally land in a single commit because they are all rewrites of the same prose. Folding all five changeset edits into one commit preserved the spirit of the rule (a reviewer who disagreed with one of the five could ask the whole commit to be revised) without splitting prose for its own sake. The skill could call out the changeset-prose case explicitly so a future fixer is not tempted to split. Surfacing this as a message to liaison rather than embedding the lesson here.
