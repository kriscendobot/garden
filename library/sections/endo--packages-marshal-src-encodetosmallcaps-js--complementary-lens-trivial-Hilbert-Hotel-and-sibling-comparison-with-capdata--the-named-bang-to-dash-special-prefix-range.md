---
title: §the-named-BANG-to-DASH-special-prefix-range
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

ASCII codes 33 (`!`) to 45 (`-`) form a 13-character contiguous range reserved as the special-prefix zone:

```
!"#$%&'()*+,-
33                            45
```

Of these 13 reserved characters, **seven** are currently assigned to specific roles:

| Prefix | Role | Example |
|---|---|---|
| `!` | escaped string | `!#NaN` (a string literally `#NaN`) |
| `+` | non-negative bigint | `+0` for `0n` |
| `-` | negative bigint | `-1` for `-1n` |
| `#` | manifest constant or property-name prefix | `#NaN`, `#undefined`, `#tag`, `#error` |
| `%` | symbol | `%@@iterator` for `Symbol.iterator` |
| `$` | remotable | `$0` for slot 0 |
| `&` | promise | `&0` for slot 0 |

The remaining six (`"'()*,`) are reserved for future use. **§the-named-character-range-as-extensibility-zone** — first-explicit-observation. The 13-character window gives smallcaps headroom for *future* discriminators without breaking existing encodings.

**§the-named-seven-prefix-discriminator-set** — the seven currently-used prefixes; first-explicit-observation as a parameterized set.
