---
id: rank-order-preserving-encoding
aliases: ["rank-order encoding", "rank order encoding", "rank-order preserving encoding", "sort-preserving encoding", "lexicographic order matches numeric order", "lexicographic byte order matches sort order", "encodePassable", "`encodePassable`", "`makePassableKit`", "compactOrdered", "legacyOrdered", "compactOrdered format", "legacyOrdered format", "rankOrder", "rank-order", "passStylePrefixes", "`passStylePrefixes`", "ordinal-mapping prefix", "bit-complement for sort order", "Elias delta encoding", "sign-aware alphabets", "ten's complement digit encoding", "sameValueZero", "compareNumerics", "ENDO_RANK_STRINGS", "passStyleRanks", "getPassStyleCover", "RankCover", "makeComparatorKit", "makeFullOrderComparatorKit", "compareRank", "sortByRank", "isRankSorted", "shortlex", "subset ranks earlier", "prefix ranks earlier", "deep-tied remotables", "Array.prototype.sort undefined quirk"]
topics: [marshal, pass-style]
---

# rank-order-preserving-encoding

The discipline in `@endo/marshal` of decoupling **two coordinated
forms of one ordering**: a *bytes-on-the-wire* form
(`encodePassable.js`) that maps each Passable to a byte string
whose lexicographic comparison matches the rank-order verdict on
the original values, and an *in-memory comparator and sort*
form (`rankOrder.js`) that takes any two Passables and decides
their relative position directly. The two share the canonical
`passStylePrefixes` table — `encodePassable.js` exports it and
`rankOrder.js` imports it — so the bytes-form and the
comparator-form agree by construction on which PassStyle
sorts above which. The encoding side is the substrate for the
keyed-store substrate that backs `CopyMap`, `CopySet`, and
`CopyBag` (the rank-order property is what lets the store use
lexicographic indexes like LMDB key order directly without
re-parsing keys); the comparator side is what runs *inside*
collection operations and what powers `sortByRank` for any
in-memory rank-ordered array. The encoding side rests on five
implementation techniques (sign-aware bit-complement on IEEE-754
doubles; Elias-delta with sign-aware unary alphabets and ten's-
complement digits for bigints; contiguous-range character escapes
that preserve byte-order on strings; dual array encodings for
legacyOrdered vs compactOrdered; and the canonical
`passStylePrefixes` table whose source-order is the inter-
PassStyle rank-order). The comparator side rests on five
in-memory decisions (the `sameValueZero` rank-tie predicate; the
NaN-last-and-self-equal `compareNumerics` rule; the per-PassStyle
case rules including copyRecord's subset-ranks-earlier via
inverse-sorted-names, copyArray's prefix-ranks-earlier, and
byteArray's shortlex; the `sortByRank` manual fixup for
`Array.prototype.sort`'s `undefined`-at-end quirk under the
reverse comparator, linked to the `passStylePrefixes` MUST-NOT-
sort-after-`undefined` invariant; and `makeFullOrderComparatorKit`'s
strict refinement that assigns remotables an ordinal on first
encounter, with a canonical `BEWARE` clause on observable mutable
state). Errors are extracted from both regimes via a root-level
special case rooted in the diagnostic-priority rule (errors that
fail Passable validation must still encode for diagnostic
readability). The ordinal-mapping prefix `|` is reserved outside
the cover range so remotable-to-ordinal mappings sort above every
value key in the keyed store.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [number-encoding-binary64-bit-complement](../sections/endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement.md) | The sign-aware bit-complement that maps IEEE-754 doubles to a 16-hex-digit string whose lexicographic order matches numeric order; lockdown-independent NaN canonicalization with a WebIDL-shaped canonical NaN constant. |
| [bigint-encoding-elias-delta-with-sign-aware-alphabets](../sections/endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets.md) | Elias-delta encoding of bigints with `#`/`~` sign-aware unary alphabets and ten's-complement digit encoding so positive and negative bigints of arbitrary magnitude sort in their natural numeric order. |
| [compact-format-string-escapes](../sections/endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes.md) | The `compactOrdered` format's `!`-prefix escape table that maps `[0x00..0x21]` to `[0x21..0x40]` while preserving lexicographic order; the `^`/`_` array-marker patch; the legacyOrdered identity passthrough. |
| [dual-array-encodings-and-double-decode-verify](../sections/endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify.md) | The legacyOrdered NUL-terminator + SOH-escape and compactOrdered space-terminator + pre-escaped-string array encodings; the embeddability-verifying double-decode check on user-provided remotable / promise / error encoders. |
| [error-special-case-and-passstyle-prefix-table](../sections/endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) | The `isErrorLike` root-level special case (diagnostic priority over Passable validation) and the canonical `passStylePrefixes` table whose ordering coordinates per-PassStyle sort order with the cover machinery; the `|` ordinal-mapping prefix reserved outside the cover range. |
| [same-value-zero-and-numeric-rank-semantics](../sections/endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics.md) | The in-memory rank-order regime's three opening decisions: `sameValueZero` as the rank-tie predicate (`NaN === NaN`, `-0 === +0`); `compareNumerics` placing NaN last and self-equal and tying +0/-0; the `ENDO_RANK_STRINGS` env-option's three string-comparison modes (UTF-16 code-unit default, Unicode code-point, error-if-order-choice-matters diagnostic). |
| [pass-style-rank-derivation-and-rank-covers](../sections/endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers.md) | How `passStyleRanks` is derived from `passStylePrefixes` (sort by prefix, assign index, compute half-open cover); the BMP / printable-ASCII assumption on prefix characters; the multi-character-prefix sortedness assertion; the `getPassStyleCover` overestimate disclaimer (no smallest/biggest bigint forces the bigint cover into adjacent style ranges, callers filter). |
| [inner-comparator-per-pass-style-rules](../sections/endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md) | The per-PassStyle rank rules for all 14 styles: tied-for-rank for undefined / null / error / promise; trivial less-than for boolean / bigint; symbol-by-name-string; per-style numeric for number; copyRecord's lexicographic-inverse-sorted-property-names that produces subset-ranks-earlier; copyArray's lexicographic-with-prefix-ranks-earlier; byteArray's shortlex with the @endo/immutable-arraybuffer shim workaround; tagged's tag-then-payload; and the NaN-default-compareRemotables that produces deep-tied pairs like `[r1, 0]` and `[r2, "x"]`. |
| [sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant](../sections/endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant.md) | Why `sortByRank` manually moves `undefined` from end to start under a reverse comparator (Array.prototype.sort places undefined at end regardless of comparator); the linked invariant `passStylePrefixes` MUST NOT sort any category after `undefined`; the WeakMap-keyed-by-comparator memoization pattern; the harden-then-sort-then-harden discipline. |
| [full-order-comparator-kit-observable-mutable-state](../sections/endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state.md) | `makeFullOrderComparatorKit` is the strict alternative to NaN-default rank order: assigns remotables an ordinal on first encounter; strictly refines rank order; canonical BEWARE clause on observable mutable state and the covert-channel hazard of sharing the kit across distrusting subsystems; scalars-cross-fresh-comparators invariant; no-store-ordering caveat; longLived parameter's WeakMap vs Map trade-off. |

