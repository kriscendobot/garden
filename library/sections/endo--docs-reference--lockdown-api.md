---
title: lockdown(options) API
source: docs/reference.md
source_repo: endojs/endo
source_commit: bffadcab8a39be8529406b22574e25cf64dec755
source_date: 2026-04-26
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: Signature and brief semantics of lockdown(): idempotent (subsequent calls are no-ops), accepts an options object whose fields and defaults are documented in docs/lockdown.md. Calling lockdown() turns the start compartment into a SES-shape realm; cannot be undone. Distinct from repairIntrinsics()/hardenIntrinsics() (the lower-level building blocks).

## `lockdown(options)`

Lockdown performs two operations and these can be separated by calling
`repairIntrinsics(options)` and `hardenIntrinsics()`.
They collectively prepare a realm for safe execution of code in compartments.

These methods do not erase any powerful objects from the initial global scope. Instead,
Compartments give complete control over what powerful objects exist for client code.


Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md) at commit `bffadcab`.
