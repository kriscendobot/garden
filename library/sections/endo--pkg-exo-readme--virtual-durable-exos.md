---
title: Virtual and Durable Exos
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, daemon, persistence]
status: current
---

> Abstract: Exos can be virtual (state lives in a heap-managed store, not as a JS heap object) or durable (state survives across vat or daemon restarts). The defineDurableExoClass / defineDurableExoClassKit variants integrate with a baggage capability that persists state to durable storage. Required pattern for any agoric-sdk or Endo-daemon use that survives restarts.

## Virtual and Durable Exos

This package provides **heap-based exos** that don't survive vat termination.
For production systems with high cardinality or upgrade requirements, see:

- **[@agoric/vat-data](https://github.com/Agoric/agoric-sdk/tree/master/packages/vat-data)** -
  Provides:
  - `defineVirtualExoClass` - Backed by virtual object storage (pageable)
  - `defineDurableExoClass` - Survives vat upgrades
  - `prepareExoClass` - Unified API for both
  - `prepareExoClassKit` - Durable/virtual kits

- **[Exo Taxonomy](./docs/exo-taxonomy.md)** - Complete reference of all exo
  creation patterns including virtual and durable variants

The heap exos in this package are ideal for:
- Development and testing
- Low cardinality objects (< thousands)
- Temporary session state
- Non-critical services


Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
