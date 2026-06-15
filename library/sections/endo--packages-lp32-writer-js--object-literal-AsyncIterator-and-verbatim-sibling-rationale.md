---
title: "@endo/lp32 writer.js — object-literal AsyncIterator; verbatim-duplicate sibling rationale; second three-file pivot cluster"
source: endo--packages-lp32-writer-js
url: https://github.com/endojs/endo/blob/master/packages/lp32/writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/lp32/writer.js
total-lines: 49
ingest-cycle: 320
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-verbatim-comment-across-sibling-files
  - the-named-two-choices-for-sibling-rationale-coordination
  - the-named-self-reference-via-lexical-binding-not-this
  - the-named-Symbol.asyncIterator-returns-self
  - the-named-writer-via-harden-object-literal
  - the-named-AsyncIterator-protocol-via-object-literal
  - the-named-second-three-file-cluster-of-the-pivot
  - the-named-sibling-shape-shared-IS-named-bounded-by-domain-complexity
  - the-named-reader-uncertain-writer-certain-asymmetry
  - the-named-pre-allocate-frame-buffer
  - the-named-undefined-vs-void-distinction
  - the-named-asymmetric-type-parameters-between-reader-and-writer
  - the-named-throw-delegates-to-output
  - the-named-wrap-don't-catch-discipline
  - the-named-setUint32-getUint32-symmetric-pair
  - the-named-options-only-two-not-three
  - the-named-name-default-IS-named-unknown-lp32-writer-bracketed
  - three-cycles-with-named-host-byte-order-via-explicit-endianness-argument
  - three-cycles-with-named-message-includes-named-stream-name
  - eleven-cycles-with-named-pivot-domain-stay
  - nine-cycles-with-named-Hardened-JS-discipline
---

# `@endo/lp32 writer.js` — object-literal AsyncIterator; verbatim sibling rationale; second three-file pivot cluster

The 49-line writer.js completes the **second three-file pivot cluster** with cycle 315 (@endo/lp32 README) and cycle 316 (@endo/lp32 reader.js). Cycle 320 is **chat-lane after cycle 319's designs-lane @endo/stream README**. **Eleventh consecutive non-garden source after the pivot** (cycles 310-320). **§eleven-cycles-with-named-pivot-domain-stay**. **Fifth package extends, not adds** (lp32 already in cluster).

## The single most structurally interesting move

**§the-named-verbatim-comment-across-sibling-files** — the file-top rationale comment is *identical word-for-word* with cycle 316's @endo/lp32/reader.js:

```js
// DataView does not default to host byte order like TypedArrays, so we must
// pass an explicit endianness argument.
```

This is the **explicit alternative** to cycle 318's @endo/hex/src/decode.js discipline of `// See encodeHex for the rationale`. Two choices for sibling-rationale coordination:

**§the-named-two-choices-for-sibling-rationale-coordination** — first-explicit-observation in library as a parameterized discipline:

| Choice | Discipline | Pros | Cons |
|---|---|---|---|
| **Cite-the-sibling** (cycle 318 hex decode) | `// See encodeHex for the rationale` | DRY; one source of truth | Extra navigation when reading in isolation |
| **Verbatim-duplicate** (cycle 320 lp32 writer) | Same two lines, word-for-word | Self-contained; no navigation | Rationale can drift if updated in only one place |

The choice depends on whether sibling files are likely to be read in isolation (favor verbatim) or together (favor cite). The two pivot clusters made *different* choices for the same problem. §the-named-hex-cluster-cites-and-lp32-cluster-duplicates. The trade-off is named at the meta level: **§the-named-DRY-vs-self-contained-tension-in-sibling-files**.

## Sibling shape comparison: hex vs lp32

The lp32 reader/writer share *less* than the hex encode/decode did. The hex pair shared file-level eslint-disable + harden import + Reflect.apply destructure + cast-to-any + typeof-function check + typeof type-inheritance + two-harden-calls. The lp32 pair shares only: harden + Fail/q imports + hostIsLittleEndian import + the verbatim top-of-file comment + the two-views-one-buffer idiom + the explicit-endianness pattern + the name-as-error-attribution pattern.

