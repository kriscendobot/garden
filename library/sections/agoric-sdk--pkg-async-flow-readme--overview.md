---
title: "@agoric/async-flow (overview + closed-function discipline)"
source: packages/async-flow/README.md
source_repo: agoric/agoric-sdk
source_commit: 16095c5076043133aff0f25721131be2ca1ef5af
source_date: 2024-05-19
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, agent-conventions, persistence, async-flow]
status: current
notes: The "closed function" requirement is the central capability-discipline rule that makes durable replay safe — any direct access to lexically captured mutable state would re-execute under replay outside the isolation mechanism and reintroduce bugs. This is the same discipline the agoric-sdk AGENTS.md "Coding Style & Naming Conventions" section names as ambient-authority confinement.
---

> Abstract: The core `asyncFlow(zone, name, asyncFn)` API. `asyncFlow` wraps an async function so its activations are durable: each call to the returned `wrapperFunc` creates an activation whose state survives vat upgrades via log-and-replay. The critical discipline: the wrapped async function must be **closed** — it may capture only powerless globals; any lexically-captured mutable state or capability to cause effects will misbehave under replay because the replay would re-execute those effects outside the isolation mechanism. In later incarnations the original `asyncFlow` call is re-registered with an async function that reproduces the original's logged behavior; old activations continue. May migrate to `@endo/async-flow` (see header note).

# `@agoric/async-flow`

***Beware that this module may migrate to the endo repository as `@endo/async-flow`.***

Upgrade while suspended at `await` points! Uses membrane to log and replay everything that happened before each upgrade.

In the first incarnation, somewhere, using a ***closed*** async function argument:

```js
const wrapperFunc = asyncFlow(
  zone,
  'funcName`,
  async (...) => {... await ...; ...},
);
```

Then elsewhere, as often as you'd like:

```js
const outcomeVow = wrapperFunc(...);
```

For all these `asyncFlow` calls that happened in the first incarnation, in the first crank of all later incarnations:

```js
asyncFlow(
  zone,
  'funcName`,
  async (...) => {... await ...; ...},
);
```

with async functions that reproduce the original's logged behavior. In these later incarnations, you only need to capture the returned `wrapperFunc` if you want to create new activations. Regardless, the old activations continue.

---

> **IMPORTANT**
> The async function argument should be ***closed***, meaning that it should not use any lexically captured variables other than powerless globals. Any direct access to mutable state or ability to cause effects may introduce bugs, since these effects will happen again under replay outside the control of the asyncFlow isolation and deterministic replay mechanisms.

Source: [packages/async-flow/README.md](https://github.com/Agoric/agoric-sdk/blob/16095c5076043133aff0f25721131be2ca1ef5af/packages/async-flow/README.md) at commit `16095c50`.
