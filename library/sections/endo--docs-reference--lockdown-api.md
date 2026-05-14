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
status: superseded
superseded_by: endo--docs-guide--api-overview
superseded_on: 2026-05-14
superseded_reason: Cluster B consolidation (per the cycle-15 review and the cycle-30 maintainer-discretion mandate). The guide's api-overview consolidates all four API verbs with more context; this short standalone reference adds no information beyond the consolidated view. For exhaustive option-level detail consult endo--docs-lockdown--*.
---

> Abstract: Signature and brief semantics of lockdown(): idempotent (subsequent calls are no-ops), accepts an options object whose fields and defaults are documented in docs/lockdown.md. Calling lockdown() turns the start compartment into a SES-shape realm; cannot be undone. Distinct from repairIntrinsics()/hardenIntrinsics() (the lower-level building blocks).

## `lockdown(options)`

Lockdown performs two operations and these can be separated by calling
`repairIntrinsics(options)` and `hardenIntrinsics()`.
They collectively prepare a realm for safe execution of code in compartments.

These methods do not erase any powerful objects from the initial global scope. Instead,
Compartments give complete control over what powerful objects exist for client code.


Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md) at commit `bffadcab`.
