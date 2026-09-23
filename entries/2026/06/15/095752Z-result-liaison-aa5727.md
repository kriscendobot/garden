---
kind: result
role: liaison
dispatch-root: dispatches/liaison--aa5727
cycle: 327
lane: designs
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 327: @endo/patterns README.md (designs-lane; adjacent-reverse pair with cycle 326; three Why-X-sections; type-hierarchy tree)

Cycle 327 ingest: **@endo/patterns README.md** (415 lines). Designs-lane after cycle 326's chat-lane index.js. **Eighteenth consecutive non-garden source after the pivot** (cycles 310-327). **§eighteen-cycles-with-named-pivot-domain-stay**. **Tenth package extends** (index.js → README adjacent-reverse pair, mirroring lp32 315-316).

**§the-named-citation-arc-from-cycle-326-takes-1-cycle-to-close** — **third one-cycle README↔source arc closure in the pivot**:
- 323 README → 324 atomics.js (1 cycle)
- 325 README → 326 index.js (1 cycle)
- 326 index.js → 327 README (1 cycle; reverse direction)

**§three-cycles-with-named-one-cycle-README-source-arc**. **§sixteen-citation-arc-closures-in-pivot-now**.

## Single most structurally interesting move

**§the-named-three-Why-X-sections-in-one-README** — the README has *three* explicit "Why X?" sections that justify design choices vs natural alternatives:

| Section | Question | Answer |
|---|---|---|
| Why not use JavaScript Set? | Why CopySet over native Set? | Sets aren't passable; CopySet is frozen + comparable + serialized |
| Why not use plain objects? | Why CopyMap over plain objects? | Any Key as key + efficient compareKeys + subset relationships |
| Why partial order? | Why compareKeys returns NaN sometimes? | Different remotables have no ordering; CopySets use subset relationships |

**§the-named-Why-X-section-discipline** — first-explicit-observation as a *documentation discipline*. Each section names the natural alternative + explains why the package chose otherwise + lists the properties the chosen design provides. **§the-named-comparative-justification-by-anticipated-objection** — documentation as dialogue with the reader's likely confusion.

## §the-named-Key-Pattern-Passable-hierarchy-tree

The README visualizes the entire type system as a 13-line ASCII tree (lines 372-391):

