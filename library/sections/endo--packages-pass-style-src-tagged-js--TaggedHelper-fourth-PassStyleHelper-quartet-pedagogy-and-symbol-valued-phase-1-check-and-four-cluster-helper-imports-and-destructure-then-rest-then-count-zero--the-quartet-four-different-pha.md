---
title: §The quartet — four different phase-1 tactics across four substrate shapes
source-slug: endo--packages-pass-style-src-tagged-js
section-slug: TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/tagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/tagged.js
source-author: Endo project (collective)
total-lines: 49
ingest-cycle: 268
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-tagged-js--TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero
---

| Cycle | Helper           | Substrate                          | Phase-1 tactic                                              | Notable structural move                       |
|-------|------------------|------------------------------------|-------------------------------------------------------------|-----------------------------------------------|
| 260   | ByteArrayHelper  | Immutable ArrayBuffer (stage-3)    | `instanceof ArrayBuffer && candidate.immutable`             | Adapter-factory for stage-3 detection         |
| 262   | CopyArrayHelper  | `Array` (universal)                | `Array.isArray(candidate)`                                  | Realm-aware intrinsic test                    |
| 264   | CopyRecordHelper | `Object` with `Object.prototype`   | Prototype + each-key-string + each-value-not-method         | Named local helpers extracted                  |
| 268   | TaggedHelper     | Tagged record (Tag-Record + payload)| `candidate[PASS_STYLE] === 'tagged'` via `confirmPassStyle` | **Symbol-marker phase-1**; four cluster imports|

§First-explicit-observation in library: **§four-different-phase-1-tactics-across-the-quartet — §each-helper's-phase-1-tactic-reflects-its-substrate's-discriminator + §the-tagged-helper-introduces-symbol-marker-discrimination-because-tagged-records-carry-an-explicit-PASS_STYLE-marker**.
