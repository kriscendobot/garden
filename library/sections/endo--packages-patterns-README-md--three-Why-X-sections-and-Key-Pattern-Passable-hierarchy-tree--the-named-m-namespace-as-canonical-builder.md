---
title: §the-named-M-namespace-as-canonical-builder
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
