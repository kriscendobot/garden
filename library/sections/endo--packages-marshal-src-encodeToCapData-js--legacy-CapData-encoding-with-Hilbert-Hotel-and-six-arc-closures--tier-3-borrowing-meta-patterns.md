---
title: Tier-3 borrowing (meta-patterns)
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

- **§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique** — when a reserved-discriminator collides with a natural value, shift everything by one level of indirection (the same technique repeated in cycle 148 symbol-names and cycle 328 QCLASS)
- **§the-named-CapData-vs-smallcaps-format-evolution** with **§the-named-legacy-format-still-supported-discipline** — newer formats coexist with older ones; protocols are permanent once shipped
- **§the-named-protocol-contract-IS-named-permanent-once-shipped** — sibling to cycle 326's @deprecated-but-still-working; this is not-even-deprecated, just coexisting
- **§the-named-canonical-encoding-needed-for-equality** — when cross-vat equality matters, encoding must be deterministic; sorted property names are the canonical technique
- **§the-named-default-rejector-forces-explicit-opt-in** — three default-throwing encoders make pass-by-presence-handling explicit at the call site
- **§the-named-diagnostic-priority-over-strictness-at-root** — accept invalid Passables at the root (errors) for diagnostic purposes; reject them in the recursion
