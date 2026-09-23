---
title: Upgrade (prepare function + durability + kinds + crank rules)
source: packages/zoe/README.md
source_repo: agoric/agoric-sdk
source_commit: 940d3f0a993ca45a6bb0893bd59e6df1f22d9143
source_date: 2024-07-03
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, bundles, capability-security, persistence]
status: current
notes: The upgrade-contract flow is structurally similar to SwingSet's vat-upgrade flow (per the doc's link to `packages/SwingSet/docs/vat-upgrade.md`). The single-crank rule for `prepare` in later incarnations is a SwingSet-kernel correctness invariant: it allows the kernel to deliver queued inbound messages safely without having to distinguish "needed for upgrade" from "new work". Cross-cuts with bundles (the new source code is identified by a bundleID), exo (the contract uses prepareExo / prepareExoClass for its remotables), and the "null upgrade" pattern (re-use the same bundle to clear accumulated state) is a legitimate use.
kind: index
section_count: 2
---

> Abstract: A contract instance can be upgraded to a new source-code bundle via `E(instanceAdminFacet).upgradeContract(newBundleID)`. "Null upgrade" (re-use the original bundle) is valid and is the canonical pattern for clearing accumulated state. **Four requirements** for upgradable contracts: (1) **Export**: replace `start` with `prepare` — called by `startInstance` for the first incarnation and `restartContract`/`upgradeContract` for subsequent ones; (2) **Durability**: anything that must survive a re-incarnation must live in durable storage; (3) **Kinds**: must be defined (via `prepareExoClass` etc.) before durable-storage deserialization; (4) **Crank**: in the first incarnation `prepare` may return a multi-crank promise; in later incarnations it must settle in **one crank** because the kernel can't distinguish messages needed for upgrade from messages that should be delayed. Includes a worked v1→v2 example with `codeVersion` baggage tracking and `prepareExoClass` for the upgraded `Counter` interface.

Sections:

- [Upgrade](agoric-sdk--pkg-zoe-readme--upgrade--upgrade.md)
- [Crank](agoric-sdk--pkg-zoe-readme--upgrade--crank.md)

Source: [packages/zoe/README.md](https://github.com/Agoric/agoric-sdk/blob/940d3f0a993ca45a6bb0893bd59e6df1f22d9143/packages/zoe/README.md) at commit `940d3f0a`.
