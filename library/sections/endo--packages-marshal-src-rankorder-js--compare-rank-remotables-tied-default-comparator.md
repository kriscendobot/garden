---
title: "`compareRankRemotablesTied` / `compareAntiRankRemotablesTied`: the rank comparator that ties all remotables and does not short-circuit, sitting between short-circuiting `compareRank` and fully-ordering `fullCompare`, and now the default `compare` argument across the sort / search / cover API"
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
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-rankorder-js--compare-rank-remotables-tied-default-comparator--abstract.md)
- [Body](endo--packages-marshal-src-rankorder-js--compare-rank-remotables-tied-default-comparator--body.md)
- [Translation](endo--packages-marshal-src-rankorder-js--compare-rank-remotables-tied-default-comparator--translation.md)
- [See also](endo--packages-marshal-src-rankorder-js--compare-rank-remotables-tied-default-comparator--see-also.md)

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L362-L374) at commit `337d16a8`.
