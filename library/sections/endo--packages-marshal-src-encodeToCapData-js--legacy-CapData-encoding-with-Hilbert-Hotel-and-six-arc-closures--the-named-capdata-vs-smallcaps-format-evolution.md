---
title: §the-named-CapData-vs-smallcaps-format-evolution
source: endo--packages-marshal-src-encodeToCapData-js
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
ingest-cycle: 328
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique
  - the-named-QCLASS-special-property-name
  - the-named-canonical-encoding-via-sorted-property-names
  - the-named-canonical-encoding-needed-for-equality
  - the-named-three-encoder-options-with-default-rejectors
  - the-named-dontEncode-family-of-default-rejectors
  - the-named-encodeRecur-callback-parameter
  - the-named-switch-on-passStyleOf
  - the-named-special-case-NaN-Infinity-and-minus-Infinity
  - the-named-bigint-encoded-as-digits-string
  - the-named-symbol-encoded-via-passableSymbolForName
  - the-named-error-special-case-at-root-not-passable
  - the-named-Recur-name-suffix-for-recursive-helper
  - the-named-byteArray-TODO
  - the-named-CapData-vs-smallcaps-format-evolution
  - nineteen-cycles-with-named-pivot-domain-stay
  - eleven-named-packages-in-the-pivot-cluster
  - twenty-two-citation-arc-closures-in-pivot-now
  - six-citation-arc-closures-in-cycle-328
  - the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close
  - two-cycles-with-named-Hilbert-Hotel-encoding
  - four-cycles-with-named-Object-destructure
parent: endo--packages-marshal-src-encodeToCapData-js--legacy-CapData-encoding-with-Hilbert-Hotel-and-six-arc-closures
---

The file's existence alongside cycle 69's `encodeToSmallcaps.js` documents a **format-evolution narrative** in the @endo/marshal package:

- **CapData (this file, cycle 328)**: Legacy format. Each special value is wrapped in `{ '@qclass': '<discriminator>', ... }`. Verbose; every special value adds an object layer. Originally designed for compatibility with JSON-RPC-style wire formats.
- **Smallcaps (cycle 69)**: Newer format. Uses one-character prefixes (`!` for primitives, `+` for tagged, etc.) to mark special values inline within strings. Compact; doesn't require nested objects.

**§the-named-legacy-format-still-supported-discipline** — first-explicit-observation. The newer smallcaps format doesn't *replace* CapData; CapData is still maintained because existing serialized data uses it, and the format is part of the long-running protocol contract with downstream consumers (e.g., agoric-sdk). **§the-named-protocol-contract-IS-named-permanent-once-shipped**. First-explicit-observation. Sibling to cycle 326's **§the-named-deprecated-but-still-working** (which named soft-removal via @deprecated tag); this is *not-even-deprecated*, just *coexisting*.