```
Passable
├── Error
├── Promise
├── Key (stable, comparable)
│   ├── Primitives
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

**§the-named-Pattern-IS-itself-Passable** — patterns are first-class Passable data; they can be shipped to where the data is. **Load-bearing for distributed validation**. First-explicit-observation.

**§the-named-visualization-shape-matches-structural-relationship** — cycle 325 pass-style README used a **table** for parallel rows; cycle 327 patterns README uses a **tree** for containment relationships. Two different visualizations for two different structural shapes. First-explicit-observation as a tier-3 meta-pattern.

## Three-cycle confirmations

Three multi-cycle patterns reach three-instance confirmation this cycle:

| Pattern | Cycles | Status |
|---|---|---|
| §three-cycles-with-named-one-cycle-README-source-arc | 323→324, 325→326, 326→327 | Recurring discipline |
| §three-cycles-with-named-role-label-before-package-name | 321, 325, 327 | Recurring discipline |
| §three-cycles-with-named-monorepo-docs-reference | 321, 325, 327 | Recurring discipline (`../../docs/message-passing.md`) |
| §three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken | 323, 325, 327 | Recurring with three different reasons for absence |

The three-cycle confirmations validate that these are *disciplines*, not coincidences.

## Other first-explicit-observations

- §the-named-M-namespace-as-canonical-builder with §the-named-six-categories-of-M-matchers (Primitive + Container + Structured + Logical + Comparison + Special)
- §the-named-required-optional-rest-tripartite — `M.splitArray(required, optional, rest)` + `M.splitRecord(required, optional, rest)`
- §the-named-eref-IS-named-eventual-reference — `M.eref(M.number())` matches *number or promise for number*; encodes (Value | Promise) axis of cycle 321's cartesian product as a single matcher
- §the-named-Quick-Start-shows-error-output — Quick Start example fails ON PURPOSE to show the error message verbatim; §the-named-fail-on-purpose-discipline
- §the-named-call-vs-callWhen-distinction (sync vs awaits-args); §the-named-chained-method-guard-builder
- §the-named-defensive-programming-IS-named-discipline (explicit naming of what the package supports)
- §the-named-distributed-equality-semantics — equality as protocol-level property, not implementation detail
- §the-named-partial-order-not-total-order with §the-named-NaN-as-named-incomparable (JS NaN repurposed for "no defined ordering")
- §the-named-bigint-for-arbitrary-precision-counts in CopyBag; §the-named-counts-combine-on-duplicate-keys
- §the-named-Endo-reference-docs-link — *"For best rendering, use the Endo reference docs site"*

## Multi-cycle patterns extended

- §eighteen-cycles-with-named-pivot-domain-stay (310-327)
- §sixteen-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-one-cycle-README-source-arc (323→324, 325→326, 326→327)
- §three-cycles-with-named-role-label-before-package-name (321 + 325 + 327)
- §three-cycles-with-named-monorepo-docs-reference (321 + 325 + 327)
- §three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken (323 + 325 + 327)
- §two-cycles-with-named-Deep-Dives-IS-named-implementation-detail-section (325 + 327)

## Tier-3 meta-patterns

- **§the-named-Why-X-section-discipline** — anticipate reader objections; name natural alternative + chosen design + properties
- **§the-named-comparative-justification-by-anticipated-objection** — documentation as dialogue with the reader
- **§the-named-Pattern-IS-itself-Passable** — patterns are first-class data; load-bearing for distributed validation
- **§the-named-visualization-shape-matches-structural-relationship** — table for parallel; tree for containment
- **§the-named-distributed-equality-semantics** — equality as protocol-level, not implementation-level
- **§the-named-NaN-as-named-incomparable** — JS NaN repurposed for "no defined ordering"
- **§the-named-fail-on-purpose-discipline** — Quick Start examples that fail to show what errors look like
- **§the-named-eref-IS-named-eventual-reference** — encodes (Value | Promise) axis of cycle 321 cartesian product

## Synthesis-target

Slot machine library **§`@game/patterns/README.md`** — pattern-matching for game data validation:

1. Quick Start fails ON PURPOSE to show error output
2. M-namespace as canonical builder with six (or fewer) categories
3. Required-optional-rest tripartite for split patterns
4. Why X? sections justifying design choices vs alternatives
5. ASCII tree for type hierarchy with containment
6. Table for parallel types; tree for containment (visualization-shape-matches-structure)
7. Pattern-IS-Passable: patterns can be shipped to where data is
8. Distributed equality semantics named as protocol-level property
9. NaN-as-incomparable for partial-order
10. Integration with role labels for cross-package citations
11. Defensive programming named as discipline
12. Deep Dives section pointing to implementation docs

## Library state after cycle 327

- §library-reaches-839-sections from 375 source documents
- §one-hundred-and-sixtieth consecutive designs-chat alternation
- §eighteen-cycles-with-named-pivot-domain-stay
- §ten-named-packages-in-the-pivot-cluster
- §sixteen-citation-arc-closures-in-pivot-now (lengths: 1, 1, 1, 2, 4, 165, 169, 175, 175, 177, 189, 191, 214, 238, 254, 255)
- §three-cycles-with-named-one-cycle-README-source-arc (one-cycle arcs becoming common as README/source pairs land adjacent)
- Three-cycle confirmation of role-label / monorepo-docs / Hardened-JS-absent disciplines

## Next cycle pacing

Cycle 328 is chat-lane next. Candidate moves:

- **@endo/marshal source files** — would introduce an eleventh package (cycle 325 cited marshal as "Serialization" role-label).
- **@endo/exo README.md** — designs-lane; defer.
- **@endo/promise-kit source or README** — would introduce an eleventh package (cycle 152 ingested memo-race.js from promise-kit).
- **@endo/init or @endo/common** — smaller foundational packages; would introduce eleventh.

@endo/marshal source is the most productive (would introduce eleventh package; closes cycle 325 Serialization role-label arc; @endo/marshal has many comment-fragments already in library: cycles 69 + 74 + 81 + 144 + 148 + 160; potential for multiple arc closures). Picking freely but tracking for future work.
