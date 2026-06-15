---
title: "@endo/patterns README.md — three Why-X-sections; Key/Pattern/Passable ASCII hierarchy tree; M-namespace six-categories; closes 326→327 in 1 cycle (third one-cycle arc)"
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
---

# `@endo/patterns README.md` — three Why-X-sections; type-hierarchy tree

The 415-line README for `@endo/patterns` — the pattern matching and validation layer. Cycle 327 is **designs-lane after cycle 326's chat-lane @endo/patterns/index.js**. **Eighteenth consecutive non-garden source after the pivot** (cycles 310-327). **§eighteen-cycles-with-named-pivot-domain-stay**. **Tenth package extends** (patterns; index.js → README adjacent-reverse pair, mirroring lp32 315-316).

**§the-named-citation-arc-from-cycle-326-takes-1-cycle-to-close** — cycle 326 was patterns' barrel index; cycle 327 is the README. **Third one-cycle README→source arc closure in the pivot**:
- 323 README → 324 atomics.js (1 cycle)
- 325 README → 326 index.js (1 cycle)
- 326 index.js → 327 README (1 cycle; reverse direction)

**§three-cycles-with-named-one-cycle-README-source-arc** (323→324 + 325→326 + 326→327). **§sixteen-citation-arc-closures-in-pivot-now**.

## The single most structurally interesting move

**§the-named-three-Why-X-sections-in-one-README** — the README has *three* "Why X?" sections that explicitly justify design choices vs natural alternatives:

| Section | Where | Question | Answer |
|---|---|---|---|
| Why not use JavaScript Set? | Line 200-202 | Why CopySet over native Set? | Sets aren't passable; CopySet is frozen + comparable via keyEQ + efficiently serialized |
| Why not use plain objects? | Line 245-249 | Why CopyMap over plain objects? | Any Key as key (not just strings) + efficient compareKeys + subset relationships |
| Why partial order? | Line 367-371 | Why compareKeys returns NaN sometimes? | Different remotables have no ordering; CopySets use subset relationships |

**§the-named-Why-X-section-discipline** — first-explicit-observation as a *documentation discipline*. Each Why-section:
1. Names the natural alternative the reader might reach for
2. Explains why the package chose otherwise
3. Lists the properties the chosen design provides
4. Anticipates the reader's objection and disarms it

