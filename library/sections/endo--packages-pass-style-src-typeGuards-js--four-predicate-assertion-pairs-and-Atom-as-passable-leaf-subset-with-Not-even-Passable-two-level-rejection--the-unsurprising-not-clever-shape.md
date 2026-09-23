---
section: four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
source: endo--packages-pass-style-src-typeGuards-js
topics: [pass-style, hardened-javascript, marshal]
status: current
title: The §unsurprising-not-clever shape
parent: endo--packages-pass-style-src-typeGuards-js--four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
---

This file is *intentionally simple*. The complexity is
elsewhere:

- `passStyleOf` (cycle 71) does the heavy classification.
- `harden`, `Fail`, `q`, `hideAndHardenFunction` come from
  outside.
- Type narrowing in the JSDoc `@returns` clauses gives
  TypeScript inference; the runtime behavior is straightforward
  switch + comparison.

The §thin-wrappers-over-passStyleOf observation: this file
*republishes* the passStyleOf-as-string mechanism as
type-narrowing predicates. The library-grade API is here; the
*classification engine* is in cycle 71.

The §expected-imports-only discipline: the file imports *only*
`passStyleOf` and the error/harden primitives. Nothing else.
No marshal, no patterns, no exo. The §minimal-dependency-
surface keeps this layer at the *bottom* of the @endo
dependency stack.
