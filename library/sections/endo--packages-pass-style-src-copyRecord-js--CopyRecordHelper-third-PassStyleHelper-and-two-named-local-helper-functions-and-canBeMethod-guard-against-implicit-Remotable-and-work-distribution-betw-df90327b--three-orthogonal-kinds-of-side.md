---
title: §Three orthogonal kinds-of-side-channel-defense
source-slug: endo--packages-pass-style-src-copyRecord-js
section-slug: CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyRecord.js
source-author: Endo project (collective)
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
---

The triplet now demonstrates **three orthogonal kinds of side-channel-defense** appropriate to three different substrate shapes:

1. **§Count-zero** — byteArray. The substrate is opaque bytes; any own key IS a side channel.
2. **§Count-equal-to-len-plus-1** — copyArray. The substrate has required structure (`length` + indices); anything else IS a side channel.
3. **§Per-key-string-and-per-value-not-method** — copyRecord. The substrate has open structure; the side channel arrives via the *kind* of key or value, not via count.

§The-three-forms-IS-the-cluster's-side-channel-defense-vocabulary — §the-helpers-cluster-teaches-three-defense-shapes-by-instantiation; §first-explicit-observation in library of §the-cluster's-side-channel-defense-vocabulary-has-three-named-forms.
