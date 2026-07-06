---
title: The running example and the two layers (scalar facts, widening concepts)
source: notes/guide.md
source_repo: dialog-db/dialog-db
source_commit: 3cd6607aa9e6f70d65bafe7692e1a52b953e1faf
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The user-facing frame for optionality in `dialog-query`, built around one running example — three facts (`person/name alice "Alice"`, `person/nickname alice "Ali"`, `person/name bob "Bob"`): Alice has a nickname, Bob does not, and nothing in storage says "Bob has no nickname" because storage holds only facts that exist (no null, no `None`, nothing persisted for an absent value). The engine has two layers with different vocabularies. The **associative layer** is the raw EAV fact lookup — a premise `the(of, is)` that scans the indexes; it is *scalar*, a fact either matches or it does not, and a row that finds no fact is filtered out (asking it for nicknames yields only Alice, dropping Bob the way a SQL inner join would). There is no way to express "give me the nickname or tell me it is missing" at this layer, by design. The **semantic layer** is where concepts live and where optionality is expressed: a concept field declared `Option<T>` queries as an *optional lookup* (a left join, called "optional lookup" throughout), so every entity matching the required fields produces a row and the optional slot reports what the lookup found — Bob is not dropped, his `?nickname` binds to `Absent`.

This guide explains how optional values work in `dialog-query`: what `Absent` means, where it can appear, how the planner and the type inference treat it, and why the design is layered the way it is. It is written around one running example.

## The running example

Three facts in the store:

```text
the                of      is
person/name        alice   "Alice"
person/nickname    alice   "Ali"
person/name        bob     "Bob"
```

Alice has a nickname. Bob does not. Nothing in storage says "Bob has no nickname": storage holds only facts that exist. There is no null, no `None`, nothing is ever persisted for an absent value.

## Two layers: facts are scalar, concepts may widen

The engine has two layers with different vocabularies:

The **associative layer** is the raw fact lookup: a premise of the shape `the(of, is)` that scans the EAV indexes. It is *scalar*. A fact either matches or it does not, and a row that finds no fact is simply filtered out. Asking the associative layer for nicknames:

```rust
the!("person/nickname").of(person).is(nickname)
```

yields one row (Alice). Bob produces no row, the same way a SQL inner join drops him. There is no way to express "give me the nickname or tell me it is missing" at this layer, by design.

The **semantic layer** is where concepts live, and it is where optionality is expressed. A concept field declared `Option<T>`:

```rust
#[derive(Concept)]
struct Person {
    this: Entity,
    name: Name,                 // required
    nickname: Option<Nickname>, // optional ("maybe")
}
```

queries as an *optional lookup* (in SQL terms, a left join; this guide says "optional lookup" from here on): every entity matching the required fields produces a row, and the optional slot reports what the lookup found.

```text
?person   ?name     ?nickname
alice     "Alice"   Present("Ali")
bob       "Bob"     Absent
```

Bob is not dropped. His `?nickname` is bound to `Absent`.

Source: [notes/guide.md](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/guide.md) at commit `3cd6607a`.
