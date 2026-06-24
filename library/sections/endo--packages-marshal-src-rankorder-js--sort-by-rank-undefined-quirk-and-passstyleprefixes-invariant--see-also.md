---
title: See also
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "150-157, 367-410"
source_commit: 2e9333096fc82fabc9a3c1f6d3e268336e7df943
comment_subject: "Why sortByRank manually moves `undefined` from end to start under a reverse comparator; the invariant `passStylePrefixes MUST NOT sort any category after undefined`; the WeakMap-keyed-by-comparator pattern for memoizing rank-sorted arrays; the harden-then-sort-then-harden-result discipline"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant
---

- [`endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table`](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) — sister section in cycle 81; the *Array.prototype.sort-induced `undefined` position* sub-section there explains the invariant from the prefix-table side; this section names the consequence at the sort-time side.
- [`endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules`](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md) — sibling section; the per-PassStyle case list is what the `passStylePrefixes` table catalogs and the invariant restricts.
- [`endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state`](endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state.md) — sibling section; full-order comparators face the same `undefined` quirk and rely on the same fixup.
- [[rank-order-preserving-encoding]] — the concept page; sortByRank is the in-memory consumer of the bytes-on-the-wire rank order property.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L150-L410) at commit `2e933309`.
