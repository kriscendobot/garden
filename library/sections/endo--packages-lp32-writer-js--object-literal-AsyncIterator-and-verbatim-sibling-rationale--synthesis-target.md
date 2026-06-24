---
title: Synthesis-target
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
