---
title: Translation
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

| rankOrder idiom | Adjacent vocabulary |
|---|---|
| "Array.prototype.sort `undefined` quirk" | the EcmaScript-spec behavior of placing `undefined` at the end of the sorted array without consulting the comparator |
| "reverse comparator" | the `antiComparator` paired with each forward comparator in a `RankComparatorKit`; produces descending rank order |
| "compare(true, undefined) > 0 as direction probe" | the comparator-agnostic test for "is this comparator the reverse direction"; one canonical-pair query suffices |
| "copyWithin / fill relocation" | the in-place algorithm that shifts the non-undefined block right by `n` and writes `n` `undefined`s into the freed leading slots |
| "passStylePrefixes MUST NOT sort any category after undefined" | the invariant linking this file's sort-time fixup to encodePassable.js's table-construction comment; both sites depend on it |
| "memoOfSorted" | the WeakMap from comparators to WeakSets of already-sorted arrays; powers the already-sorted shortcut |
| "cross-comparator inference" | the optimization where verifying an array is rank-sorted under one comparator (via isRankSorted) memoizes it under that comparator even if it was originally sorted under a different one |
| "harden-then-sort-then-harden" | the input/output hardening discipline that keeps consumers from mutating sorted output while letting the in-place sort proceed on a working copy |

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L150-L410) at commit `2e933309`.
