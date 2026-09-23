---
title: Refinements — the `Refined` shape on the type lattice
source: notes/refinements.md
source_repo: dialog-db/dialog-db
source_commit: d8c90b907a6c726e3db38199cb1b9908ddbfc64d
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: `type_system::Type` gains a third shape, `Refined(Primitive, Refinement)`, where `Refinement` holds a non-empty lexical `prefix` over TEXTUAL members. A refined type admits a value when its membership admits the value's type *and* the refinement admits the value itself (`Type::admits` checks both, so every existing admits-site — scans included — enforces refinements with no new code). The lattice operations treat a refinement as a constraint: **meet** (`intersect`) keeps the longer of two prefixes when one extends the other (disjoint prefixes are an empty meet, the ordinary known-types-misalign compile error), and a refined side admits no composite shapes so composites drop; **join** (`union`) is the longest common prefix, or no refinement when joined with an unrefined side; **inclusion** is constraint-ordered (`[prefix "did:"]` includes `[prefix "did:key:"]`; unrefined includes refined, never the reverse). `Refinement` is a struct, not an enum, so dialog-db-57's numeric intervals and M3's Entity concept-membership extend it with fields rather than new lattice variants. One load-bearing unifier fix: variable resolution now rebuilds around the merged membership preserving the type's structure (`Type::with_primitive_part`) rather than reconstructing from the merged primitive set, which would have shed the refinement.

## The lattice layer

`type_system::Type` gains a third shape:

```rust
enum Type {
    Primitive(Primitive),
    Composite(Primitive, BTreeSet<Composite>),
    Refined(Primitive, Refinement),
}

struct Refinement {
    prefix: String,   // non-empty; lexical prefix over TEXTUAL members
}
```

A refined type admits a value when its membership admits the value's type *and* the refinement admits the value itself (`Type::admits` checks both — so every existing admits-site, scans included, enforces refinements with no new code). The lattice operations treat a refinement as a constraint:

- **Meet** (`intersect`): the conjunction. Two prefixes are jointly satisfiable iff one extends the other; the meet keeps the longer. Disjoint prefixes are an empty meet — the ordinary known-types-misalign compile error. A refined side admits no composite shapes, so composites on the other side drop out of the meet.
- **Join** (`union`): the weakest common implication — the longest common prefix, or no refinement at all when joined with an unrefined side (the union must admit everything either side admits).
- **Inclusion**: constraint-ordered. `[prefix "did:"]` includes `[prefix "did:key:"]`; unrefined includes refined; never the reverse.

`Refinement` is a struct, not an enum, so numeric intervals (dialog-db-57's consumer) and M3's Entity concept-membership extend it with fields rather than new lattice variants; the meet/join shape stays put.

The `starts-with` schema attaches the refinement to its subject slot's content type, and the generic schema walk plus the unifier's principal meet do the rest — no inference changes. One unifier fix was load-bearing: variable resolution used to *reconstruct* the resolved static from the merged primitive set, which would have silently shed the refinement; resolution now rebuilds around the merged membership preserving the type's structure (`Type::with_primitive_part`).

Source: [notes/refinements.md](https://github.com/dialog-db/dialog-db/blob/d8c90b907a6c726e3db38199cb1b9908ddbfc64d/notes/refinements.md) at commit `d8c90b90`.
