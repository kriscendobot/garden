---
title: Defining attributes and concepts
source: notes/concept.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: An **attribute** is a newtype wrapping a value type; its identity is the triple `(the, type, cardinality)` where `the` is a nominal identifier in `domain/name` format. The `the` carries semantic meaning beyond structure — `employee/name` and `employee/role` may both wrap `String` with cardinality one, yet stay distinct because their `the` denotes different relations. In the Rust API the domain derives from the enclosing module name and the name from the struct name (overridable with `#[domain(...)]`); default cardinality is one, `#[cardinality(many)]` marks multi-valued attributes. A **concept** struct groups attributes with a required `this: Entity` field; a concept's identity derives from the sorted set of its constituent attribute identities, not its Rust struct name, so two concepts with the same attribute set are structurally equivalent regardless of naming.

An attribute is a newtype wrapping a value type. Its identity is the triple `(the, type, cardinality)` where `the` is a nominal identifier in `domain/name` format. The `the` carries semantic meaning beyond structure: `employee/name` and `employee/role` may both wrap `String` with cardinality one, yet they remain distinct because their `the` denotes different relations.

```rs
mod employee {
    /// Person's given name
    #[derive(Attribute, Clone, PartialEq)]
    pub struct Name(pub String);   // -> "employee/name"

    /// Job title or function
    #[derive(Attribute, Clone, PartialEq)]
    pub struct Role(pub String);   // -> "employee/role"
}
```

The **domain** is derived from the enclosing module name (underscores become hyphens), and the **name** from the struct name (converted to kebab-case). `#[domain("...")]` overrides the domain (so a struct in `mod model` can still map to `employee/name`, or to a reverse-DNS domain like `io.gozala/account-id`). By default attributes have **cardinality one** (at most one value per entity); `#[cardinality(many)]` marks multi-valued attributes (`employee/skill`).

A concept struct groups attributes together with a required `this: Entity` field. Every field except `this` must be an `Attribute` type.

```rs
#[derive(Concept, Debug, Clone, PartialEq)]
pub struct Employee {
    pub this: Entity,
    pub name: employee::Name,
    pub role: employee::Role,
}
```

A concept's identity derives from the **sorted set of its constituent attribute identities**, not from its Rust struct name. Two concepts with the same attribute set are structurally equivalent regardless of naming. The `#[derive(Concept)]` macro generates the boilerplate needed to query and transact at this granularity.

Source: [notes/concept.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/concept.md) at commit `f777fe7c`.
