---
title: Synthesis-target
source: endo--packages-marshal-src-encodetosmallcaps-js
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToSmallcaps.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/marshal/src/encodeToSmallcaps.js
total-lines: 474
ingest-cycle: 330
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-trivial-Hilbert-Hotel-via-character-range
  - the-named-Hilbert-Hotel-IS-trivial-when-prefix-IS-in-the-special-range
  - the-named-sort-order-preserving-encoding-discipline
  - the-named-BANG-to-DASH-special-prefix-range
  - the-named-character-range-as-extensibility-zone
  - the-named-seven-prefix-discriminator-set
  - the-named-startsSpecial-via-charCodeAt-comparison
  - the-named-yoda-condition-disabled-deliberately
  - the-named-compact-encoding-as-design-priority
  - the-named-sibling-file-shape-shared-between-capdata-and-smallcaps
  - the-named-bigint-sign-via-plus-vs-minus-prefix
  - the-named-tag-pseudo-property
  - the-named-property-name-discriminator-prefix-discipline
  - the-named-three-distinct-return-type-checks
  - the-named-encoder-contract-via-output-prefix-check
  - the-named-format-discriminator-collision-shifted-to-string-not-object
  - the-named-verbatim-rationale-comment-across-sibling-files
  - the-named-complementary-lens-re-ingest
  - three-cycles-with-named-Hilbert-Hotel-encoding
  - three-cycles-with-named-complementary-lens-re-ingest
  - twenty-one-cycles-with-named-pivot-domain-stay
parent: endo--packages-marshal-src-encodetosmallcaps-js--complementary-lens-trivial-Hilbert-Hotel-and-sibling-comparison-with-capdata
---

Slot machine library **§`@game/marshal/src/encodeToWireFormat.js`** (mirror of cycle 328 synthesis-target):

1. **Contiguous character range as extensibility zone** — pick a range of 10-15 characters at low ASCII; reserve all of them; document which are used and which are reserved.
2. **Trivial Hilbert-Hotel via in-range prefix** — pick the escape prefix from within the special range itself (typically the lowest); strings starting with any special character get one more copy of the escape prefix.
3. **Sort-order preservation as design property** — if the encoding will be used for ordered comparison, document the sort-order-preservation property explicitly.
4. **Sign-via-prefix for signed numerics** — use `+` and `-` (or analogous) as discriminator prefixes for non-negative vs negative, rather than encoding the sign in the digits.
5. **Property-name-discriminator-prefix discipline** — if the encoding uses property names for discrimination, choose a prefix character that can't appear in natural property names; document the dual role (value-prefix vs property-name-prefix) if applicable.
6. **Encoder contract via output prefix check** — when calling user-supplied encoders, validate the output's prefix matches the expected discriminator; throw on mismatch.
7. **Sibling-file shape shared with capdata-equivalent** — if there are multiple wire-format variants, share the structure (Recur naming, dontEncode family, encodeRecur callback, exhaustive switch, error special case at root, byteArray TODO).
