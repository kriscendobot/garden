---
ts: 2026-06-19T01:00:53Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - projects/endo-but-for-bots/followups/endo-but-for-bots--468.md
---

Opened DRAFT PR #472 (`chore: act on #468 postponed review items`) on
`endojs/endo-but-for-bots` branch `chore/468-followups` (base `master-80e9b3e`).

Four items from the #468 followup ledger are addressed:

1. `docs(bytes)`: appended freezable-TypedArray usage example to `packages/bytes/README.md` showing `new Uint8Array(bytesToImmutable(view))` after loading the shim.
2. `test(immutable-arraybuffer)`: added subclassing-limitation test to `shim-typedarray.test.js` asserting `new MyArr(iab) instanceof MyArr === false`.
3. `docs(immutable-arraybuffer)`: cited ECMA-262 section 10.4.2 (Integer-Indexed Exotic Objects) in `designs/freezable-typedarray.md` section Indexed assignment.
4. `docs(immutable-arraybuffer)`: corrected "TypeArray" typo to "TypedArray" in `packages/immutable-arraybuffer/README.md`.

Items 6, 7, 8 were confirmed closed in the #468 merged PR's summary-fix bundle.
Item 5 (fast-check tests) remains parked; noted in PR #472 body.

All tests pass: `@endo/immutable-arraybuffer` (218 tests), `@endo/bytes` (32 tests).
Pre-push gates: passed except a pre-existing `test-package-no-main` finding on `packages/chacha12-fast-check-test` (unrelated to this PR's changes).

Followup ledger updated at `projects/endo-but-for-bots/followups/endo-but-for-bots--468.md`.

Self-improvement: nothing this time.
