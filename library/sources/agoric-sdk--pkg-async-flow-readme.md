---
source: packages/async-flow/README.md
source_repo: agoric/agoric-sdk
source_commit: 16095c5076043133aff0f25721131be2ca1ef5af
source_date: 2024-05-19
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
section_count: 2
status: current
notes: The package may migrate to @endo/async-flow per the README's own header note; flag this for the next contradiction-check sweep. Cross-cuts with capability-security (the closed-async-function rule is a capability-discipline pattern) and with agoric-sdk--agents--async-flow-model-notes (the agent-facing summary of the same model).
---

> Abstract: `@agoric/async-flow` is the durable-replay async-function infrastructure: an async function can be suspended at `await` points and survive a vat upgrade by logging+replaying everything that happened. Two sections: the core `asyncFlow(zone, name, asyncFn)` API + closed-function discipline, and the explicit "diagnostic loopholes" exception that lets `console` logging and error-class comparison work loosely under replay.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-async-flow-readme--overview.md) | capability-security, agent-conventions | current |
| [loopholes-for-purely-diagnostic-information](../sections/agoric-sdk--pkg-async-flow-readme--loopholes-for-purely-diagnostic-information.md) | capability-security | current |

## Cross-references

- Companion doc `packages/async-flow/docs/async-flow-states.md` (ingested as `agoric-sdk--pkg-async-flow-docs-async-flow-states--*`) describes the activation state machine (Running / Sleeping / Replaying / Failed / Done).
- `agoric-sdk--agents--async-flow-model-notes` is the agent-facing summary of the same model.

## Source

[packages/async-flow/README.md](https://github.com/Agoric/agoric-sdk/blob/16095c5076043133aff0f25721131be2ca1ef5af/packages/async-flow/README.md) at commit `16095c50`.