**§the-named-sibling-shape-shared-IS-named-bounded-by-domain-complexity** — siblings share what their domains let them share. Hex encode/decode are *almost* identical because both directions are nearly symmetric arithmetic (encode: byte → two hex chars; decode: two hex chars → byte). lp32 reader/writer share less because their directions have fundamentally different complexity:

- **Reader** (cycle 316): unknown message size; needs growable buffer; geometric growth + DataView rebuild; outer-chunk-loop + inner-drain-loop; yield-a-copy-not-a-view for concurrent reads; absolute-offset tracking for diagnostics.
- **Writer** (cycle 320): known message size up front (`message.byteLength`); exact allocation (`new Uint8Array(4 + message.byteLength)`); single frame-emit; no buffer; no drain; no concurrent-read concerns.

**§the-named-reader-uncertain-writer-certain-asymmetry** — read direction faces uncertainty (any number of bytes might arrive in any chunking); write direction has certainty (caller hands the writer a complete message). The asymmetry is the *cause* of the implementation divergence. First-explicit-observation.

## Other key moves

- **§the-named-writer-via-harden-object-literal** (line 23-46) — the writer is constructed by `harden({...})` directly, with `next` / `return` / `throw` / `[Symbol.asyncIterator]` methods. Contrast cycle 316's reader, which used a private `async function*` generator + public thin wrapper. The writer is one layer; the reader was two. **§the-named-writer-doesn't-need-the-two-layer-shape** — because the writer is an object literal, not a generator, the two-layer pattern doesn't apply. First-explicit-observation.

- **§the-named-AsyncIterator-protocol-via-object-literal** — the writer implements the full async iterator protocol *by hand*: `next(message)` accepts the payload; `return()` closes; `throw(error)` propagates; `[Symbol.asyncIterator]()` returns self. §the-named-manual-protocol-implementation; §the-named-no-generator-needed-discipline. First-explicit-observation.

- **§the-named-Symbol.asyncIterator-returns-self** (line 43-45) — `[Symbol.asyncIterator]() { return writer; }`. The iterator returns *itself*. This is the canonical idiom for **§the-named-iterable-and-iterator-are-the-same-object** discipline. Compare to a fresh-iterator-per-call (e.g., arrays return a new iterator each time `[Symbol.iterator]()` is called); here, calling it twice gives the *same* iterator, which means iteration is single-pass and stateful. First-explicit-observation.

- **§the-named-self-reference-via-lexical-binding-not-this** (line 23, 44) — the `[Symbol.asyncIterator]()` method references the *lexical* binding `writer` (the outer `const`), **not** `this`. Why? Because if the method were detached (`const it = writer[Symbol.asyncIterator]; it()`), `this` would be undefined and the return value would be undefined. Using lexical `writer` works regardless of how the method is called. §the-named-detach-safe-via-lexical-capture; §the-named-arrow-function-or-lexical-capture-for-detach-safety. The lexical binding is *initialized after* the object literal is constructed and hardened — JS closure semantics make this work because the method is called later, not during construction. **§the-named-closure-captures-binding-not-value** (JS-language fact; appears here for the second time in the pivot cluster after cycle 316). First-explicit-observation.

- **§the-named-options-only-two-not-three** — writer has *two* options (`name` + `maxMessageLength`); reader had *three* (`name` + `initialCapacity` + `maxMessageLength`). The writer doesn't need `initialCapacity` because each frame is allocated exactly at write time. §the-named-options-asymmetric-by-direction; first-explicit-observation.

- **§the-named-name-default-IS-named-unknown-lp32-writer-bracketed** (line 19) — `name = '<unknown-lp32-writer>'`. Reader had `'<unknown>'`. The writer's default is *more specific* (includes "lp32-writer"). §the-named-asymmetric-naming-defaults; §the-named-writer-self-identifies-more-than-reader-discipline. First-explicit-observation.