**§the-named-comparative-justification-by-anticipated-objection** — the README treats the *reader's likely confusion* as a structural feature of the document and addresses it directly. Sibling to cycle 325's **§the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere** (which named what THIS package doesn't do); a Why-section names what THIS package DOES that an alternative doesn't. Together they form **§the-named-comparative-discipline**: explicitly position the package against alternatives.

## §the-named-Key-Pattern-Passable-hierarchy-tree

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

## §the-named-M-namespace-as-canonical-builder

The M object provides *all* pattern matchers, organized into six categories:

| Category | Examples |
|---|---|
| Primitive | `M.any()`, `M.boolean()`, `M.number()`, `M.bigint()`, `M.nat()`, `M.gte(5)` |
| Container | `M.array()`, `M.record()`, `M.set()`, `M.bag()`, `M.map()`, `M.arrayOf(M.number())` |
| Structured | `M.splitArray(...)`, `M.splitRecord(...)`, `M.partial(...)`, `M.split(...)` |
| Logical | `M.and(...)`, `M.or(...)`, `M.not(...)`, `M.opt(...)` |
| Comparison | `M.eq(...)`, `M.neq(...)`, `M.lt(...)`, `M.lte(...)`, `M.gte(...)`, `M.gt(...)` |
| Special | `M.remotable()`, `M.error()`, `M.promise()`, `M.eref(...)`, `M.kind('copyArray')`, `M.pattern()`, `M.key()`, `M.scalar()` |

**§the-named-six-categories-of-M-matchers** — the README organizes ~40 matchers into six categories. The categorization makes the surface legible at a glance. First-explicit-observation.

**§the-named-required-optional-rest-tripartite** (line 89-100) — `M.splitArray` / `M.splitRecord` both take three arguments: (required, optional, rest). The tripartite pattern recurs across both array and record forms. **§the-named-three-argument-canonical-shape**. First-explicit-observation.

**§the-named-eref-IS-named-eventual-reference** (line 140) — `M.eref(M.number())` matches *number or promise for number*. This is the **resolution axis** of cycle 321's cartesian product (locality × resolution), packaged as a matcher. **§the-named-eref-matches-value-or-promise-for-value** — the matcher generalizes the (Value | Promise) dimension. First-explicit-observation. Combined with `M.remotable()` (locality axis), the patterns surface lets a guard match *any* of the cycle-321 four target cases.

## Other notable observations

- **§the-named-Quick-Start-shows-error-output** (line 22-33) — the Quick Start example *fails on purpose* to show what the error message looks like: `'bar?: number 4 - Must be a string'`. First-explicit-observation. The reader sees both the API usage AND the error shape they'll get when validation fails. §the-named-error-output-IS-named-part-of-the-quick-start; §the-named-fail-on-purpose-discipline.

- **§the-named-call-vs-callWhen-distinction** (line 263-272) — `M.call(...)` is the synchronous method guard; `M.callWhen(...)` is the async method guard that *awaits* its arguments before validating. §the-named-callWhen-IS-named-async-method-guard.

- **§the-named-chained-method-guard-builder** — `M.call(M.string()).optional(M.number()).rest(M.any()).returns(M.string())` — fluent chained builder. §the-named-builder-pattern-for-method-guards.

- **§the-named-defensive-programming-IS-named-discipline** (line 318-319) — *"This is the foundation of defensive programming in Endo: guards validate inputs automatically, so your methods can focus on business logic."* Names the discipline. First-explicit-observation as a named-discipline-statement.

- **§the-named-distributed-equality-semantics** (line 327) — *"Tests if two Keys are equal using **distributed equality semantics**"* — the phrase distributed-equality-semantics names equality as a *protocol-level* property, not an implementation detail. **§the-named-equality-IS-named-protocol-not-implementation**. First-explicit-observation.

- **§the-named-partial-order-not-total-order** (line 343-371) — `compareKeys` returns 0 / -1 / 1 / **NaN** for incomparable. **§the-named-NaN-as-named-incomparable** — the JS-language NaN (a number that doesn't equal itself) is repurposed as the "no defined ordering" return value. First-explicit-observation. The Why-partial-order section justifies the design.

- **§the-named-bigint-for-arbitrary-precision-counts** (line 211-215) — CopyBag uses `5n`, `3n`, `7n` (bigints) for counts, not regular numbers. **§the-named-counts-combine-on-duplicate-keys** — `[['apples', 5n], ['apples', 2n]]` becomes `[['apples', 7n]]`. First-explicit-observation. Compare to cycle 311 @endo/nat which used bigint for non-negative integers generally.

- **§the-named-Integration-with-Endo-Packages-with-role-labels** (line 397-404) — Foundation (pass-style) + Enforcement (exo) + Communication (eventual-send). **§three-cycles-with-named-role-label-before-package-name** (321 + 325 + 327; meta-pattern confirmed across three cycles).

- **§the-named-Complete-Tutorial-link** (line 406-408) — `[Message Passing](../../docs/message-passing.md)`. **§three-cycles-with-named-monorepo-docs-reference** (321 + 325 + 327).

- **§the-named-Deep-Dives-section** (line 410-415) — two internal docs (marshal-vs-patterns-level + types.ts). **§two-cycles-with-named-Deep-Dives-IS-named-implementation-detail-section** (325 + 327).

- **§the-named-no-Hardened-JavaScript-section** — like cycle 325 pass-style (no section because pass-style *defines* hardening for its scope), the patterns README has no Hardened-JS section. **§three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken** (323 + 325 + 327). For patterns, the foundation in pass-style is implicit via the role-label citation.

- **§the-named-Endo-reference-docs-link** (line 35-36) — *"For best rendering, use the Endo reference docs site"* — points readers to a *separate rendering venue* for better experience. **§the-named-rendering-disclaimer-with-link-to-docs-site**. First-explicit-observation.

- **§the-named-makeTagged-implements-CopySet-CopyBag-CopyMap** (line 180) — *"Patterns introduces three passable collection types built on `makeTagged()`"*. Closes cycle 325 arc (which named makeTagged as extension-point).

## Patterns the cycle extends

- §eighteen-cycles-with-named-pivot-domain-stay (310-327)
- §sixteen-citation-arc-closures-in-pivot-now (added 326 → 327 = 1 cycle)
- §three-cycles-with-named-one-cycle-README-source-arc (323→324, 325→326, 326→327)
- §three-cycles-with-named-role-label-before-package-name (321 + 325 + 327)
- §three-cycles-with-named-monorepo-docs-reference (321 + 325 + 327)
- §three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken (323 + 325 + 327)
- §two-cycles-with-named-Deep-Dives-IS-named-implementation-detail-section (325 + 327)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability observations:

- **§the-named-three-Why-X-sections-in-one-README** with the Why-section discipline
- **§the-named-comparative-justification-by-anticipated-objection**
- **§the-named-Key-Pattern-Passable-hierarchy-tree** with **§the-named-Pattern-IS-itself-Passable** (Patterns are Passable; can be shipped to where data is)
- **§the-named-visualization-shape-matches-structural-relationship** (table for parallel; tree for containment)
- **§the-named-six-categories-of-M-matchers** with **§the-named-required-optional-rest-tripartite**
- **§the-named-distributed-equality-semantics** and **§the-named-NaN-as-named-incomparable**
- **§the-named-Quick-Start-shows-error-output** (fail-on-purpose discipline)
- **§the-named-defensive-programming-IS-named-discipline**

## Tier-2 borrowing (multi-cycle patterns extended)

- §eighteen-cycles-with-named-pivot-domain-stay
- §sixteen-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-one-cycle-README-source-arc (323→324, 325→326, 326→327)
- §three-cycles-with-named-role-label-before-package-name (321 + 325 + 327)
- §three-cycles-with-named-monorepo-docs-reference (321 + 325 + 327)
- §three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken (323 + 325 + 327)
- §two-cycles-with-named-Deep-Dives-IS-named-implementation-detail-section (325 + 327)

## Tier-3 borrowing (meta-patterns)

- **§the-named-Why-X-section-discipline** — anticipate reader objections and address them directly; name the natural alternative + chosen design + properties
- **§the-named-comparative-justification-by-anticipated-objection** — documentation as dialogue with the reader's likely confusion
- **§the-named-Pattern-IS-itself-Passable** — patterns are first-class data; they can be shipped to where the data is; load-bearing for distributed validation
- **§the-named-visualization-shape-matches-structural-relationship** — table for parallel; tree for containment; choose the visualization that mirrors the structure
- **§the-named-distributed-equality-semantics** — equality is a protocol-level property, not an implementation detail
- **§the-named-NaN-as-named-incomparable** — JS-language NaN repurposed for "no defined ordering"
- **§the-named-fail-on-purpose-discipline** — Quick Start examples that fail to show what errors look like
- **§the-named-eref-IS-named-eventual-reference** — encode the (Value | Promise) axis of cycle 321's cartesian product as a single matcher
- **§the-named-defensive-programming-IS-named-discipline** — name the discipline the package supports

## Synthesis-target

Slot machine library **§`@game/patterns/README.md`** — pattern-matching for game data validation:

1. **Quick Start that fails on purpose** to show what the error message looks like
2. **M-namespace as canonical builder** with six (or fewer) categories of matchers
3. **Required-optional-rest tripartite** for split patterns
4. **Why X? sections** explicitly justifying design choices vs natural alternatives
5. **ASCII tree for type hierarchy** if the type system has containment relationships
6. **Table for parallel types** (like cycle 325 pass-style); **tree for hierarchical** (this cycle)
7. **Pattern-IS-itself-Passable**: patterns can be shipped to where data is for distributed validation
8. **Distributed equality semantics** named explicitly as a protocol-level property
9. **NaN-as-incomparable** for partial-order comparators
10. **Integration with role labels** for cross-package citations
11. **Defensive programming named as discipline** explicitly
12. **Deep Dives section** pointing to implementation-detail docs
13. **No Hardened-JS section** if the foundation is via citation to a pass-style-equivalent
14. **Quick Start error output IS named-part-of-quick-start**

## Library state after cycle 327

- §library-reaches-839-sections from 375 source documents
- §one-hundred-and-sixtieth consecutive designs-chat alternation
- §eighteen-cycles-with-named-pivot-domain-stay
- §ten-named-packages-in-the-pivot-cluster (unchanged; patterns extends)
- §sixteen-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-one-cycle-README-source-arc (323→324, 325→326, 326→327)
- §three-cycles-with-named-role-label-before-package-name (multi-cycle confirmation as a recurring discipline)
- §three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken (third break for third reason: cycle 327 has implicit-via-citation-to-pass-style)
