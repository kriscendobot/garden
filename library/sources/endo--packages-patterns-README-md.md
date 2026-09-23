---
title: "@endo/patterns README.md — adjacent-reverse pair with cycle 326 index.js; three Why-X-sections; Key/Pattern/Passable ASCII hierarchy tree; sixteen citation-arc closures total in pivot"
source-slug: endo--packages-patterns-README-md
url: https://github.com/endojs/endo/blob/master/packages/patterns/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/patterns/README.md
total-lines: 415
ingest-cycle: 327
ingest-date: 2026-06-15
lane: designs
---

# `@endo/patterns README.md`

The 415-line README for `@endo/patterns`. **Eighteenth consecutive non-garden source after the pivot** (cycles 310-327). **§eighteen-cycles-with-named-pivot-domain-stay**. **Tenth package extends** (patterns; index.js → README adjacent-reverse pair, mirroring lp32 315-316). Closes cycle 326 → 327 in 1 cycle — **third one-cycle README→source arc closure in the pivot** (323→324, 325→326, 326→327; cycle 326 is the source-side of the cycle 326↔327 pair, since 326 was a barrel index).

## Key moves

- **§the-named-three-Why-X-sections-in-one-README** — three explicit "Why X?" sections justifying design choices vs natural alternatives (Why not use JavaScript Set? + Why not use plain objects? + Why partial order?). **Single most structurally interesting move**. §the-named-Why-X-section-discipline; §the-named-comparative-justification-by-anticipated-objection; first-explicit-observation.
- **§the-named-Key-Pattern-Passable-hierarchy-tree** — 13-line ASCII tree (line 372-391) visualizes the entire type system. §the-named-Pattern-IS-itself-Passable (Patterns are first-class Passable data; can be shipped to where data is — load-bearing for distributed validation). §the-named-three-named-categories-Passable-Key-Pattern. §the-named-visualization-shape-matches-structural-relationship (table for parallel as in cycle 325; tree for containment as here).
- **§the-named-M-namespace-as-canonical-builder** with **§the-named-six-categories-of-M-matchers** (Primitive + Container + Structured + Logical + Comparison + Special). Closes cycle 326 arc (which named M as needing namespace-merge for typed declarations).
- **§the-named-required-optional-rest-tripartite** — `M.splitArray(required, optional, rest)` + `M.splitRecord(required, optional, rest)`; three-argument canonical shape recurring across both forms.
- **§the-named-eref-IS-named-eventual-reference** — `M.eref(M.number())` matches *number or promise for number*; encodes the (Value | Promise) axis of cycle 321's cartesian product as a single matcher; combined with `M.remotable()` covers all four cycle-321 target cases.
- **§the-named-Quick-Start-shows-error-output** — Quick Start example *fails on purpose* to show the error message verbatim (`'bar?: number 4 - Must be a string'`); §the-named-fail-on-purpose-discipline.
- **§the-named-call-vs-callWhen-distinction** — `M.call()` synchronous + `M.callWhen()` awaits-args.
- **§the-named-chained-method-guard-builder** — `M.call().optional().rest().returns()` fluent chain.
- **§the-named-defensive-programming-IS-named-discipline** (line 318-319: *"This is the foundation of defensive programming in Endo"*).
- **§the-named-distributed-equality-semantics** — equality as protocol-level property, not implementation detail; §the-named-equality-IS-named-protocol-not-implementation.
- **§the-named-partial-order-not-total-order** with §the-named-NaN-as-named-incomparable (JS NaN repurposed for "no defined ordering").
- **§the-named-bigint-for-arbitrary-precision-counts** in CopyBag; §the-named-counts-combine-on-duplicate-keys.
- **§the-named-Integration-with-Endo-Packages-with-role-labels** (Foundation pass-style + Enforcement exo + Communication eventual-send); **§three-cycles-with-named-role-label-before-package-name** (321 + 325 + 327).
- **§three-cycles-with-named-monorepo-docs-reference** (321 + 325 + 327; `../../docs/message-passing.md`).
- **§two-cycles-with-named-Deep-Dives-IS-named-implementation-detail-section** (325 + 327).
- **§three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken** (323 + 325 + 327; cycle 327's reason: implicit via citation to pass-style as "Foundation").
- **§the-named-Endo-reference-docs-link** — *"For best rendering, use the Endo reference docs site"* — separate rendering venue; §the-named-rendering-disclaimer-with-link-to-docs-site.
- **§eighteen-cycles-with-named-pivot-domain-stay**, **§sixteen-citation-arc-closures-in-pivot-now**, **§three-cycles-with-named-one-cycle-README-source-arc**.

## Section files

- [§the-named-three-Why-X-sections-in-one-README + §the-named-Key-Pattern-Passable-hierarchy-tree + §the-named-Pattern-IS-itself-Passable + §the-named-six-categories-of-M-matchers + 20+ more first-explicit-observations](../sections/endo--packages-patterns-README-md--three-Why-X-sections-and-Key-Pattern-Passable-hierarchy-tree.md) — full 415-line README in scope.

## Ingest scope

Cycle 327 (designs-lane after cycle 326's chat-lane @endo/patterns index.js). Full 415-line README in scope. Eighteenth consecutive @endo/* source; tenth package extends (patterns; index.js → README adjacent-reverse pair). Closes cycle 326 → 327 in 1 cycle (third one-cycle README↔source arc closure: 323→324 + 325→326 + 326→327). **First-explicit-observations** including §the-named-three-Why-X-sections-in-one-README, §the-named-Why-X-section-discipline, §the-named-comparative-justification-by-anticipated-objection, §the-named-Key-Pattern-Passable-hierarchy-tree, §the-named-ASCII-tree-for-type-hierarchy, §the-named-Pattern-IS-itself-Passable, §the-named-three-named-categories-Passable-Key-Pattern, §the-named-six-categories-of-M-matchers, §the-named-required-optional-rest-tripartite, §the-named-eref-IS-named-eventual-reference, §the-named-Quick-Start-shows-error-output, §the-named-call-vs-callWhen-distinction, §the-named-defensive-programming-IS-named-discipline, §the-named-distributed-equality-semantics, §the-named-NaN-as-named-incomparable, §the-named-bigint-for-arbitrary-precision-counts, §the-named-visualization-shape-matches-structural-relationship. Multi-cycle: §eighteen-cycles-with-named-pivot-domain-stay, §sixteen-citation-arc-closures-in-pivot-now, §three-cycles-with-named-one-cycle-README-source-arc, §three-cycles-with-named-role-label-before-package-name (321 + 325 + 327), §three-cycles-with-named-monorepo-docs-reference (321 + 325 + 327), §three-cycles-with-named-Hardened-JS-discipline-streak-continues-broken (323 + 325 + 327; cycle 327's reason: implicit via citation), §two-cycles-with-named-Deep-Dives-IS-named-implementation-detail-section (325 + 327).
