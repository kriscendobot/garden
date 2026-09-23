---
title: See also
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "362-374"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "Why marshal added a third rank comparator between short-circuiting compareRank and fully-ordering fullCompare: compareRankRemotablesTied considers all remotables tied for the same rank but does not short-circuit on encountering them; its adoption as the default compare argument for isRankSorted, assertRankSorted, sortByRank, rankSearch, getIndexCover, unionRankCovers, and intersectRankCovers"
ingested: 2026-06-27
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--compare-rank-remotables-tied-default-comparator
---

- [`endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules`](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md) — sibling section; documents the NaN-default `compareRemotables` whose short-circuiting deep-tie behaviour this comparator deliberately avoids, and the `[r1, 0]` / `[r2, "x"]` deep-tied example that motivates a tied-but-continuing alternative.
- [`endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state`](endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state.md) — sibling section; the *third* point of the comparator triad — the strict total order on remotables — which this comment contrasts against (`unlike fullCompare`).
- [`endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant`](endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant.md) — sibling section; `sortByRank` is one of the seven entry points that now defaults its `compare` argument to `compareRankRemotablesTied`.
- [`endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers`](endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers.md) — sibling section; the `RankCover` machinery whose `getIndexCover` / `unionRankCovers` / `intersectRankCovers` consumers also adopted the new default comparator.
- [[rank-order-preserving-encoding]] — the concept page; the in-memory comparator regime this comparator joins.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L362-L374) at commit `337d16a8`.
