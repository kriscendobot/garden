---
title: Capability scoping — the problem and current subject-rooted state
source: notes/scope-and-delegation.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
notes: Design describes future work; the type-level parameterization is not yet implemented (see Status).
---

> Abstract: A design note (future work — not yet implemented; currently `Subject::any()` creates a wildcard subject with `did:_:_` and the UCAN layer uses `UcanSubject::Any`). The problem: capabilities are always rooted in a `Subject(Did)`, so "access to archive/catalog/index" cannot be expressed without knowing the repository DID upfront — yet delegation scoping needs exactly that, describing *what kind* of access without naming *which resource*. In the current state every capability chain starts with `Subject`, e.g. `Subject(repo_did) -> Archive -> Catalog("index") -> Get { key }`; `Attenuation::Of` walks up to `Subject`, `Constraint` computes the full chain type from the leaf, and the `Ability` trait requires `fn subject(&self) -> &Did`, with `Subject::any()` returning a `did:_:_` subject for wildcards.

## Status

This describes future work. Currently `Subject::any()` creates a wildcard subject with `did:_:_`, and the UCAN layer uses `UcanSubject::Any`. The type-level parameterization described below has not been implemented.

## Problem

Capabilities are always rooted in a `Subject(Did)`. This means you can't express "access to archive/catalog/index" without knowing the repository DID upfront. But delegation scoping needs exactly that: describing *what kind* of access without naming *which resource*.

## Current State

Every capability chain starts with `Subject`:

```
Subject(repo_did) -> Archive -> Catalog("index") -> Get { key }
```

`Attenuation::Of` walks up to `Subject`:
```rust
impl Attenuation for Archive { type Of = Subject; }
impl Attenuation for Catalog { type Of = Archive; }
```

`Constraint` computes the full chain type from the leaf:
```rust
type Capability<Fx> = <Fx as Constraint>::Capability;
// Capability<Get> = Constrained<Get, Constrained<Catalog, Constrained<Archive, Subject>>>
```

`Ability` trait requires `fn subject(&self) -> &Did`. For wildcards, `Subject::any()` returns a subject with `did:_:_`.

Source: [notes/scope-and-delegation.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/scope-and-delegation.md) at commit `18c640a0`.
