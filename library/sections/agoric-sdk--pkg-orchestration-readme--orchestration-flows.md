---
title: Orchestration flows (constraints + recommended pattern)
source: packages/orchestration/README.md
source_repo: agoric/agoric-sdk
source_commit: 1a91e7bb9df8880a1ccaa3f5143a55dd580fa653
source_date: 2024-07-18
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, agent-conventions, async-flow]
status: current
notes: The "no E() in flows" constraint is a key restriction — flows are synchronous from the orchestration runtime's perspective, even though their continuation may span many vat-incarnations. This parallels async-flow's closed-function rule but is even stricter. Cross-cuts with agoric-sdk--pkg-async-flow-readme--overview (same closed-fn discipline) and with agoric-sdk--agents--coding-style-and-naming-conventions (which names @agoric/eslint-config).
---

> Abstract: Orchestration flows are regular JS functions with **four constraints** to be resumable after vat termination: (1) must not close over any values that could change between invocations; (2) must satisfy the `OrchestrationFlow` interface; (3) must be hardened; (4) **must not use `E()`** (eventual send). The call to `orchestrate` in reincarnations must use the same `durableName`. Recommended file pattern: keep flows in a `.flows.js` module, import them all with `import * as flows` to get a single object keyed by export name, use `orchestrateAll` to treat each export name as a `durableName`, adopt `@agoric/eslint-config` rules.

## Orchestration flows

Flows to orchestrate are regular Javascript functions but have some constraints to fulfill the requirements of resumability after termination of the enclosing vat. Some requirements for each orchestration flow:

- must not close over any values that could change between invocations
- must satisfy the `OrchestrationFlow` interface
- must be hardened
- must not use `E()` (eventual send)

The call to `orchestrate` using a flow function in reincarnations of the vat must have the same `durableName` as before. To help enforce these constraints, we recommend:

- keeping flows in a `.flows.js` module
- importing them all with `import * as flows` to get a single object keyed by the export name
- using `orchestrateAll` to treat each export name as the `durableName` of the flow
- adopting `@agoric/eslint-config` that has rules to help detect problems

Source: [packages/orchestration/README.md](https://github.com/Agoric/agoric-sdk/blob/1a91e7bb9df8880a1ccaa3f5143a55dd580fa653/packages/orchestration/README.md) at commit `1a91e7bb`.
