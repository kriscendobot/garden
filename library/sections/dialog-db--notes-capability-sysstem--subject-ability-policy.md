---
title: Subject, ability, and policy
source: notes/capability-sysstem.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [capability-security, ucan-authorization]
status: current
---

> Abstract: A Dialog capability is `subject x command x policy`, each layer narrowing authority and each corresponding to a field of a [UCAN delegation]. The **subject** is the resource the capability is bound to — in Dialog a repository identified by a [did:key]; unconstrained access is `cmd: "/"` with an empty policy. An **ability** restricts the command path (an `Archive` ability yields `cmd: "/archive"`), modeled in Rust as `Access<Archive, RepositoryAccess>`. A **policy** restricts invocation arguments (a `Catalog { catalog }` policy yields a `pol` predicate `["==", ".catalog", "index"]`), modeled as `Access<Catalog, ArchiveAccess>`. The Rust type layering (`Access<Inner, Outer>`, `Delegation<Access>`, `Claim<Access>`) mirrors the UCAN delegation chain exactly.

Every capability is bound to a specific **subject** resource; complete unrestricted access is denoted by unconstrained delegation. In Dialog such a resource is a repository identified by a [did:key] identifier.

```rust
/// Repository access is unconstrained by anything
/// other than subject repository did
type RepositoryAccess = Subject;
type Repository = Delegation<RepositoryAccess>;
```

which corresponds to (and can be serialized as) a [UCAN delegation]:

```json
{ "cmd": "/", "sub": "did:key:zSpace", "pol": [],
  "iss": "did:key:zAlice", "aud": "did:key:zBob", "exp": null }
```

An **ability** constrains the capability by restricting which commands can be invoked. An `Archive` ability implementing the `Ability` trait adds `archive` to the `cmd` path:

```rust
struct Archive;
impl Ability for Archive {}
type ArchiveAccess = Access<Archive, RepositoryAccess>;
type RepositoryArchive = Delegation<ArchiveAccess>;
```

→ `"cmd": "/archive"` in the corresponding UCAN delegation.

A **policy** restricts invocation arguments. A `Catalog { catalog: String }` policy implementing the `Policy` trait restricts archive access to a named catalog:

```rust
struct Catalog { catalog: String }
impl Policy for Catalog {}
type CatalogAccess = Access<Catalog, ArchiveAccess>;
type ArchiveCatalog = Delegation<CatalogAccess>;
```

→ `"pol": [["==", ".catalog", "index"]]` in the UCAN delegation.

The `Access<Inner, Outer>` type-nesting composes the three layers, and each nesting corresponds to one link in the UCAN delegation chain: the subject is the `sub`, the ability accretes the `cmd` path, and the policy adds `pol` predicates. Narrowing is monotone — a delegate can restrict further (equal-or-more-restrictive) but never widen.

Source: [notes/capability-sysstem.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/capability-sysstem.md) at commit `f777fe7c`.

[did:key]: https://w3c-ccg.github.io/did-key-spec/
[UCAN delegation]: https://github.com/ucan-wg/delegation
