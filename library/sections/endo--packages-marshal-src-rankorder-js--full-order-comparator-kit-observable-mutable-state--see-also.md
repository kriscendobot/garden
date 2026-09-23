---
title: See also
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "598-642"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "Why makeFullOrderComparatorKit assigns remotables an order by first-seen-time; the BEWARE that this is observable mutable state and unsharable across subsystems that must not communicate; why fresh full-order comparators preserve already-sorted scalar arrays but not passable arrays in general; why the kit cannot be used for store ordering (no memory of deleted keys); the longLived parameter's WeakMap vs Map trade-off"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state
---

- [`endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules`](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md) — sibling section; documents the NaN-default `compareRemotables` and the deep-tied consequence; this section names the strict alternative.
- [`endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table`](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) — sister section in cycle 81; documents the `|` ordinal-mapping prefix that lets persistent stores use a *separate* table for the same purpose this kit fulfills in-memory.
- [`endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant`](endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant.md) — sibling section; full-order comparators face the same `undefined`-at-end Array.prototype.sort quirk; the reverse-direction fixup in sortByRank applies equally.
- [`endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics`](endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics.md) — sibling section; the up-front `sameValueZero` tie-check and `compareNumerics` apply both to the rank-order and the full-order comparators, since full-order only refines the remotable case.
- [[rank-order-preserving-encoding]] — the concept page; the cover machinery this section explains is built atop the in-memory consumer machinery this section discusses.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L598-L642) at commit `337d16a8`.
