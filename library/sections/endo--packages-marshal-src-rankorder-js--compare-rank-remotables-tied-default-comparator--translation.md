---
title: Translation
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

| rankOrder idiom | Adjacent vocabulary |
|---|---|
| "considers all remotables tied for the same rank" | imposes no order among remotables; any remotable compares equal to any other remotable, the same stance `compareRank` takes |
| "short circuit on encountering remotables" | `compareRank`'s behaviour of propagating the remotable `NaN`-tie outward and stopping the structural descent, so values that differ only past a remotable are reported tied |
| "do not short circuit" (compareRankRemotablesTied) | report the remotable pair tied (return 0 for it) but **continue** comparing the surrounding structure, so structurally-distinguishable values stay ordered |
| "`makeComparatorKit((_x, _y) => 0)`" | the factory call that builds this comparator: same kit as `compareRank` but with an explicit remotable-comparator that returns 0 (tie) instead of the implicit NaN-and-short-circuit default |
| "`fullCompare` / full order" | the third comparator stance — a strict total order on remotables (the full-order kit), which this comment names as the thing it is *unlike* |
| "default `compare` argument" | the optional parameter that now defaults to `compareRankRemotablesTied` across `isRankSorted`, `assertRankSorted`, `sortByRank`, `rankSearch`, `getIndexCover`, `unionRankCovers`, `intersectRankCovers` |

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L362-L374) at commit `337d16a8`.
