---
ts: 2026-06-22T23:39:24Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

RSVP to kriskowal CHANGES_REQUESTED review 4546639717 on PR #475.

## Summary

New `@endo/utf8` package created, `bytesFromText`/`bytesToText` removed
from `@endo/bytes`, and parallel UTF-8 modules added to `@endo/pass-style`.

## New package: @endo/utf8

- Mirrors `@endo/hex` and `@endo/base64` shape
- Exports: `encodeUtf8`, `decodeUtf8`, `strictDecodeUtf8`
- Sub-path modules: `encode.js`, `decode.js`, `strict-decode.js`
- 9 tests, all passing across all three ses-ava configs

## Removed from @endo/bytes

- `from-string.js` / `src/from-string.js` (bytesFromText)
- `to-string.js` / `src/to-string.js` (bytesToText)
- `@endo/bytes` now covers only: `concat.js`, `equals.js`, `compare.js`
- Major-version bump in changeset

## New @endo/pass-style exports

- `encode-utf8.js` / `src/encode-utf8.js`
- `decode-utf8.js` / `src/decode-utf8.js`
- `strict-decode-utf8.js` / `src/strict-decode-utf8.js`
- `@endo/utf8` added as runtime dependency

## Consumer updates

All callers in `@endo/ocapn`, `@endo/daemon`, `@endo/cli` updated from
`bytesFromText`/`bytesToText` to `encodeUtf8`/`decodeUtf8`/`strictDecodeUtf8`.
`@endo/utf8` added to runtime deps for each consumer package.

## Test results

- @endo/utf8: 9 tests passed
- @endo/bytes: 12 tests passed
- @endo/pass-style: 50 tests passed
- @endo/ocapn: 260 tests passed
- @endo/daemon: 119 tests passed

## Commits

- 66b56be27 feat(@endo/utf8)!: add @endo/utf8; remove bytesFromText/bytesToText from @endo/bytes; add pass-style UTF-8 parallel modules
- 6a9d11152 chore: Update yarn.lock

Force-pushed to feat/narrow-bytearray-to-uint8 with lease anchor c5944688d.

## GitHub activity

- Inline reply on comment 3454267360: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3456102245
- Top-level summary on PR #475: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4774128552

## Design note for alternative

The ponyfill shape (pass-style delegates to @endo/utf8, degrades to one copy
under shim) is exactly what is landed. A zero-copy decode path under the shim
would require exporting amplifyArrayBuffer from @endo/immutable-arraybuffer.
The memcopy is short-lived; the optimization is a follow-up.

Self-improvement: use `--input <json-file>` (not `--field`) when posting multiline bodies via `gh api`; backticks in `--field` values trigger shell command substitution.
