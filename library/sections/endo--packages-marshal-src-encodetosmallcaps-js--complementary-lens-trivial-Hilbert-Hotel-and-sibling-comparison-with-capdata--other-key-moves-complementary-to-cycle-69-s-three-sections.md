---
title: Other key moves (complementary to cycle 69's three sections)
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

- **§the-named-bigint-sign-via-plus-vs-minus-prefix** (line 208-211) — `+0n` encodes as `'+0'`; `-1n` encodes as `'-1'`. The sign is *in the prefix*, not in the digits. Capdata (cycle 328) put `digits: String(passable)` in a `digits` named property and lost the sign-as-prefix advantage. **§the-named-sign-in-prefix-not-in-digits**. First-explicit-observation.

- **§the-named-tag-pseudo-property** (line 236-241) — `'#tag': ...` for the tagged-pass-style encoding. The `#` prefix appears in *two* roles in smallcaps: (1) manifest-constant values like `#NaN`; (2) discriminator property names like `#tag` and `#error`. **§the-named-property-name-discriminator-prefix-discipline** — first-explicit-observation.

- **§the-named-startsSpecial-via-charCodeAt-comparison** (line 78-86) — `BANG <= code && code <= DASH` for the range check on first character. The comment notes *"charCodeAt(0) and number compare is a bit faster"* than string comparison. **§the-named-charCodeAt-performance-discipline** — first-explicit-observation.

- **§the-named-yoda-condition-disabled-deliberately** (line 84) — `// eslint-disable-next-line yoda` — the BANG-first comparison is structurally a *range check*, not a yoda condition; the eslint rule misfires because the constant is on the left. First-explicit-observation. Sibling to cycle 324's line-level eslint-disable discipline (for no-bitwise).

- **§the-named-three-distinct-return-type-checks** (line 243-251, 253-261, 263-265) — each encoder's result is asserted to start with the specific discriminator: `$` for remotable, `&` for promise, `#error` for error. **§the-named-encoder-contract-via-output-prefix-check** — first-explicit-observation. The encoder *must* produce a specific shape; the wrapper validates.

- **§the-named-compact-encoding-as-design-priority** — closes citation arc with cycle 329 README's side-by-side comparison. Smallcaps `#NaN` (5 bytes) vs capdata `{"@qclass":"NaN"}` (17 bytes) — 3x compression on common edge cases. First-explicit-observation.
