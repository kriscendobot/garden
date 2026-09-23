---
ts: 2026-06-17T00:00:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

Addressed erights review comment on PR #473 (review 4530085530).

The prior code accepted 0 to `length`-many own indexed properties on a
frozen emulated Uint8Array wrapper as long as each agreed with the buffer
byte. erights clarified that the emulated shape must have NO own indexed
properties regardless of length; any own indexed property (even one whose
value matches the buffer byte) is post-construction tampering.

Changes landed in commit 520a04012:

- `packages/pass-style/src/byteArray.js`: rewrote the JSDoc for
  `assertRestValidPlainFrozenUint8Array` to describe two distinct shapes
  (emulated: 0 own indexed props; native: exactly `length`-many). Added an
  `ownIndexCount` accumulator and a post-loop assertion that rejects any
  count other than 0 or `length`.

- `packages/pass-style/test/byteArray.test.js`: added two new tests:
  (1) accepts a non-empty (8-byte) emulated wrapper with no own indexed
  properties; (2) rejects an emulated wrapper where `view[0]` was written
  with the same byte value the buffer holds. Renamed the zero-length
  acceptance test to make the emulated/no-own-indexed-props framing
  explicit.

All 41 pass-style tests pass. Pre-push gates pass on the changed paths
(one pre-existing `test-package-no-main` failure on `chacha12-fast-check-test`
is unrelated and pre-dates this PR).

Posted a top-level comment at-mentioning @erights citing 520a04012.

Self-improvement: the fixer role file at `roles/fixer/AGENT.md` says "rules out the emulated case where a caller wrote view[i] = x... whose value differs"; this language was accurate before this fix but should track the updated check. Worth a future self-improvement pass after this PR closes.
