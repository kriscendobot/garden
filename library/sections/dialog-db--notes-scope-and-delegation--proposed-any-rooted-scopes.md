---
title: Proposed design — `Any` as a wildcard chain root, parameterized by `Constraint`
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

> Abstract: The proposed (future) design introduces `Any` — `pub struct Any;` — as an alternative chain root alongside `Subject`, and parameterizes `Constraint` by the root so a chain terminates with whatever root it was given (`impl<Root> Constraint<Root> for Subject { type Capability = Root; }`). A convenience alias `pub type Scope<T> = Capability<T, Any>;` distinguishes subject-rooted invocable chains (`Capability<Catalog>`, backward compatible) from wildcard-rooted delegation-only chains (`Scope<Catalog>`). Compile-time safety: `invoke`/`perform`/`fork` are only available on subject-rooted chains (`Of: Ability<Root = Subject>`), so `Any`-rooted chains compile for building and reading but cannot be invoked. The `Ability` trait gains an associated `type Root` propagated from the chain root and changes `subject(&self)` to return `Option<&Did>` (`None` for `Any`-rooted).

### `Any` as Wildcard Root

Introduce `Any` as an alternative chain root alongside `Subject`:

```rust
pub struct Any;  // wildcard: represents any subject
```

### Parameterize `Constraint` by Root

```rust
impl<T: Policy, Root> Constraint<Root> for T {
    type Capability = Constrained<T, <T::Of as Constraint<Root>>::Capability>;
}

impl<Root> Constraint<Root> for Subject {
    type Capability = Root;  // terminates with whatever root was given
}
```

### Convenience Alias

```rust
pub type Scope<T> = Capability<T, Any>;
```

- `Capability<Catalog>` -- subject-rooted, invocable (backward compatible)
- `Scope<Catalog>` -- wildcard-rooted, delegation scope only

### Compile-Time Safety

`invoke`/`perform`/`fork` only available on subject-rooted chains:

```rust
impl<Fx, Of> Constrained<Fx, Of>
where
    Fx: Effect,
    Of: Ability<Root = Subject>,  // only Subject-rooted chains
{
    pub fn invoke(...) { ... }
    pub async fn perform(...) { ... }
}
```

`Any`-rooted chains compile for building and reading but cannot be invoked.

### `Ability` Changes

```rust
pub trait Ability {
    type Root;  // Subject or Any, propagated from chain root
    fn subject(&self) -> Option<&Did>;  // None for Any-rooted
    fn ability(&self) -> String;
}
```

Source: [notes/scope-and-delegation.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/scope-and-delegation.md) at commit `18c640a0`.
