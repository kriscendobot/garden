---
title: Tier-3 borrowing (meta-patterns)
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

- **§the-named-Hilbert-Hotel-encoding** as a *parameterized* meta-pattern with **three distinct cost-profiles** (cycle 148 double-prefix; cycle 328 object-wrap; cycle 330 one-byte trivial-when-prefix-is-in-special-range)
- **§the-named-sort-order-preserving-encoding-discipline** — when the encoding will be used for ordered comparisons (rank-ordering, sort-keys), the encoding must preserve sort order; the contiguous-range-prefix trick achieves this with one-byte cost
- **§the-named-character-range-as-extensibility-zone** — reserve a *contiguous* range of characters for future discriminators; the contiguousness preserves sort properties
- **§the-named-format-discriminator-collision-shifted-to-string-not-object** — capdata shifts collision-handling to the object level; smallcaps shifts to the string level; the choice affects sort-order preservation and compactness
- **§the-named-sibling-file-shape-shared** — sibling files (capdata + smallcaps) share *almost everything* except the output format; the shape-shared structure is itself a reusable pattern (the format is a parameter)
