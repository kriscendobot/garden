---
title: Subject, capability space, and ability paths
source: rust/dialog-capability/README.md
source_repo: dialog-db/dialog-db
source_commit: b4fb5ea9e23bfc515967353f485c3f19d00643be
source_date: 2026-02-12
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: In `dialog-capability`, a `Subject` is the root of every capability chain: it identifies a resource by DID and represents *full authority* — ability `/` with no policy constraints. Every subject defines a **capability space**, the full set of operations performable on that resource, organized as a hierarchy of **ability paths**. A path like `/storage` includes everything beneath it (`/storage/get`, `/storage/set`, ...), and the root `/` encompasses the entire space. Capabilities attenuate (narrow) the space: `/storage` grants all storage operations, `/storage/get` restricts to reads only. The path is a *prefix-inclusion* semantics — an ability includes all effects whose path starts with it. Policies are orthogonal to the path: they add parameters (which store, which key) that constrain how effects may be invoked without changing which effects are in scope. This is the concrete authorization semantics behind the notes-level "ability accretes the `cmd` path, policy adds `pol` predicates" framing.

## Subject

A `Subject` is the root of every capability chain — it identifies the resource (via a DID) and represents full authority: ability `/` with no policy constraints.

## Capability space

Every `Subject` defines a capability space — the full set of operations that can be performed on that resource. The space is organized as a hierarchy of ability paths:

```text
/                        (root — full authority)
/storage                 (all storage operations)
/storage/get             (only storage get)
/storage/set             (only storage set)
/memory                  (all memory operations)
/memory/publish          (only memory publish)
```

An ability path like `/storage` includes everything beneath it — `/storage/get`, `/storage/set`, and so on. The root `/` encompasses the entire capability space.

Capabilities attenuate (narrow) this space. A capability with ability `/storage` grants access to all storage operations, while `/storage/get` restricts to just reads. Policies further constrain what is permitted within a given ability by adding parameters (which store, which key) without changing the ability path itself.

## Abilities and policies

A capability represents a set of invocable operations (effects), defined by:

- **Ability**: a path like `/storage` or `/storage/get` that determines which effects are included. An ability includes all effects whose path starts with it.
- **Policies**: parameters that constrain how effects can be invoked, without changing the ability path.

Source: [rust/dialog-capability/README.md](https://github.com/dialog-db/dialog-db/blob/b4fb5ea9e23bfc515967353f485c3f19d00643be/rust/dialog-capability/README.md) at commit `b4fb5ea9`.