- **§the-named-max-message-length-check-first** (line 26-29) — validation BEFORE the frame allocation. Same `Fail`-via-`q`-tagged-template idiom as cycle 316 reader. §three-cycles-with-named-message-includes-named-stream-name (315 README named the promise; 316 reader implemented; 320 writer implements again).

- **§the-named-pre-allocate-frame-buffer** (line 30) — `new Uint8Array(4 + message.byteLength)` — exact size. **§the-named-known-size-IS-named-exact-allocation**; §the-named-no-resize-loop-needed; §the-named-writer-knows-message-size-up-front-discipline. First-explicit-observation.

- **§the-named-setUint32-getUint32-symmetric-pair** (line 32) — `data.setUint32(0, message.byteLength, hostIsLittleEndian)` is the *write complement* to cycle 316's `data.getUint32(0, hostIsLittleEndian)`. The third argument is the explicit endianness in both directions. **§three-cycles-with-named-host-byte-order-via-explicit-endianness-argument** (315 README rationale + 316 reader getUint32 + 320 writer setUint32). First-explicit-observation as a named symmetric pair.

- **§the-named-set-after-prefix** (line 33) — `array8.set(message, 4)` — payload starts at byte offset 4 (after the prefix). §the-named-payload-after-prefix-offset.

- **§the-named-output-as-cross-package-Writer-type** (line 10) — `@param {import('@endo/stream').Writer<Uint8Array, undefined>}`. The lp32 writer composes with an arbitrary @endo/stream Writer. §the-named-Writer-IS-named-stream-package-protocol-shape (mirrors cycle 316's §the-named-Reader-IS-named-stream-package-protocol-shape). The cross-package citation arc with cycle 319's @endo/stream README extends here: cycle 319 is the README; cycle 316 + 320 are the implementations that consume the @endo/stream protocol.

- **§the-named-undefined-vs-void-distinction** (line 10) — `@returns {import('@endo/stream').Writer<Uint8Array, undefined>}` — note `undefined`, not `void`. Reader had `<Uint8Array, void>`. **§the-named-undefined-IS-named-value-void-IS-named-non-value**: `undefined` is the resolved-value of the writer's `.return()`; `void` is the (absent) return value of the reader's exhaustion. §the-named-asymmetric-type-parameters-between-reader-and-writer; §the-named-writer-resolves-to-undefined-reader-returns-void. First-explicit-observation.

- **§the-named-throw-delegates-to-output** (line 40-42) — `throw(error) { return output.throw(error); }`. Errors propagate through the wrapper to the inner writer; the lp32 writer doesn't *handle* errors. **§the-named-wrap-don't-catch-discipline**; **§the-named-error-passes-through-the-frame**. First-explicit-observation.

- **§the-named-return-delegates-to-output-with-undefined** (line 36-38) — `return() { return output.return(undefined); }`. Close passes through with explicit undefined argument; §the-named-explicit-undefined-on-close-of-inner-writer; §the-named-close-IS-named-deliberate-not-implicit.

- **§the-named-shared-buffer-between-Uint8Array-and-DataView** (line 30-31) — `new Uint8Array(4 + message.byteLength)` then `new DataView(array8.buffer)`. §two-cycles-with-named-shared-buffer-between-Uint8Array-and-DataView (316 + 320). §the-named-two-views-one-buffer pattern repeats with the *write* operation (setUint32) instead of the read.

- **§the-named-second-three-file-cluster-of-the-pivot** — cycles 315 + 316 + 320 form the second three-file cluster (after hex 314 + 317 + 318). §the-named-three-file-cluster-doc-impl-sibling-arc shape extends from hex to lp32. **§two-three-file-clusters-now-in-pivot**.

## Patterns the cycle extends

- §eleven-cycles-with-named-pivot-domain-stay (310 + 311 + 312 + 313 + 314 + 315 + 316 + 317 + 318 + 319 + 320)
- §two-three-file-clusters-now-in-pivot (hex 314+317+318; lp32 315+316+320)
- §nine-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317 + 318 + 319 + 320)
- §three-cycles-with-named-host-byte-order-via-explicit-endianness-argument (315 + 316 + 320)
- §three-cycles-with-named-message-includes-named-stream-name (315 + 316 + 320)
- §two-cycles-with-named-shared-buffer-between-Uint8Array-and-DataView (316 + 320)
- §two-cycles-with-named-Fail-via-q-tagged-template-literal (316 + 320)
- §two-cycles-with-named-closure-captures-binding-not-value-JS-fact (316 + 320; though the reader's was implicit in the two-layer factory's generator, and the writer's is explicit in `[Symbol.asyncIterator]() { return writer; }`)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability observations:

- The **two-choices-for-sibling-rationale-coordination** as a parameterized discipline (cite vs verbatim)
- The **self-reference-via-lexical-binding-not-this** for detach-safe iterator methods
- The **sibling-shape-shared-IS-named-bounded-by-domain-complexity** as a transferable meta-observation
- The **undefined-vs-void-distinction** at the type-parameter level
- The **wrap-don't-catch-discipline** for layered iterator/writer wrappers

## Tier-2 borrowing (multi-cycle patterns extended)

- §eleven-cycles-with-named-pivot-domain-stay
- §two-three-file-clusters-now-in-pivot (hex + lp32)
- §nine-cycles-with-named-Hardened-JS-discipline
- §three-cycles-with-named-host-byte-order-via-explicit-endianness-argument
- §three-cycles-with-named-message-includes-named-stream-name
- §two-cycles-with-named-Fail-via-q-tagged-template-literal

## Tier-3 borrowing (meta-patterns)

- **§the-named-two-choices-for-sibling-rationale-coordination** — DRY-vs-self-contained tension parameterized at the meta level
- **§the-named-sibling-shape-shared-IS-named-bounded-by-domain-complexity** — what siblings share is what their domains let them share
- **§the-named-reader-uncertain-writer-certain-asymmetry** — read direction faces uncertainty (chunking); write direction has certainty (caller hands the complete message); the asymmetry causes implementation divergence
- **§the-named-self-reference-via-lexical-binding-not-this** — detach-safe iterator-self-reference idiom
- **§the-named-wrap-don't-catch-discipline** — layered wrappers propagate errors; only the bottom-most handler catches
- **§the-named-undefined-vs-void-distinction** — type-parameter-level distinction between *value* and *non-value*

## Synthesis-target

Slot machine library **§`@game/streaming/src/writer.js`** — message-stream writer (mirror of cycle 316 synthesis-target reader.js):

1. Verbatim-duplicate or cite-the-sibling for any shared rationale comment; pick the discipline based on whether files are read in isolation.
2. Object-literal AsyncIterator (`next` + `return` + `throw` + `[Symbol.asyncIterator]`); harden the object; don't use a generator if no internal state needs to persist across messages.
3. `[Symbol.asyncIterator]() { return writer; }` — iterator is itself; iteration is single-pass and stateful.
4. Self-reference via lexical binding (the outer `const writer`), not `this` — detach-safe.
5. Two options for the writer (name + maxMessageLength); no initialCapacity needed because writes are exact-sized.
6. Writer's `name` default is more specific than reader's (e.g., `'<unknown-game-stream-writer>'`).
7. Cheap validation BEFORE allocation (length check).
8. Exact frame allocation (`new Uint8Array(prefix-size + payload.byteLength)`).
9. setUint32 with explicit endianness — symmetric to reader's getUint32.
10. Payload after prefix offset (`array8.set(payload, prefix-size)`).
11. Throw delegates to inner output; wrap-don't-catch discipline.
12. Return delegates with explicit undefined; close is deliberate, not implicit.
13. Cross-package Writer type with `<Payload, undefined>` (writer resolves to undefined) vs reader's `<Payload, void>` (reader exhausts to void).
14. If reader and writer siblings share less than expected, ask whether the domain complexity is asymmetric (read = uncertain chunking; write = certain framing).
