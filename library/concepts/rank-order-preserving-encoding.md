---
id: rank-order-preserving-encoding
aliases: ["rank-order encoding", "rank order encoding", "rank-order preserving encoding", "sort-preserving encoding", "lexicographic order matches numeric order", "lexicographic byte order matches sort order", "encodePassable", "`encodePassable`", "`makePassableKit`", "compactOrdered", "legacyOrdered", "compactOrdered format", "legacyOrdered format", "rankOrder", "rank-order", "passStylePrefixes", "`passStylePrefixes`", "ordinal-mapping prefix", "bit-complement for sort order", "Elias delta encoding", "sign-aware alphabets", "ten's complement digit encoding"]
topics: [marshal, pass-style]
---

# rank-order-preserving-encoding

The discipline in `@endo/marshal`'s `encodePassable` of encoding
each Passable to a byte string such that **lexicographic
comparison of two encoded strings yields the same answer as
PassStyle-aware rank-order comparison of the two original
values**. The encoding is the substrate for the keyed-store
substrate that backs `CopyMap`, `CopySet`, `CopyBag`, and the
ordered-collection-pattern infrastructure; the rank-order
property is what lets the store use lexicographic indexes (e.g.,
LMDB key order) directly without re-parsing keys. Five
implementation techniques coordinate to achieve the property
across the full PassStyle space: sign-aware bit-complement on
IEEE-754 doubles (numbers); Elias-delta encoding with
sign-aware unary alphabets and ten's-complement digits (bigints);
contiguous-range character escapes that preserve byte-order on
strings (the `compactOrdered` `!`-prefix scheme); dual array
encodings (legacyOrdered uses NUL-terminator + SOH-escape;
compactOrdered uses space-terminator + pre-escaped strings); and
a canonical `passStylePrefixes` table whose source-order is the
inter-PassStyle rank-order. Errors are extracted from the
PassStyle dispatch via a root-level special case rooted in the
diagnostic-priority rule (errors that fail Passable validation
must still encode for diagnostic readability). The ordinal-mapping
prefix `|` is reserved outside the cover range so remotable-to-
ordinal mappings sort above every value key in the keyed store.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [number-encoding-binary64-bit-complement](../sections/endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement.md) | The sign-aware bit-complement that maps IEEE-754 doubles to a 16-hex-digit string whose lexicographic order matches numeric order; lockdown-independent NaN canonicalization with a WebIDL-shaped canonical NaN constant. |
| [bigint-encoding-elias-delta-with-sign-aware-alphabets](../sections/endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets.md) | Elias-delta encoding of bigints with `#`/`~` sign-aware unary alphabets and ten's-complement digit encoding so positive and negative bigints of arbitrary magnitude sort in their natural numeric order. |
| [compact-format-string-escapes](../sections/endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes.md) | The `compactOrdered` format's `!`-prefix escape table that maps `[0x00..0x21]` to `[0x21..0x40]` while preserving lexicographic order; the `^`/`_` array-marker patch; the legacyOrdered identity passthrough. |
| [dual-array-encodings-and-double-decode-verify](../sections/endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify.md) | The legacyOrdered NUL-terminator + SOH-escape and compactOrdered space-terminator + pre-escaped-string array encodings; the embeddability-verifying double-decode check on user-provided remotable / promise / error encoders. |
| [error-special-case-and-passstyle-prefix-table](../sections/endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) | The `isErrorLike` root-level special case (diagnostic priority over Passable validation) and the canonical `passStylePrefixes` table whose ordering coordinates per-PassStyle sort order with the cover machinery; the `|` ordinal-mapping prefix reserved outside the cover range. |

## See also

- [[smallcaps-encoding]] — the sister wire format under `packages/marshal/src/encodeToSmallcaps.js`; smallcaps targets *JSON-shape* (round-trip through `JSON.stringify`/`JSON.parse`), while `encodePassable` targets *rank-order preservation* (a database key whose lexicographic order matches PassStyle rank order). The two encoders share the diagnostic-priority error-special-case but differ in everything else.
- [[pass-invariant-handle-equality]] — the broader equality discipline that connects how a value encodes to how it is identified across a serialization boundary; rank-order encoding is the database-key-shaped form of that discipline.
- [[syrup-record-positionality]] — a third encoding-family decision (record fields as positional bindings, not on the wire); the family of encoding-shape decisions across the marshal / OCapN layer covers different reader needs.
- [[shape-not-content]] — the discipline of capturing the shape of an encoding rather than reproducing every byte; this concept page is itself an instance, summarizing the encoding *strategy* rather than mirroring the table.

## Provenance note

Concept page added cycle 81 (2026-05-29) by the `encodePassable.js`
longform-comment ingest. The five sections cataloged here cover
the entirety of the file's substantive rationale comments. The
concept page is the entry point for any future lookup arriving on
terms like `encodePassable`, `rank order encoding`, `compactOrdered`,
`legacyOrdered`, or `passStylePrefixes`; the sections it routes to
carry the per-component detail.
