---
title: Building delegation scopes and mapping them to UCAN
source: notes/scope-and-delegation.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
notes: Design describes future work not yet implemented.
---

> Abstract: Under the proposed design a delegation scope is built by attenuating from `Any` — `let scope: Scope<Catalog> = Any.attenuate(Archive).attenuate(Catalog::new("index"));` — then passed to a builder as `profile.derive(b"alice").allow(scope).build(storage)`. The current (implemented) form of powerline delegation instead uses `.allow(Subject::any())`. The UCAN mapping: an `Any` root maps to UCAN `Subject::Any` (powerline delegation); a `Subject(did)` root maps to UCAN `Subject::Specific(did)`; the ability path maps to a UCAN command (e.g. `["archive", "catalog"]`); and policy constraints map to UCAN policy predicates.

## Usage

### Building Delegation Scopes

```rust
let scope: Scope<Catalog> = Any
    .attenuate(Archive)
    .attenuate(Catalog::new("index"));

// Use in builder
profile.derive(b"alice")
    .allow(scope)
    .build(storage)
    .await?;
```

### Powerline Delegation (current)

```rust
profile.derive(b"alice")
    .allow(Subject::any())
    .build(storage)
    .await?;
```

## UCAN Mapping

- `Any` root maps to UCAN `Subject::Any` (powerline delegation)
- `Subject(did)` root maps to UCAN `Subject::Specific(did)`
- Ability path maps to UCAN command (e.g., `["archive", "catalog"]`)
- Policy constraints map to UCAN policy predicates

Source: [notes/scope-and-delegation.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/scope-and-delegation.md) at commit `18c640a0`.
