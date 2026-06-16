---
title: "`sortByRank` and the `Array.prototype.sort` `undefined` quirk: why the reverse comparator must move `undefined` from the end to the start, why `passStylePrefixes` MUST NOT sort any category after `undefined`, and the memoization-keyed-by-comparator pattern"
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
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant--abstract.md)
- [Body](endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant--body.md)
- [Translation](endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant--translation.md)
- [See also](endo--packages-marshal-src-rankorder-js--sort-by-rank-undefined-quirk-and-passstyleprefixes-invariant--see-also.md)

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L150-L410) at commit `2e933309`.
