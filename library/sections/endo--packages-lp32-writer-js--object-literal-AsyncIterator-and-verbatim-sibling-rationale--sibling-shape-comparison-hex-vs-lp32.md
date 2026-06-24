---
title: "Sibling shape comparison: hex vs lp32"
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

The lp32 reader/writer share *less* than the hex encode/decode did. The hex pair shared file-level eslint-disable + harden import + Reflect.apply destructure + cast-to-any + typeof-function check + typeof type-inheritance + two-harden-calls. The lp32 pair shares only: harden + Fail/q imports + hostIsLittleEndian import + the verbatim top-of-file comment + the two-views-one-buffer idiom + the explicit-endianness pattern + the name-as-error-attribution pattern.

**§the-named-sibling-shape-shared-IS-named-bounded-by-domain-complexity** — siblings share what their domains let them share. Hex encode/decode are *almost* identical because both directions are nearly symmetric arithmetic (encode: byte → two hex chars; decode: two hex chars → byte). lp32 reader/writer share less because their directions have fundamentally different complexity:

- **Reader** (cycle 316): unknown message size; needs growable buffer; geometric growth + DataView rebuild; outer-chunk-loop + inner-drain-loop; yield-a-copy-not-a-view for concurrent reads; absolute-offset tracking for diagnostics.
- **Writer** (cycle 320): known message size up front (`message.byteLength`); exact allocation (`new Uint8Array(4 + message.byteLength)`); single frame-emit; no buffer; no drain; no concurrent-read concerns.

**§the-named-reader-uncertain-writer-certain-asymmetry** — read direction faces uncertainty (any number of bytes might arrive in any chunking); write direction has certainty (caller hands the writer a complete message). The asymmetry is the *cause* of the implementation divergence. First-explicit-observation.
