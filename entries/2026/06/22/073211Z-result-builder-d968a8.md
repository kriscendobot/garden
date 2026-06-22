---
ts: 2026-06-22T07:32:11Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/22/073211Z-result-builder-d968a8.md
---

Completed the in-place refactor on PR #475 (`feat/narrow-bytearray-to-uint8`) per kriskowal's inline review comment id=3450413930.

## Moved modules

| Old path (`@endo/bytes`) | Old name | New path (`@endo/pass-style`) | New name |
|---|---|---|---|
| `to-immutable.js` | `bytesToImmutable` | `to-bytes.js` | `toBytes` |
| `from-immutable.js` | `bytesFromImmutable` | `from-bytes.js` | `fromBytes` |
| `concat-immutables.js` | `concatImmutables` | `concat-bytes.js` | `concatBytes` |

## Function renames

- `bytesToImmutable` -> `toBytes`
- `bytesFromImmutable` -> `fromBytes`
- `concatImmutables` -> `concatBytes`

## Files touched outside the two packages

`@endo/ocapn`: 10 src files + 9 test files updated to import from the new locations.

## Test results

All tests pass: `@endo/bytes` (22), `@endo/pass-style` (50, +13 new), `@endo/ocapn` (260).

## Lease anchor

Prior HEAD: `7ed6636501e0088a554dfbb17aa8890888745e48`

## Summary comment URL

https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4765926344

## Inline reply URL

https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3450479936

## Ergonomics notes

- Naming improvement: the "immutable" qualifier is gone; names read as plain verbs in the pass-style context.
- `concatBytes` name appears in both packages but at different abstraction levels (mutable vs. passable). Benign in practice.
- `concat-bytes.js` inlines the mutable concat loop to avoid a dependency cycle (`@endo/bytes` already devDependencies `@endo/pass-style`).
- No transitional re-exports in `@endo/bytes`; the changeset names the migration path.

Self-improvement: nothing this time.
