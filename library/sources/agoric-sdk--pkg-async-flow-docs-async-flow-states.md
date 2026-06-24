---
source: packages/async-flow/docs/async-flow-states.md
source_repo: agoric/agoric-sdk
source_commit: 1daa37f59b3c89d5af942e6a6bb74a892a07b1fb
source_date: 2024-09-26
source_authors: [Michael FIG]
ingested: 2026-05-14
ingested_by: scholar
section_count: 1
status: current
notes: AGENTS.md explicitly tells reviewers of `*.flows.*` modules to read this doc. The Running/Sleeping/Replaying/Failed/Done lifecycle is the canonical mental model. Cross-cuts with agoric-sdk--agents--async-flow-model-notes (the agent-facing summary) and agoric-sdk--pkg-async-flow-readme--* (the API and discipline).
---

> Abstract: The canonical state-machine diagram for an async-flow activation: Running → Sleeping (across upgrade) → Replaying → Running → Done, with Failed as a degenerate side-state for replay misbehavior or `asyncFlow`-mechanism failures. Tiny doc (15 lines) but load-bearing: the state names appear verbatim in the runtime telemetry and in code-review checklists for `*.flows.*` modules.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-async-flow-docs-async-flow-states--overview.md) | capability-security | current |

## Source

[packages/async-flow/docs/async-flow-states.md](https://github.com/Agoric/agoric-sdk/blob/1daa37f59b3c89d5af942e6a6bb74a892a07b1fb/packages/async-flow/docs/async-flow-states.md) at commit `1daa37f5`.
