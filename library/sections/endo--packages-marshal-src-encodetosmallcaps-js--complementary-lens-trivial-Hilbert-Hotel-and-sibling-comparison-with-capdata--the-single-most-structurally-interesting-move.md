---
title: The single most structurally interesting move
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

**§the-named-trivial-Hilbert-Hotel-via-character-range** — the string-escape case (line 182-189) is documented in the source comment as *trivially* applying the Hilbert-Hotel:

```js
case 'string': {
  if (startsSpecial(passable)) {
    // Strings that start with a special char are quoted with `!`.
    // Since `!` is itself a special character, this trivially does
    // the Hilbert hotel. Also, since the special characters are
    // a continuous subrange of ascii, this quoting is sort-order
    // preserving.
    return `!${passable}`;
  }
  // All other strings pass through to JSON
  return passable;
}
```

This is the **third instance** of the Hilbert-Hotel encoding technique in the library (after cycle 148 symbol-name escaping and cycle 328 QCLASS collision-handling). What makes the smallcaps application *trivial* vs the others:

| Hilbert-Hotel instance | How it works | Cost |
|---|---|---|
| Cycle 148 symbol.js (`@@`-prefix) | Double-`@@` for registered symbol names that collide with well-known | One extra `@@` prefix per collision |
| Cycle 328 capdata (`@qclass`) | Wrap in `{ [QCLASS]: 'hilbert', original, rest }` | One extra object layer per collision |
| **Cycle 330 smallcaps (`!`-prefix)** | **`!` prepended to any string starting with a special char** | **One byte per collision** |

The smallcaps version is *trivial* because the discriminator (`!`) is itself *in* the special-character range — no separate escape mechanism needed; just re-apply the same prefix. **§the-named-Hilbert-Hotel-IS-trivial-when-prefix-IS-in-the-special-range** — first-explicit-observation as a tier-3 transferable technique.

But the smallcaps Hilbert-Hotel also *earns an additional property* that neither of the other two provided:

**§the-named-sort-order-preserving-encoding-discipline** — the source comment says *"since the special characters are a continuous subrange of ascii, this quoting is sort-order preserving."* The encoded form preserves the same sort order as the natural form. **§the-named-sort-order-preservation-as-encoding-property** — first-explicit-observation. This is load-bearing because smallcaps strings end up in encodings used for *rank-ordered comparisons* (cycle 81 encodePassable.js — closes citation arc).

The sort-order-preservation comes from two combined properties: (1) the special characters form a *contiguous* ASCII range (33-45); (2) the chosen escape prefix (`!`, ASCII 33) is the *minimum* of that range. Together they ensure that `!`+anything sorts before any character ≥ ASCII 33 that isn't escaped, and `!`+`!`+anything sorts before `!`+anything that isn't escaped. The escape acts like a sort-stable prefix.
