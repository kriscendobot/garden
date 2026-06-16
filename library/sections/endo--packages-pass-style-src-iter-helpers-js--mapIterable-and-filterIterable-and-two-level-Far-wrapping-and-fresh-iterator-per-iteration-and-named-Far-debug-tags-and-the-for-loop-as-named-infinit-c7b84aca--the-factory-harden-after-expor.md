---
title: §The factory-harden-after-export idiom reappears
source-slug: endo--packages-pass-style-src-iter-helpers-js
section-slug: mapIterable-and-filterIterable-and-two-level-Far-wrapping-and-fresh-iterator-per-iteration-and-named-Far-debug-tags-and-the-for-loop-as-named-infinite-loop-form
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/iter-helpers.js
source-repo: endojs/endo
source-path: packages/pass-style/src/iter-helpers.js
source-author: Endo project (collective)
total-lines: 60
ingest-cycle: 274
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-iter-helpers-js--mapIterable-and-filterIterable-and-two-level-Far-wrapping-and-fresh-iterator-per-iteration-and-named-Far-debug-tags-and-the-for-loop-as-named-infinite-loop-form
---

Lines 29 and 60: `harden(mapIterable);` and `harden(filterIterable);` — both factories hardened AFTER export.

§Two-cycles-with-factory-harden-after-export-idiom (270 makeTagged + 274 iter-helpers' two factories); §the-discipline-IS-now-canonical-across-three-named-factories (cycle 270's makeTagged + cycle 274's mapIterable + filterIterable).

§First-explicit-observation in library: **§three-named-factories-with-factory-harden-after-export-idiom — §the-discipline-IS-now-canonical-across-three-instances**.
