---
title: The three key traits — Policy, Attenuation, Effect
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

> Abstract: `dialog-capability` distinguishes three trait roles that a chain link can play, differing in what they constrain and whether they are invocable. A **`Policy`** constrains *parameters only* (no ability-path change) — `Store`, `Catalog`, `Cell`. An **`Attenuation`** constrains *ability path plus parameters* — `Storage`, `Memory`, `Archive` — narrowing which effects are in scope. An **`Effect`** constrains ability path plus parameters *and is invocable*, carrying a `type Output` — `Get`, `Set`, `Resolve`. A capability chain is therefore `Subject → (Attenuation | Policy)* → Effect`, where attenuations and policies interleave down to a terminal invocable effect. The crate's optional **`ucan`** feature adds UCAN (User Controlled Authorization Networks) support with IPLD serialization, which is how these in-memory typed chains become the offline-verifiable delegation tokens `dialog-ucan` transports.

## Capability hierarchy

Capabilities are built as chains:

```text
Subject ("did:key:z6Mk...")            -> ability: /
  |-- Attenuation (e.g., Storage)      -> ability: /storage
        |-- Policy (e.g., Store)       -> ability: /storage (unchanged)
              |-- Effect (e.g., Get)   -> ability: /storage/get
```

## Key traits

| Trait | Constrains | Example types |
|-------|------------|---------------|
| `Policy` | Parameters only | `Store`, `Catalog`, `Cell` |
| `Attenuation` | Ability + parameters | `Storage`, `Memory`, `Archive` |
| `Effect` | Ability + parameters, invocable | `Get`, `Set`, `Resolve` |

A `Policy` narrows how effects may be invoked without moving the ability path; an `Attenuation` moves the ability path deeper (and may also constrain parameters); an `Effect` is the invocable leaf, moving the path and declaring the `Output` type its invocation returns.

## Features

- `ucan` — enable UCAN (User Controlled Authorization Networks) support with IPLD serialization.

Source: [rust/dialog-capability/README.md](https://github.com/dialog-db/dialog-db/blob/b4fb5ea9e23bfc515967353f485c3f19d00643be/rust/dialog-capability/README.md) at commit `b4fb5ea9`.
