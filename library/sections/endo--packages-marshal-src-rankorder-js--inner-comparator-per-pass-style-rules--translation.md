---
title: Translation
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

| rankOrder idiom | Adjacent vocabulary |
|---|---|
| "tied for the same rank" | the rank-equality outcome for the four PassStyles where rank-order intentionally does not distinguish members |
| "trivial less-than" | a comparator based on native `<`/`===`/`>`; used directly for boolean and bigint |
| "name-string-via-recursion" | the symbol comparison strategy: extract the canonical name, recurse on the resulting string |
| "inverse sorted order of property names" | `recordNames`'s return order is descending; the lexicographic comparison then walks from largest name down, which produces the subset-ranks-earlier property |
| "prefix-ranks-earlier" | the copyArray rule that a shorter array which matches the head of a longer one ranks earlier |
| "subset-ranks-earlier" | the copyRecord rule (consequence of comparing inverse-sorted names lexicographically) that a record whose names are a subset of another's ranks earlier |
| "shortlex" | the byteArray rule: first by length, then by lexicographic per-byte order |
| "@endo/immutable-arraybuffer shim gap" | the API limitation that requires a `slice(0)` copy to construct a Uint8Array view over a shim-provided ImmutableArrayBuffer |
| "NaN as compareRemotables default" | the strategy of returning NaN (not 0) for the default remotable comparator, which short-circuits the comparator chain and ties any pair of values whose first remotable position differs but everything-up-to is equal |
| "deep-tied" | the consequence of the NaN-default: `[r1, 0]` and `[r2, "x"]` are tied because the comparison short-circuits at the first remotable pair before reaching the second element pair |

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L157-L330) at commit `2e933309`.
