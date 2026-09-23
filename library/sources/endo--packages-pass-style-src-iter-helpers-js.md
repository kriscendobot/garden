---
title: "@endo/pass-style/src/iter-helpers.js — mapIterable + filterIterable iterator-helper utilities"
source-slug: endo--packages-pass-style-src-iter-helpers-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/iter-helpers.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/iter-helpers.js
total-lines: 60
ingest-cycle: 274
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/iter-helpers.js`

A 60-line file that exports two iterator-helper utilities: `mapIterable` + `filterIterable`. **The last uningested pass-style source file** — cycle 274 completes the pass-style cluster's source-file ingest.

## Key moves

- **§Two cycles with utility-file shape in the pass-style cluster** (272 string + 274 iter-helpers) — the cluster has two named file shapes, confirmed twice each.
- **§Two-level Far wrapping** — both the iterable and the iterator are Far references; the helper doesn't leak bare iteration state.
- **§Fresh-iterator-per-iteration** — `Symbol.iterator` IS a factory not a getter; each call creates a fresh iterator.
- **§Named Far debug tags** with the `<verb>ed <noun>` convention (`'mapped iterable'`, `'mapped iterator'`, `'filtered iterable'`, `'filtered iterator'`).
- **§Element-count and termination-shape preservation** as named iterator contract; the result iterator has the same element count AND the same termination shape (completion-value OR failure-reason).
- **§The discriminator `done ? baseValue : func(baseValue)`** as named termination-aware transformation — the termination value IS preserved, not transformed.
- **§The `!!done` boolean coercion** as named defensive discipline against truthy-non-boolean done values.
- **§The `for (;;)` as named infinite-loop form** — not `while (true)`; sibling-pattern to C/C++.
- **§The skip-or-return loop shape in filterIterable** — pass-through-not-rewrap for the result object.
- **§Two named iterator result shapes** — same-element-count-transformed-values (mapIterable) + subset-with-unchanged-values (filterIterable).
- **§The template-parameter count correlates with the shape change** — mapIterable `<T,U>` (two; types differ); filterIterable `<T>` (one; types same).
- **§Three named factories with factory-harden-after-export idiom** (270 makeTagged + 274 mapIterable + 274 filterIterable).

## §The pass-style cluster source-file ingest IS now structurally complete

| File class       | Files                                                | Cycles ingesting              |
|------------------|------------------------------------------------------|-------------------------------|
| Helper-files     | byteArray + copyArray + copyRecord + tagged          | 260 + 262 + 264 + 268         |
| Utility-files    | string + iter-helpers                                | 272 + 274                     |
| Metalanguage     | internal-types                                       | 266                           |
| Constructor      | makeTagged                                           | 270                           |
| Helpers cluster  | passStyle-helpers                                    | earlier                       |

§The pass-style cluster source-file ingest IS now structurally complete.

## Section files

- [§mapIterable + §filterIterable + §two-level Far wrapping + §fresh-iterator-per-iteration + §named Far debug tags + §the `for (;;)` as named infinite-loop form](../sections/endo--packages-pass-style-src-iter-helpers-js--mapIterable-and-filterIterable-and-two-level-Far-wrapping-and-fresh-iterator-per-iteration-and-named-Far-debug-tags-and-the-for-loop-as-named-infinite-loop-form.md) — full 60-line file in scope.

## Ingest scope

Cycle 274 (chat-lane after cycle 273's designs-lane OUTLINER_INTERACTION_PATTERNS). Full 60-line file ingested. **First-explicit-observations (twelve plus a meta-observation)**: two-cycles-with-utility-file-shape-in-the-pass-style-cluster + two-level-Far-wrapping-for-iterable-and-iterator + fresh-iterator-per-iteration-as-named-Far-wrapping-discipline + named-Far-debug-tags-as-named-debug-aid + element-count-and-termination-shape-preservation-as-named-iterator-contract + the-discriminator-`done ? baseValue : func(baseValue)`-IS-the-named-termination-aware-transformation + the-`!!done`-boolean-coercion-as-named-defensive-discipline + the-`for (;;)`-as-named-infinite-loop-form + the-skip-or-return-loop-shape-uses-pass-through-not-rewrap + two-named-iterator-result-shapes + the-template-parameter-count-correlates-with-the-shape-change + three-named-factories-with-factory-harden-after-export-idiom + the-pass-style-cluster-source-file-ingest-IS-now-structurally-complete.
