---
title: §the-named-Key-Pattern-Passable-hierarchy-tree
source: endo--packages-patterns-README-md
url: https://github.com/endojs/endo/blob/master/packages/patterns/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/patterns/README.md
total-lines: 415
ingest-cycle: 327
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-Why-X-sections-in-one-README
  - the-named-Why-X-section-discipline
  - the-named-comparative-justification-by-anticipated-objection
  - the-named-Key-Pattern-Passable-hierarchy-tree
  - the-named-ASCII-tree-for-type-hierarchy
  - the-named-Pattern-IS-itself-Passable
  - the-named-three-named-categories-Passable-Key-Pattern
  - the-named-M-namespace-as-canonical-builder
  - the-named-six-categories-of-M-matchers
  - the-named-Quick-Start-shows-error-output
  - the-named-required-optional-rest-tripartite
  - the-named-eref-IS-named-eventual-reference
  - the-named-call-vs-callWhen-distinction
  - the-named-chained-method-guard-builder
  - the-named-defensive-programming-IS-named-discipline
  - the-named-distributed-equality-semantics
  - the-named-partial-order-not-total-order
  - the-named-NaN-as-named-incomparable
  - the-named-bigint-for-arbitrary-precision-counts
  - the-named-counts-combine-on-duplicate-keys
  - eighteen-cycles-with-named-pivot-domain-stay
  - sixteen-citation-arc-closures-in-pivot-now
  - three-cycles-with-named-one-cycle-README-source-arc
  - three-cycles-with-named-role-label-before-package-name
  - three-cycles-with-named-monorepo-docs-reference
  - three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken
parent: endo--packages-patterns-README-md--three-Why-X-sections-and-Key-Pattern-Passable-hierarchy-tree
---

Lines 372-391 visualize the entire type system as a 13-line ASCII tree:

```
Passable (everything that can pass)
├── Error
├── Promise
├── Key (stable, comparable)
│   ├── Primitives (null, undefined, boolean, number, bigint, string, symbol)
│   ├── Remotable
│   ├── CopyArray<Key>
│   ├── CopyRecord<Key>
│   ├── CopySet<Key>
│   ├── CopyBag<Key>
│   └── CopyMap<Key, Passable>
└── Pattern (describes a set of Passables)
    ├── Key (matches itself)
    └── Key-like with Matcher leaves
```

**§the-named-ASCII-tree-for-type-hierarchy** — first-explicit-observation. The tree carries multiple load-bearing structural facts:

1. **§the-named-three-named-categories-Passable-Key-Pattern** — Passable, Key, Pattern are the three categories. Key is a *subset* of Passable; Pattern is *also* a subset of Passable.
2. **§the-named-Pattern-IS-itself-Passable** — patterns can be sent across vats. Without this, distributed validation wouldn't work (you couldn't ship the validator to where the data is). The README states it as a structural fact via the tree's placement of Pattern *under* Passable. First-explicit-observation. **Load-bearing for distributed capability-security**.
3. **§the-named-Key-recurs-in-Pattern** — *"Pattern: Key (matches itself) OR Key-like with Matcher leaves"* — a literal Key IS a valid Pattern (it matches only equal Keys). This is **§the-named-data-is-its-own-pattern** discipline.

Compare to cycle 325's **§the-named-exhaustive-enumeration-via-table** (13 pass-styles in a table): the patterns README chose a *tree* (showing containment); the pass-style README chose a *table* (showing parallel rows). Two different visualizations for two different structural relationships. **§the-named-visualization-shape-matches-structural-relationship** (table = parallel; tree = containment).
