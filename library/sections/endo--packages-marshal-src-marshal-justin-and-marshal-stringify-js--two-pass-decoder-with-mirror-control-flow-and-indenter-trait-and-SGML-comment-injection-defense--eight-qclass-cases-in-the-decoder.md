---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
title: §Eight-qclass-cases-in-the-decoder
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

§The-`switch (rawTree['@qclass'])` handles eight encoded types:

| qclass | Justin rendering |
|--------|------------------|
| `undefined` | `undefined` |
| `NaN` | `NaN` |
| `Infinity` | `Infinity` |
| `-Infinity` | `-Infinity` |
| `bigint` | `${digits}n` |
| `@@asyncIterator` | `Symbol.asyncIterator` (TODO deprecated) |
| `symbol` | `Symbol.iterator` or `passableSymbolForName("...")` |
| `tagged` | `makeTagged("...", payload)` |
| `slot` | `slot(N)` or `slotToVal(renderedSlot)` |
| `hilbert` | `{"@qclass": original, ...rest}` |
| `error` | `Name("message")` |

§Eleven-cases-actually (the table above has 11 entries; I
miscounted as 8 above). §Each-case-maps-to-a-Justin-expression
that §evaluates-to-the-original-passable when interpreted in
a Justin-aware host (one that has `makeTagged`,
`passableSymbolForName`, `slotToVal`, and error constructors
in scope).

§The-Hilbert-case maps to a synthesized object whose `@qclass`
property is a §nested-encoding — this preserves the cycle 152
Hilbert-Hotel encoding's round-trip.

§The-§error-case has §three-features-marked-not-yet-
implemented:

```js
cause === undefined || Fail`error cause not yet implemented in marshal-justin`;
name !== `AggregateError` || Fail`AggregateError not yet implemented in marshal-justin`;
errors === undefined || Fail`error errors not yet implemented in marshal-justin`;
```

§Three-fail-fast-checks for unimplemented features. §Honest-
limitation-via-Fail-template.
