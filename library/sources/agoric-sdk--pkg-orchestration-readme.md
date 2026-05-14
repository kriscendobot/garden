---
source: packages/orchestration/README.md
source_repo: agoric/agoric-sdk
source_commit: 1a91e7bb9df8880a1ccaa3f5143a55dd580fa653
source_date: 2024-07-18
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
section_count: 2
status: current
notes: Orchestration flows are the cross-chain coordination layer. The four "must" constraints on flow functions (no closures over changing values, satisfy OrchestrationFlow interface, hardened, no E()) parallel the async-flow "closed function" discipline. The recommended file convention (`.flows.js`) is shared with async-flow.
---

> Abstract: A 20-line frame for the orchestration package. Two sections: the overview (frame + usage-examples pointer to `src/examples`) and orchestration-flows (the four constraints on flow functions: must not close over mutable state, must satisfy the `OrchestrationFlow` interface, must be hardened, must not use `E()`; plus the recommended file convention — keep flows in `.flows.js`, import them all via `import * as flows`, use `orchestrateAll` so each export name becomes the `durableName`, adopt `@agoric/eslint-config`'s rules).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-orchestration-readme--overview.md) | capability-security, getting-started | current |
| [orchestration-flows](../sections/agoric-sdk--pkg-orchestration-readme--orchestration-flows.md) | capability-security, agent-conventions | current |

## Cross-references

- The "closed function" discipline shared with `agoric-sdk--pkg-async-flow-readme--overview` — both forbid lexically-captured mutable state for resumability.
- `agoric-sdk--agents--coding-style-and-naming-conventions` also names `@agoric/eslint-config` as authoritative.

## Source

[packages/orchestration/README.md](https://github.com/Agoric/agoric-sdk/blob/1a91e7bb9df8880a1ccaa3f5143a55dd580fa653/packages/orchestration/README.md) at commit `1a91e7bb`.
