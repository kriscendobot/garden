---
title: Other key moves
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
parent: endo--packages-lp32-writer-js--object-literal-AsyncIterator-and-verbatim-sibling-rationale
---

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
