---
title: "@endo/pass-style/src/copyRecord.js — CopyRecordHelper third PassStyleHelper concrete instance + two named local helper functions + canBeMethod guard against implicit-Remotable + work-distribution-between-phases varies per helper"
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
kind: index
section_count: 17
---

Sections:

- [`@endo/pass-style/src/copyRecord.js` — third PassStyleHelper concrete instance, completing the leaf-pass-style triplet](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--endo-pass-style-src-copyrecord.md)
- [§The triplet-pedagogy — three points define the pattern](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--the-triplet-pedagogy-three-poi.md)
- [§Module structure — imports plus two named local helper functions plus the helper export](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betwe-df90327b--module-structure-imports-plus.md)
- [§The `@import {Rejector}` JSDoc-named-protocol](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--the-import-rejector-jsdoc-name.md)
- [§confirmObjectPrototype — the first named local helper](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--confirmobjectprototype-the-fir.md)
- [§confirmPropertyCanBeValid — the second named local helper](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betwe-df90327b--confirmpropertycanbevalid-the.md)
- [§The `every` short-circuits at first rejection](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--the-every-short-circuits-at-fi.md)
- [§assertRestValid — only the recursive walk](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--assertrestvalid-only-the-recur.md)
- [§No own-keys-count check — records have no count invariant](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--no-own-keys-count-check-record.md)
- [§Three orthogonal kinds-of-side-channel-defense](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--three-orthogonal-kinds-of-side.md)
- [§Cycle 264 first-explicit-observations roundup](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--cycle-264-first-explicit-obser.md)
- [§Recurring meta-pattern counters bumped at cycle 264](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betw-df90327b--recurring-meta-pattern-counter.md)
- [§Synthesis target — slot machine library](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betwe-df90327b--synthesis-target-slot-machine.md)
- [§Tier-1 borrowing](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies--tier-1-borrowing.md)
- [§Tier-2 borrowing](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies--tier-2-borrowing.md)
- [§Tier-3 borrowing](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies--tier-3-borrowing.md)
- [Pattern summary (tag-prefixed)](endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-betwee-df90327b--pattern-summary-tag-prefixed.md)
