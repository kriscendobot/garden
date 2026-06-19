---
ts: 2026-06-19T05:13:24Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/19/040630Z-result-researcher-4d4868.md
---

Opened PR #475 (DRAFT) narrowing the `byteArray` pass style to plain
frozen `Uint8Array` only, per @erights's request on PR #473 issue
comment 4748544421. Stacked on top of #473's branch
(`feat/pass-style-byte-array-plain-frozen-validation`) so the diff
shows only the narrowing on top of #473's broadening.

PR: https://github.com/endojs/endo-but-for-bots/pull/475
Head: `feat/narrow-bytearray-to-uint8`
Base: `feat/pass-style-byte-array-plain-frozen-validation`

## Per-commit substance

1. `feat(pass-style): narrow byteArray to Uint8Array-only` — drop the
   raw IAB acceptance arm from `confirmCanBeByteArray` and the
   corresponding branch from `assertRestValid`. The IAB sub-check
   survives as `assertRestValidImmutableArrayBuffer`, reached only as
   the backing-buffer sub-check on a Uint8Array wrapper.
   `ByteArray = Uint8Array` in `types.d.ts`. `arb-passable.js`
   generator wraps the IAB in `new Uint8Array(...)`.
   `patterns/src/type-from-pattern.ts` resolves `byteArray` to
   `Uint8Array`; `patterns/test/types.test-d.ts` expects `Uint8Array`
   from `M.byteArray()`; `patterns/src/patterns/patternMatchers.js`
   tightens the byteLength cast to `Uint8Array`;
   `patterns/test/pattern-limits.test.js` wraps the specimen.
2. `test(pass-style): assert IAB shape is now rejected as byteArray` —
   flip the two prior IAB-acceptance tests to assert rejection;
   rewrite the header comment.
3. `feat(bytes): bytesToImmutable returns Uint8Array; update consumers`
   — wrap the IAB in `harden(new Uint8Array(...))`; widen
   `bytesFromImmutable` and `concatImmutables` input types to
   `ArrayBufferView | ArrayBufferLike`; update tests and README.
4. `refactor(marshal): remove dead ArrayBuffer arm from byteArray
   rank compare` — collapse the dual-branch read in `rankOrder.js`
   into a direct `Uint8Array` cast.
5. `refactor(ocapn): tighten syrup writeBytestring types for
   Uint8Array` — widen `writeBytestring`'s parameter type to
   `ArrayBufferView | ArrayBufferLike`; widen the `value instanceof
   ArrayBuffer` dispatch guards in `js-representation.js` and
   `codec.js` to also accept `Uint8Array`; widen
   `compareImmutableArrayBuffers`'s parameter types.
6. `fix(patterns): relax byteArray pattern-limits regex to match
   Uint8Array render` — the rendered placeholder for a hardened
   frozen `Uint8Array` is not `[Uint8Array]`; relax the regex.
7. `chore(pass-style,ocapn): adjust type annotations for Uint8Array
   byteArray shape` — add `(p: Uint8Array): 'byteArray'` overload to
   `PassStyleOf`; change ocapn branded byteArray types
   (`SessionId`, `SwissNum`, `PublicKeyId`) to `Uint8Array & {_brand}`;
   cascade `ArrayBufferLike` → `ArrayBufferView | ArrayBufferLike` on
   byteArray-shaped JSDoc parameters across ocapn src and tests; narrow
   `@returns {ArrayBufferLike}` to `@returns {Uint8Array}` where the
   body returns `bytesToImmutable(...)`.
8. `chore: changeset for byteArray narrowing` —
   `.changeset/narrow-bytearray-to-uint8.md` (major bumps for
   pass-style + bytes; patch bumps for patterns, marshal, ocapn).

## Files modified per package

- `@endo/pass-style`: `src/byteArray.js`, `src/types.d.ts`,
  `test/byteArray.test.js`, `tools/arb-passable.js`.
- `@endo/bytes`: `src/to-immutable.js`, `src/from-immutable.js`,
  `src/concat-immutables.js`, `test/main.test.js`, `README.md`.
- `@endo/marshal`: `src/rankOrder.js`.
- `@endo/patterns`: `src/patterns/patternMatchers.js`,
  `src/type-from-pattern.ts`, `test/pattern-limits.test.js`,
  `test/types.test-d.ts`.
- `@endo/ocapn`: `src/syrup/encode.js`, `src/syrup/codec.js`,
  `src/syrup/js-representation.js`, `src/syrup/compare.js`,
  `src/syrup/decode.js`, `src/codecs/components.js`,
  `src/codecs/descriptors.js`, `src/cryptography.js`,
  `src/netlayers/websocket.js`, `src/client/types.js`,
  `src/client/ocapn.js`, `src/client/util.js`,
  `test/codecs/_syrup_util.js`, `test/codecs/operations.test.js`,
  `test/syrup/reader.test.js`.
- Root `.changeset/narrow-bytearray-to-uint8.md`.

## Test results

- `yarn workspace @endo/pass-style test` — 37 tests passed across
  three lockdown configs.
- `yarn workspace @endo/bytes test` — 32 tests passed.
- `yarn workspace @endo/patterns test` — 610 tests passed.
- `yarn workspace @endo/marshal test` — 78 tests passed, 1 skipped.
- `yarn workspace @endo/ocapn test` — 260 tests passed.
- Lint clean on pass-style, bytes, patterns, marshal, ocapn, exo, far,
  goblin-chat.
- Pre-push gates pass (only the pre-existing
  `chacha12-fast-check-test` finding remains, unrelated to this PR).

## Posted top-level summary comment

https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4748691341
@-mentions @erights and @kriskowal; per-action authorization was in
the dispatch prompt.

Self-improvement: when a dispatch's task plan says "branch from
master" but the work narrows a brand check whose broadening arm lives
on an open PR's branch (here #473), the right move is to base the new
PR off the open PR's branch, not master. Naive master-base would
either drop the new acceptance shape from the brand check (broken) or
require duplicating the broadening commits before the narrowing
(wasteful and merge-conflict-prone). Stack on the dep PR and target
its head as the new PR's base. Nothing to add to a skill; the case
showed up in the dispatch prompt's wording, and the right response was
to verify the assumption against the actual dep state (`gh pr view
473`) before opening.

next: liaison (DRAFT awaits kriskowal opinion per erights).
