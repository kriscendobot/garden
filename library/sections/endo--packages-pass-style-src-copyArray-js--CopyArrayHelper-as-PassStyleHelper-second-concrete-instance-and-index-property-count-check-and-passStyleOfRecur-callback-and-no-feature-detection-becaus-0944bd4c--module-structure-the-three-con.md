---
title: §Module structure — the three concerns template with adapter-factory step omitted
source-slug: endo--packages-pass-style-src-copyArray-js
section-slug: CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyArray.js
source-author: Endo project (collective)
total-lines: 38
ingest-cycle: 262
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
---

Cycle 260's byteArray.js had §the-three-concerns-template: (1) imports + destructuring + (2) **adapter factory** + (3) named-helper-export. Cycle 262's copyArray.js has §the-template-with-the-middle-step-omitted: (1) imports + destructuring + (3) named-helper-export. §The-template-flexes-to-its-concrete-instance — §when-the-substrate-is-a-universal-intrinsic-no-adapter-factory-is-needed.

§first-explicit-observation in library: **§the-PassStyleHelper-template-omits-the-adapter-factory-step-when-the-substrate-is-a-universal-intrinsic** — the §two-helpers-side-by-side-make-this-conditional-explicit; §the-adapter-factory-IS-a-feature-detection-step + §it-is-needed-only-when-the-substrate-is-conditional.
