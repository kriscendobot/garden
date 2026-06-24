---
title: Abstract
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "157-330"
source_commit: 2e9333096fc82fabc9a3c1f6d3e268336e7df943
comment_subject: "How the inner comparator dispatches per PassStyle: each per-style rank rule, including the prefix-ranking property that lets a record/array X with a subset of Y's property names or a prefix of Y's elements sort earlier; the deep-tied implication of NaN as compareRemotables default; the byteArray shortlex rule; the @endo/immutable-arraybuffer prototype-check workaround"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules
---

`makeComparatorKit`'s **inner comparator** is the heart of
rankOrder.js: after `sameValueZero` finds no tie and after the
two values' PassStyles match (mismatched PassStyles delegate to
`compareNumerics` on the indexes from `passStyleRanks`), a `switch`
dispatches per-PassStyle with one carefully-chosen rank rule per
style. **Four PassStyles tie**: every pair of `undefined` /
`null` / `error` / `promise` values rank-compares as 0; their
content is not distinguishable at the rank-order level. **Two
PassStyles use trivial less-than**: `boolean` (false < true) and
`bigint` (numeric order). **One PassStyle has three modes**:
`string` dispatches on `ENDO_RANK_STRINGS`. **Symbols compare by
name**: `nameForPassableSymbol` extracts each symbol's well-known
or registered name, then the comparator recurses on the names
(which become strings). **Numbers** delegate to `compareNumerics`
(NaN last, +0/-0 tied). **CopyRecords** compare lexicographically
by the *inverse-sorted* property name list, then by the
corresponding values in that same inverse order — a careful
choice that ensures *records whose property names are a subset
of another's rank earlier*. **CopyArrays** compare
lexicographically element-by-element, then by length — a
*shorter-as-prefix-of-longer ranks earlier* rule. **ByteArrays**
compare *shortlex*: shorter first, then lexicographic at equal
length, with a defensive prototype check to handle the
`@endo/immutable-arraybuffer` shim. **Tagged values** compare
lexicographically by `[Symbol.toStringTag]` first, then by
`.payload`. The **`compareRemotables` default of returning `NaN`**
means *all remotables tie*, and the comment names a notable
consequence: not only `r1` and `r2` tie, but so do `[r1, 0]` and
`[r2, "x"]` — the NaN short-circuits the comparator before
deeper structure can distinguish them.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L157-L330) at commit `2e933309`.
