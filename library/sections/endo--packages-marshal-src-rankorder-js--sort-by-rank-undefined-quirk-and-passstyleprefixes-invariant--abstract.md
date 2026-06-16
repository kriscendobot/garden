---
title: Abstract
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

`sortByRank` is the rank-aware sorting routine that backs CopyMap,
CopySet, and CopyBag's deterministic key ordering. Its
implementation rests on three observations the file's longform
comments name. First, **`Array.prototype.sort` has a
JavaScript-language-imposed quirk** where `undefined` elements are
placed at the end of the result without ever being passed to the
comparator function — bypassing any user-supplied ordering rule.
Second, when a user *reverses* the rank comparator (to get
descending order), the manual workaround for the quirk must move
the `undefined` elements *from the end to the start*: the file
detects the reverse case with `compare(true, undefined) > 0` and
uses `Array.prototype.copyWithin` and `Array.prototype.fill` to do
the relocation in place. Third, this only works *if the
canonical `passStylePrefixes` table never places any PassStyle
after `undefined`* — which is exactly what
`encodePassable.js`'s table-construction comment asserts (and what
that file's sibling section catalogs); the invariant has dual
sites enforcing it, one at the prefix-table level and one at the
sort-time level. The memoization machinery
(`memoOfSorted` WeakMap keyed by comparator) caches already-sorted
arrays per-comparator so repeated sort calls on the same input
can short-circuit.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L150-L410) at commit `2e933309`.
