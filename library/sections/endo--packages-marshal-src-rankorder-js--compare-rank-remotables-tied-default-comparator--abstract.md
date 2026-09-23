---
title: Abstract
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

`compareRankRemotablesTied` and its anti-comparator
`compareAntiRankRemotablesTied` are a **third rank comparator**
that marshal added between the two the rest of the rank regime
already exposed. The file's longform comment positions it
against its two neighbours: *like* `compareRank` /
`compareAntiRank` (and *unlike* `fullCompare`) it considers
**all remotables tied for the same rank** — it does not impose
any order among remotables; *unlike* `compareRank` /
`compareAntiRank` it does **not short-circuit on encountering
remotables**. The distinction is operational rather than
order-theoretic: `compareRank` returns `NaN` (coerced to a tie)
the moment it meets a remotable and stops descending, so two
deeply-nested values that differ only past a remotable are
reported tied without the rest being examined; `compareRankRemotablesTied`
treats the remotable pair itself as tied (via the
`makeComparatorKit((_x, _y) => 0)` remotable-comparator) but
**keeps comparing the surrounding structure**, so structurally-
distinguishable values are still ordered. The comparator is
built from the same `makeComparatorKit` factory as `compareRank`,
differing only in the remotable-tie callback it is given. Its
practical significance is that it became the **default `compare`
argument** for the seven public order-consuming entry points —
`isRankSorted`, `assertRankSorted`, `sortByRank`, `rankSearch`,
`getIndexCover`, `unionRankCovers`, and `intersectRankCovers` —
each of which previously required the caller to pass a comparator
explicitly. This section captures the new comment cluster; it
supersedes no prior section (the five original sections' backing
comments were unchanged by the refresh that added this one).

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L362-L374) at commit `337d16a8`.
