---
title: Async-Flow Model Notes
source: AGENTS.md
source_repo: agoric/agoric-sdk
source_commit: 08e3d64d81c7feb73d455fcc58dbc2c731d69c77
source_date: 2026-03-23
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions, persistence, async-flow]
status: current
notes: This section names a durable-lifecycle replay model with strong constraints that agent-authored edits to `*.flows.*` modules must respect. The 'adding await reorders later effects' point is the kind of operational footgun any code-edit role should know before touching async-flow modules.
---

> Abstract: agoric-sdk's async-flow model runs each invocation as an activation with durable lifecycle states: `Running`, `Sleeping`, `Replaying`, `Failed`, `Done`. Upgrade-safe behavior depends on deterministic replay of prior host interactions; divergence during replay or invalid interactions transitions the activation to `Failed`. `Done` is settled and replay bookkeeping is dropped — promises not yet settled at `Done` time never see reactions run. Adding an `await` inside an async helper or calling without immediate await can reorder later effects into a different turn. For `*.flows.*` modules, also read `packages/async-flow/docs/async-flow-states.md`.

## Async-Flow Model Notes
- Async-flow runs each invocation as an activation with durable lifecycle states: `Running`, `Sleeping`, `Replaying`, `Failed`, `Done`.
- Upgrade-safe behavior depends on deterministic replay of prior host interactions; divergence during replay or invalid interactions can move an activation to `Failed`.
- `Done` means the activation outcome is settled and replay bookkeeping is dropped; logic that assumes continued activation state after completion is erroneous. Once the async-flow is done, any promises not yet settled will never see their reactions run. That's because the vow settling on the host side no longer translates into a settlement of the guest promise.
- Interleaving changes can also break replay: adding an `await` inside an async helper, or calling one without awaiting it immediately, can move later effects into a different turn and reorder them relative to the caller.
- For `*.flows.*` modules, keep replay behavior in mind and prefer code that is explicit about lifecycle boundaries and awaited dependencies.
- When reviewing `*.flows.*` modules, read `packages/async-flow/docs/async-flow-states.md`.

Source: [AGENTS.md](https://github.com/Agoric/agoric-sdk/blob/08e3d64d81c7feb73d455fcc58dbc2c731d69c77/AGENTS.md) at commit `08e3d64d`.
