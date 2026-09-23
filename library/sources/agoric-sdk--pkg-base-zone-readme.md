---
source: packages/base-zone/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d4729735e3ce04b146f8982e6b537e86546bc8b
source_date: 2024-01-27
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
section_count: 1
status: current
notes: The README explicitly flags that `@agoric/base-zone` (and `@agoric/store`) will migrate to endo as `@endo/zone` and `@endo/store`; deprecated stubs will reexport from the new location. Flag for re-ingestion after the migration lands. Most consumers should use `@agoric/zone` rather than `@agoric/base-zone` directly.
---

> Abstract: Zones are the API for allocating Exo objects and Stores under one of three persistence regimes: ephemeral (JS heap, lost on vat termination), virtual (pageable to disk, lost on termination), durable (pageable AND revivable after vat upgrade). This package is the internal substrate; most consumers should use `@agoric/zone` instead. Pending migration to `@endo/zone`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-base-zone-readme--overview.md) | exo, capability-security | current |

## Source

[packages/base-zone/README.md](https://github.com/Agoric/agoric-sdk/blob/7d4729735e3ce04b146f8982e6b537e86546bc8b/packages/base-zone/README.md) at commit `7d472973`.
