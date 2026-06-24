---
title: §Synthesis target — slot machine library
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

§Two-iterator-utilities-as-the-cluster-pedagogy applies to the §game-engine-cluster:

- §**`mapGameRoll`** — transforms each dice-roll value while preserving the roll-count + termination shape.
- §**`filterGameRoll`** — subsets the rolls (e.g., only rolls above a threshold) while preserving the termination.
- §**§two-level-Far-wrapping** — the `GameRollIterable` and `GameRollIterator` are both Far references.
- §**§fresh-iterator-per-iteration** — each call to `Symbol.iterator` on a GameRollIterable creates a fresh iterator.
- §**§named-Far-debug-tags** with the `<verb>ed <noun>` convention (e.g., `'capped game rolls'`, `'high-pass game rolls'`).
- §**§factory-harden-after-export idiom** for both `mapGameRoll` and `filterGameRoll`.
