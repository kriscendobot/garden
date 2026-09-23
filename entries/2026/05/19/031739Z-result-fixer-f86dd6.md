---
ts: 2026-05-19T03:17:39Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - jobs/claimed/20260519T031243Z--endolinbot--general-contractor--11ad--a5f036--multiplier-test-broaden-75.md
---

Job a5f036 (general-contractor 11ad): broadened the `random() multiplies randomUint53 by exactly 2 ** -53` test in `packages/random/test/random.test.js` to four bit-pattern sources per gibson042's r3245953732 and kriskowal's r3263397803.

## File edited

`packages/random/test/random.test.js`, the block around the test of the same name. Test name preserved verbatim so the upstream thread anchor still resolves.

## Expected-value computations

The `randomUint53` recipe (`packages/random/src/uint.js`): read 8 little-endian bytes b0..b7; `lo = b0|b1<<8|b2<<16|b3<<24` (32 bits); `hi32 = b4|b5<<8|b6<<16|b7<<24`; `hi21 = hi32 & 0x1fffff` (low 21 bits of hi32, which is b4 fully, b5 fully, low 5 bits of b6; b7 and high 3 bits of b6 are masked away). Result = `hi21 * 2^32 + lo`, then `random` multiplies by `2^-53`.

- `allSetSource` (every byte `0xff`): `lo = 0xffffffff`, `hi21 = 0x1fffff`, integer = `2^53 - 1`, float = `1 - 2^-53`. Unchanged from the original assertion.
- `allClearSource` (every byte `0x00`): integer = `0`, float = `0`.
- `lo52SetSource` (b0..b5 = `0xff`, b6 = `0x0f`, b7 = `0x00`): `lo = 0xffffffff`, `hi21 = 0x0fffff` (20 bits), integer = `2^52 - 1`, float = `0.5 - 2^-53`.
- `all53SetSource` (b0..b5 = `0xff`, b6 = `0x1f`, b7 = `0x00`): `lo = 0xffffffff`, `hi21 = 0x1fffff`, integer = `2^53 - 1`, float = `1 - 2^-53`. Same float as `allSetSource` but a different byte pattern; the equality is itself the load-bearing claim (11 don't-care bits in the high two bytes cannot influence the output).

The explanatory comment frames the brittleness as a feature per gibson042's r3245953732 framing, and cites both review-comment IDs.

## Commit and head

- Commit: `28d2cd0b3c9729c99dc3c86d89f6418449b25012`
- Subject: `test(random): broaden randomUint53 multiplier assertion to four bit-pattern sources (per r3245953732 + r3263397803)`
- Old head: `9e3a77276`. New head: `28d2cd0b3`. Pushed with `--force-with-lease=kriskowal-random-chacha12:9e3a77276`.
- No `yarn.lock` churn.

## Local validation

- `yarn workspace @endo/random test --match 'random() multiplies*'` passes under all three ses-ava configs (lockdown, unsafe, endo).
- Full `yarn workspace @endo/random test` (15 tests) passes under all three configs.
- `yarn workspace @endo/random lint` exits 0.

## CI status

`gh pr checks 75` reports all 28 checks pending at push + 15s; CI watch deferred to the orchestrator per the dispatch's "fix" lane (not a shepherd dispatch).

## Job completion

`outcome: done`. Job-board move from `claimed/` to `done/` follows below.

## Per-action authorization scope

The push to `kriskowal-random-chacha12` was the only upstream action; no comments, reactjis, or review re-requests were posted (and none were authorized for this dispatch).

Self-improvement: nothing this time. The dispatch brief named `packages/random/src/read-uint.js`; the actual implementation file is `packages/random/src/uint.js`. A future fixer dispatch on a randomUint53 recipe question can save one redirect by grep-resolving the function name across `packages/random/src/` rather than reading the path verbatim, though the path mismatch was self-correcting here.
