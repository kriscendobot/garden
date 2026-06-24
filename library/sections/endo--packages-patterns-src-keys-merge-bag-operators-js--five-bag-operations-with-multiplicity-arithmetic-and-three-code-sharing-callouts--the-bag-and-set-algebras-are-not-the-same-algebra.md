---
section: five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
source: endo--packages-patterns-src-keys-merge-bag-operators-js
topics: [patterns, marshal]
status: current
title: §The bag and set algebras are not the same algebra
parent: endo--packages-patterns-src-keys-merge-bag-operators-js--five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
---

The structurally most interesting observation across cycles
123 + 125: *the same merge-iterator and the same adapter pyramids
support two different algebras*. Sets form a *Boolean lattice*
(elements are present or absent); bags form a *multiplicity
lattice* (elements have non-negative integer multiplicities).
The *iterOps* express the differences:

- Set union: *push each* — element-presence only.
- Bag union: *add counts* — multiplicities accumulate.

- Set intersection: *push if both present* — element-presence.
- Bag intersection: *push min(xc, yc)* — multiplicity-min.

- Set superset: *every y is in x* (`xc !== 0n` for each y).
- Bag superset: *every y's count <= x's count* (`xc >= yc`).

The set version is *bag-version-with-counts-clipped-to-{0n,1n}*.
The *generalization-is-free* claim is structural: the bag
machinery subsumes the set machinery; consolidation should be
straightforward. The TODO marker is the abstraction debt
acknowledgment.
