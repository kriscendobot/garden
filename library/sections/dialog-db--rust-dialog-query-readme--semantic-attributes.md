---
title: Semantic — Attributes
source: rust/dialog-query/README.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

Abstract: An **attribute** is a relation elevated with domain-specific invariants — it extends the `domain/name` identifier with a value type and cardinality. It is defined as a newtype wrapping a value type via `#[derive(Attribute)]`: the **domain** derives from the enclosing module name (underscores become hyphens) and the **name** from the struct name (converted to kebab-case), so `mod employee { struct Name(String) }` yields `employee/name`. `#[domain("...")]` overrides the module-derived domain (e.g. `io.gozala/account-id`). By default an attribute has **cardinality one** (an entity has at most one value, so a new assert replaces the prior claim); `#[cardinality(many)]` makes it accumulate. `Attribute::of(entity).is(value)` constructs a statement to `assert` or `retract` on a `Session` edit. This is the crate-doc Rust derive-macro surface for the attribute model.

## Attributes

An attribute is a relation elevated with domain-specific invariants. It extends the `domain/name` identifier with a value type and cardinality, specifying what kind of values the association admits and how many.

An attribute is defined as a newtype wrapping a value type. The **domain** is derived from the enclosing module name (underscores become hyphens), and the **name** from the struct name (converted to kebab-case):

```rs
mod employee {
    /// Person's given name
    #[derive(Attribute, Clone)]
    pub struct Name(pub String);   // -> "employee/name"

    /// Job title or function
    #[derive(Attribute, Clone)]
    pub struct Role(pub String);   // -> "employee/role"
}
```

The domain can be overridden with `#[domain(...)]` when the module name doesn't match the desired domain:

```rs
mod model {
    /// Person's given name
    #[derive(Attribute, Clone)]
    #[domain("employee")]
    pub struct Name(pub String);       // -> "employee/name" (not "model/name")

    /// Account identifier
    #[derive(Attribute, Clone)]
    #[domain("io.gozala")]
    pub struct AccountId(pub String);  // -> "io.gozala/account-id"
}
```

By default an attribute has **cardinality one**, an entity has at most one value for it. Use `#[cardinality(many)]` when an entity can have multiple values:

```rs
mod employee {
    /// Skills associated with the employee
    #[derive(Attribute, Clone)]
    #[cardinality(many)]
    pub struct Skill(pub String);  // -> "employee/skill" (many)
}
```

> Note: cardinality affects whether an existing claim is retracted when a new one is asserted. Cardinality one implies replacement, cardinality many accumulates.

`Attribute::of(...).is(...)` constructs a statement that can be asserted or retracted:

```rs
let mut session = Session::open(artifacts);
let mut edit = session.edit();

// Assert single attributes
edit.assert(employee::Name::of(alice.clone()).is("Alice"));
edit.assert(employee::Role::of(alice.clone()).is("cryptographer"));

session.commit(edit).await?;

// Retract a single attribute
let mut edit = session.edit();
employee::Name::of(alice).is("Alice").retract(&mut edit);
session.commit(edit).await?;
```

Source: [rust/dialog-query/README.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/rust/dialog-query/README.md) at commit `ebd8f73`.
