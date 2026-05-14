---
title: Tips — Synchronous makers
source: packages/vat-data/README.md
source_repo: agoric/agoric-sdk
source_commit: 31d74ec8e861efc48db473fd9b68820e4c0e3d55
source_date: 2023-01-29
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, capability-security, persistence]
status: current
notes: This tip is a practical gotcha: any incoming message after vat-incarnation startup may target an exo from the previous incarnation, so the kind's behavior must be ready synchronously. Converting an async maker to sync is the rabbit-hole this section warns about. Same constraint surfaces in zoe's Upgrade Crank section and SwingSet's vat-upgrade docs.
---

> Abstract: Durable-kind maker functions are **synchronous**. When converting from an async maker, all needed data must be already available in the vat's `prepare` — no awaits. The reason is the load-bearing invariant: all `prepare`s happen in the **first crank** of the event loop. Once the successor vat-incarnation is online, a message can arrive for any exo a previous incarnation exported to another vat, and that exo's kind behavior must be ready to handle it. Data persists across vat-incarnations but code does not, so the successor must redefine all outstanding-exo behaviors in the first crank before any messages can arrive.

## Tips

### Synchronous makers

The durable kind maker functions are synchronous. When converting a maker that is async, you'll have to ensure that all necessary data is already available and need not be awaited in the vat's `prepare`.

The reason for this constraint is that _all prepares happen in the first crank_ of the event loop.

Once the successor vat-incarnation comes online, a message may arrive for any exo instance that a previous vat-incarnation exported to another vat. For that instance to properly react to such an incoming message, implementation code must have already been defined for its Kind. Data persists across vat-incarnations, but code does not.

The successor vat-incarnation must give all outstanding exos their behaviors during the first crank, because that is guaranteed to happen before they receive any messages.

Source: [packages/vat-data/README.md](https://github.com/Agoric/agoric-sdk/blob/31d74ec8e861efc48db473fd9b68820e4c0e3d55/packages/vat-data/README.md) at commit `31d74ec8`.
