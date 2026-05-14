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
---

> Abstract: Defines key vocabulary. A **vat** is a unit of isolation — objects/functions inside the same vat communicate synchronously; cross-vat communication is asynchronous only. The package provides three **zones** for persistence: heap (in memory, lost on termination), virtual (pageable to disk, lost on termination), durable (pageable AND revivable through vat upgrade and restart). A **turn** is everything between an empty stack and the next empty stack. A **crank** is everything between an empty stack-and-promise-queue and the next empty stack-and-promise-queue. The critical invariant: **all previous Kinds must be defined in the first crank** of a vat restart — otherwise a partial restoration would expose other vats to side effects that couldn't be unwound on failure.

# Agoric Vat Data

This package provides access to the Vat Data facility.

## Overview

A [**vat**](https://docs.agoric.com/glossary/#vat) is a unit of isolation. Objects and functions inside the same JavaScript vat can communicate synchronously with one another. Vats and their contents can communicate with other vats and their objects and functions, but can only communicate asynchronously.

This package provides functions that can persist data in different **zones**:

- heap (holds memory, lost on vat termination)
- virtual (can be paged out, lost on vat termination)
- durable (can be paged out, can persist through vat termination and restart)

The kinds defined by the [`prepare*` functions](https://github.com/endojs/endo/blob/master/packages/exo/docs/exo-taxonomy.md#makedefine-vs-prepare) (e.g. `prepareExo`) must be available before their data is accessed. Understanding this life cycle requires a couple more concepts:

A **turn** is everything that happens between an empty stack and the next empty stack, for a given vat.

A **crank** is everything that happens from an empty stack and promise queue to the next empty stack and promise queue.

When a vat is restarted, all previous Kinds must be defined in the first crank. To understand why, consider an alternative scenario where restoration depends upon external deliveries prompting a second crank. The vat would need to somehow enter a suspended state where no deliveries other than the ones needed for completion of start are handled. That would expose other vats to side effects, so the restart/upgrade could never be fully unwound if it fails.

Source: [packages/vat-data/README.md](https://github.com/Agoric/agoric-sdk/blob/31d74ec8e861efc48db473fd9b68820e4c0e3d55/packages/vat-data/README.md) at commit `31d74ec8`.
