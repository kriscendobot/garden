---
section: four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
source: endo--packages-pass-style-src-typeGuards-js
topics: [pass-style, hardened-javascript, marshal]
status: current
title: Four predicate-assertion pairs and Atom as passable-leaf subset with `Not even Passable` two-level rejection
parent: endo--packages-pass-style-src-typeGuards-js--four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
---

> *the AtomStyle cases ... Not even Passable: ${err}: ${val}*
>
> — `packages/pass-style/src/typeGuards.js` lines 129 and 118

`typeGuards.js` (153 lines) is the **user-facing type-guard
surface** for @endo/pass-style. Defines `isCopyArray`,
`isByteArray`, `isRecord`, `isRemotable`, their `assertX`
counterparts, plus `isAtom` / `assertAtom` for the
*passable-leaf subset*. Last touched 2025-09-15 by Mark S.
Miller in commit `7408280d9f`. Imports only `passStyleOf`
from the sibling file (cycle 71) and `Fail` / `q` /
`hideAndHardenFunction` from `@endo/errors`.
