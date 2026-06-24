---
title: Agoric Vat Data (overview — vat, zone, turn, crank)
source: packages/vat-data/README.md
source_repo: agoric/agoric-sdk
source_commit: 31d74ec8e861efc48db473fd9b68820e4c0e3d55
source_date: 2023-01-29
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, capability-security, persistence]
status: current
notes: The turn / crank vocabulary is canonical across SwingSet, vat-data, and async-flow. The "all kinds in first crank" invariant is the upgrade-safety story: if restoration depended on external deliveries prompting a second crank, the vat would need to either accept arbitrary external messages or enter a partial-availability state, both of which break upgrade rollback.
kind: index
section_count: 2
---

> Abstract: Defines key vocabulary. A **vat** is a unit of isolation — objects/functions inside the same vat communicate synchronously; cross-vat communication is asynchronous only. The package provides three **zones** for persistence: heap (in memory, lost on termination), virtual (pageable to disk, lost on termination), durable (pageable AND revivable through vat upgrade and restart). A **turn** is everything between an empty stack and the next empty stack. A **crank** is everything between an empty stack-and-promise-queue and the next empty stack-and-promise-queue. The critical invariant: **all previous Kinds must be defined in the first crank** of a vat restart — otherwise a partial restoration would expose other vats to side effects that couldn't be unwound on failure.

Sections:

- [Agoric Vat Data](agoric-sdk--pkg-vat-data-readme--overview--agoric-vat-data.md)
- [Overview](agoric-sdk--pkg-vat-data-readme--overview--overview.md)

Source: [packages/vat-data/README.md](https://github.com/Agoric/agoric-sdk/blob/31d74ec8e861efc48db473fd9b68820e4c0e3d55/packages/vat-data/README.md) at commit `31d74ec8`.
