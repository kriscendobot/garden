---
title: "ADR 0001 (software-neutral lifecycle kernel): Consequences, rejected alternatives, and validation"
source: docs/decisions/0001-framework-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The neutral kernel buys cross-product lifecycle semantics and incremental, observable OVA rebase at the cost of contract-first work and dual execution; renaming OVA modules, keeping the framework inside OVA, a parity-free rewrite, and signature-as-build-authorization were rejected, and the boundary is enforced by dependency tests, fixtures, shadow comparison, and phase exit gates.

## Consequences

Positive consequences:

- Components created by any product receive the same first-class lifecycle treatment.
- Exact-source knowledge and model decisions remain auditable as dependencies change.
- OVA can rebase incrementally with observable parity and rollback.
- Other applications can adopt the framework without inheriting graphics/robotics policy.
- caches, packages, publications, and settings gain stable cross-product semantics.

Costs and risks:

- Phase 1 must define and test wire contracts before rapidly porting code.
- OVA requires a temporary compatibility layer and dual execution.
- some OVA identities cannot remain identical after canonicalization and need explicit
  mappings.
- true security enforcement, durable workflows, and self-hosting require more than the
  current prototype provides.
- two repositories and compatibility releases increase short-term operating cost.

## Rejected alternatives

### Rename and move OVA modules

Rejected because it preserves OVA foundation injection, eager indexing, fixed stages,
mutable package projections, Python build semantics, and storage/UI coupling.

### Keep the framework inside OVA

Rejected because dependency direction would remain wrong and other products would have
to import application policy to use general lifecycle contracts.

### Rewrite with no parity layer

Rejected because existing manifests, locks, caches, provenance, samples, and failure
semantics are part of the behavior to preserve or explicitly migrate.

### Use signatures as build authorization

Rejected because a signature proves source origin and integrity, not behavioral safety.
Classification and short-lived build authorization remain separate mandatory decisions.

## Validation

This decision is enforced by import/dependency tests, schema fixtures, neutral samples,
OVA shadow comparison, exact identity mapping, security adversarial tests, true
self-hosting, and the Phase 1/Phase 2 exit gates.

The reference implementation ecosystem and tooling isolation are decided separately in
[ADR 0002](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0002-reference-implementation-ecosystem.md).

Source: [docs/decisions/0001-framework-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0001-framework-boundary.md) at commit `fcc40bc` (source lines 51–100).