## See also

- [[smallcaps-encoding]] — the sister wire format under `packages/marshal/src/encodeToSmallcaps.js`; smallcaps targets *JSON-shape* (round-trip through `JSON.stringify`/`JSON.parse`), while `encodePassable` targets *rank-order preservation* (a database key whose lexicographic order matches PassStyle rank order). The two encoders share the diagnostic-priority error-special-case but differ in everything else.
- [[pass-invariant-handle-equality]] — the broader equality discipline that connects how a value encodes to how it is identified across a serialization boundary; rank-order encoding is the database-key-shaped form of that discipline.
- [[syrup-record-positionality]] — a third encoding-family decision (record fields as positional bindings, not on the wire); the family of encoding-shape decisions across the marshal / OCapN layer covers different reader needs.
- [[shape-not-content]] — the discipline of capturing the shape of an encoding rather than reproducing every byte; this concept page is itself an instance, summarizing the encoding *strategy* rather than mirroring the table.

## Provenance note

Concept page added cycle 81 (2026-05-29) by the `encodePassable.js`
longform-comment ingest. Originally cataloged the five
encodePassable.js sections covering the bytes-on-the-wire form of
the encoding. Cycle 84 (2026-05-29) extended the page with the
five sister `rankOrder.js` sections covering the in-memory
comparator and sort regime, broadening the concept's scope from
*encoder-only* to *encoder + comparator coordinated by the
canonical `passStylePrefixes` table*. The ten sections together
cover the file-level substance of both `encodePassable.js` and
`rankOrder.js`. The concept page is the entry point for any
future lookup arriving on terms like `encodePassable`,
`rank order encoding`, `compactOrdered`, `legacyOrdered`,
`passStylePrefixes`, `rankOrder`, `sameValueZero`,
`compareNumerics`, `RankCover`, `sortByRank`, `compareRank`, or
`makeFullOrderComparatorKit`; the sections it routes to carry
the per-component detail.
