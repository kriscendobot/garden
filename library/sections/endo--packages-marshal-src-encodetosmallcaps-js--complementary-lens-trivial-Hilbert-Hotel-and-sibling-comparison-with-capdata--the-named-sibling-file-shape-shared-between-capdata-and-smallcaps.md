---
title: §the-named-sibling-file-shape-shared-between-capdata-and-smallcaps
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

Cycle 328 encodeToCapData.js and cycle 330 encodeToSmallcaps.js share extensive structure:

| Pattern | capdata (cycle 328) | smallcaps (cycle 330) |
|---|---|---|
| **Recur suffix naming** | `encodeToCapDataRecur` interior + `encodeToCapData` entry point | `encodeToSmallcapsRecur` interior + `encodeToSmallcaps` entry point |
| **Three dontEncode default rejectors** | `dontEncodeRemotableToCapData` + `dontEncodePromiseToCapData` + `dontEncodeErrorToCapData` | `dontEncodeRemotableToSmallcaps` + `dontEncodePromiseToSmallcaps` + `dontEncodeErrorToSmallcaps` |
| **encodeRecur callback parameter** | `(value, encodeToCapDataRecur) => Encoding` | `(value, encodeToSmallcapsRecur) => SmallcapsEncoding` |
| **Exhaustive switch on passStyleOf** | 11 cases + default | 11 cases + default |
| **Error special case at root** | `if (isErrorLike(passable))` at top-level | Same |
| **byteArray TODO** | `throw Fail\`marsal of byteArray not yet implemented\`` | `throw Fail\`marsal of byteArray not yet implemented\`` (same typo: *"marsal"* — sibling-file shared bug?) |
| **Verbatim rationale comment** | `// This module is based on the encodePassable.js in @agoric/store` | **Same comment, same wording** |
| **Hilbert-Hotel encoding** | Yes (for QCLASS collision in copyRecord) | Yes (for `!`-prefix in string) |

**§the-named-sibling-file-shape-shared-between-capdata-and-smallcaps** — first-explicit-observation. The two files share *almost everything* except the *output format*: capdata produces nested `{ '@qclass': ..., ... }` objects; smallcaps produces prefixed strings.

**§the-named-verbatim-rationale-comment-across-sibling-files** (already named in cycle 320 lp32 reader/writer for the DataView byte-order rationale) — recurs here for the encodePassable-genesis rationale. **§three-cycles-with-named-verbatim-comment-across-sibling-files**? Actually no, cycle 320 was about *one* file (lp32 reader) and cycle 330 is *between* two files (capdata + smallcaps). Different application of the same discipline. **§three-cycles-with-named-verbatim-rationale-comment-across-sibling-files** (cycle 320 lp32 reader/writer + cycle 322 within exo-tools + cycle 330 capdata/smallcaps — well, only verifying for cycle 320 + cycle 330 here; 322 used cite-the-sibling instead. So §two-cycles-with-named-verbatim-comment-across-sibling-files).

**§the-named-format-discriminator-collision-shifted-to-string-not-object** — smallcaps shifts the discriminator from the *object-level* (capdata's `@qclass` property) to the *string-level* (smallcaps's prefix character). The string-vs-object distinction is structurally significant:
- Object-level discriminators require nested structure but allow named properties
- String-level discriminators preserve string-position (sort order!) and are more compact but require fixed-character vocabulary
