---
source: notes/scope-and-delegation.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: A design note (future work, not yet implemented) for capability scoping and delegation. Capabilities are always rooted in a `Subject(Did)`, so a delegation scope like "access to archive/catalog/index" cannot be expressed without naming the repository DID upfront. The proposal introduces `Any` as an alternative chain root alongside `Subject`, parameterizes `Constraint` by the root (a chain terminates with whatever root it was given), and adds a `Scope<T> = Capability<T, Any>` alias so wildcard-rooted delegation-only chains are type-distinct from subject-rooted invocable chains — `invoke`/`perform`/`fork` compile only on the latter. The `Ability` trait gains an associated `Root` type and a `subject(&self) -> Option<&Did>`. Building and mapping: attenuate from `Any` to build a scope, and map `Any`→UCAN `Subject::Any`, `Subject(did)`→`Subject::Specific(did)`, ability path→UCAN command, policy constraints→UCAN policy predicates.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-current-state](../sections/dialog-db--notes-scope-and-delegation--problem-and-current-state.md) | ucan-authorization | current |
| [proposed-any-rooted-scopes](../sections/dialog-db--notes-scope-and-delegation--proposed-any-rooted-scopes.md) | ucan-authorization | current |
| [usage-and-ucan-mapping](../sections/dialog-db--notes-scope-and-delegation--usage-and-ucan-mapping.md) | ucan-authorization | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `18c640a0` (2026-07-05), authored by Irakli Gozalishvili. Describes future work — the type-level parameterization is not yet implemented; today `Subject::any()` (a `did:_:_` wildcard) and `UcanSubject::Any` stand in.
- Ingested in the `scholar-ingest-dialog-db-remainder-3` follow-on cycle (2026-07-06), part of the rules/scope cluster.
