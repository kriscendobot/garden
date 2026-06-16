---
title: Agoric Vat Data
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
parent: agoric-sdk--pkg-vat-data-readme--overview
---

This package provides access to the Vat Data facility.

Source: [packages/vat-data/README.md](https://github.com/Agoric/agoric-sdk/blob/31d74ec8e861efc48db473fd9b68820e4c0e3d55/packages/vat-data/README.md) at commit `31d74ec8`.
