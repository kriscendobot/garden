---
title: §the-3-priority-resolution-order in moduleMapHook (first-explicit-observation)
section-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
source-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/compartment-mapper/designs/subpath-pattern-replacement.md
authors: [Endo project (collective)]
status: (no explicit metadata table)
ingest-cycle: 287
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 271
parent: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
---

> "The `moduleMapHook` resolves specifiers in this order:
> 1. **Concrete module descriptors** (exact matches, highest priority).
> 2. **Patterns** (wildcard replacement).
> 3. **Scope descriptors** (package-scope resolution, lowest priority)."

**§the-three-priority-tiers-in-named-explicit-order** — a numbered priority list where each item's priority is named and the fall-through ordering IS the design contract. §the-fall-through-order-IS-the-named-resolution-policy.

§the-three-priority-tiers-pair-with-Rule-3 (Exact entries take precedence over pattern entries) — Rule 3 maps to **tier 1 over tier 2**; the implementation realizes the upstream spec's priority order via the moduleMapHook's resolution order.
