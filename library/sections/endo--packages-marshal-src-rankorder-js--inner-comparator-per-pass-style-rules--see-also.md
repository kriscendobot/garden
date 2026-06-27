---
title: See also
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "157-330"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "How the inner comparator dispatches per PassStyle: each per-style rank rule, including the prefix-ranking property that lets a record/array X with a subset of Y's property names or a prefix of Y's elements sort earlier; the deep-tied implication of NaN as compareRemotables default; the byteArray shortlex rule; the @endo/immutable-arraybuffer prototype-check workaround"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules
---

- [`endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics`](endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics.md) — sibling section; the `sameValueZero` up-front tie check and the `compareNumerics` used here for both number ranking and the cross-PassStyle index comparison.
- [`endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers`](endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers.md) — sibling section; the `passStyleRanks[leftStyle].index` integer this section uses is what the derivation in the sibling produces.
- [`endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant`](endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant.md) — sibling section; the `Array.prototype.sort`-induced placement of `undefined` requires that no PassStyle's rank rule produces a value after `undefined`, which links the case-list here to the passStylePrefixes invariant.
- [`endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state`](endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state.md) — sibling section; the alternative `compareRemotables` that breaks the NaN-default tie and gives a stricter total order.
- [`endo--pkg-pass-style-readme`](../sources/endo--pkg-pass-style-readme.md) — adjacent source's enumeration of PassStyles; this section provides the rank-order rule for each one.
- [[rank-order-preserving-encoding]] — the concept page; the rules here are the in-memory dual of how each PassStyle encodes on the wire.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L157-L330) at commit `337d16a8`.
