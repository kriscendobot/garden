# Topic: async-flow

> Abstract: The `@agoric/async-flow` durable-replay async-function infrastructure. An async function can suspend at `await` points and survive a vat upgrade by logging+replaying everything that happened. The closed-function discipline (no lexically captured mutable state) is the rule that makes deterministic replay sound. Distinct from `eventual-send` (which is the underlying primitive) and from `persistence` (which is the broader category). Includes the `orchestration` package's stricter no-`E()` variant for cross-chain flows.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [agoric-sdk--agents--async-flow-model-notes](../sections/agoric-sdk--agents--async-flow-model-notes.md) | agoric-sdk AGENTS.md | agoric-sdk's async-flow model runs each invocation as an activation with durable lifecycle states: `Running`, `Sleeping`, `Replaying`, `Failed`, `Done`. |
| [agoric-sdk--pkg-async-flow-docs-async-flow-states--overview](../sections/agoric-sdk--pkg-async-flow-docs-async-flow-states--overview.md) | agoric-sdk packages/async-flow/docs/async-flow-states.md | A prepared guest async function is internally an exoClass; each `wrapperFunc(.. |
| [agoric-sdk--pkg-async-flow-readme--loopholes-for-purely-diagnostic-information](../sections/agoric-sdk--pkg-async-flow-readme--loopholes-for-purely-diagnostic-information.md) | agoric-sdk packages/async-flow/README.md | Explicit exceptions to the closed-function rule. |
| [agoric-sdk--pkg-async-flow-readme--overview](../sections/agoric-sdk--pkg-async-flow-readme--overview.md) | agoric-sdk packages/async-flow/README.md | The core `asyncFlow(zone, name, asyncFn)` API. |
| [agoric-sdk--pkg-orchestration-readme--orchestration-flows](../sections/agoric-sdk--pkg-orchestration-readme--orchestration-flows.md) | agoric-sdk packages/orchestration/README.md | Orchestration flows are regular JS functions with **four constraints** to be resumable after vat termination: (1) must not close over any values that could change between invocations; (2) must satisfy the `OrchestrationFlow` interface; (3) must be hardened; (4) **must not use `E()`** (eventual send). |
| [endo-but-for-bots--llm-designs-dcpg--event-sources-and-subscription](../sections/endo-but-for-bots--llm-designs-dcpg--event-sources-and-subscription.md) | endo-but-for-bots designs/daemon-cross-peer-gc.md | Daemon retention-mutation surface: three event sources funnel through one `formulaChangeTopic`; subscriptions yield one async iterator per (follower, peer) pair; the iterator *is* the resource (no separate cancel). |
| [endo-but-for-bots--llm-designs-dcpg--wire-and-batching](../sections/endo-but-for-bots--llm-designs-dcpg--wire-and-batching.md) | endo-but-for-bots designs/daemon-cross-peer-gc.md | **Coalesce-then-deliver** is the daemon-wide async-flow convention for retention-graph events: the retention-accumulator collapses add-then-remove churn within a microtask before flushing each (follower, peer) accumulator. |

## See also

- [`persistence`](persistence.md): the broader category async-flow specializes.
- [`eventual-send`](eventual-send.md): the `E()` primitive async-flow builds on (except in orchestration flows, which forbid it).
- [`capability-security`](capability-security.md): the closed-function discipline is the ambient-authority-confinement principle applied to replayable functions.
