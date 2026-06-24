---
id: retention-accumulator
aliases: ["retention-accumulator", "retention-accumulator.js", "RetentionDelta", "microtask-coalesced retention deltas", "coalesce-then-deliver", "retention churn collapse"]
topics: [daemon, async-flow, eventual-send]
---

# retention-accumulator

The daemon-wide batching primitive that collapses retention-graph churn
within a microtask before flushing. An accumulator is a tiny buffering
object: `add(n)` after a pending `remove(n)` cancels the `remove`, and
vice versa; repeated `add`s or `remove`s of the same formula collapse
to one via Set semantics. The flush returns
`RetentionDelta = {add: string[], remove: string[]}` and resets. One
accumulator exists per follower / subscriber so that multi-event
arrivals (e.g. `provideGuest` incarnating seven dependent formulas) yield
one delta on the wire rather than seven. The same coalesce-then-deliver
shape is the daemon-wide async-flow convention for retention-graph
events.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dcpg/wire-and-batching](../sections/endo-but-for-bots--llm-designs-dcpg--wire-and-batching.md) | The named primitive (`retention-accumulator.js`) with `add`/`remove`/`drain` API, flush-on-microtask discipline, and how it composes with `EndoGateway.followRetentionSet`. |
| [dcpg/event-sources-and-subscription](../sections/endo-but-for-bots--llm-designs-dcpg--event-sources-and-subscription.md) | What feeds the accumulator: inbound far-ref arrival, outbound revocation, GC-triggered drop — all funneled through one `formulaChangeTopic`. |
| [drp/phases-and-decisions](../sections/endo-but-for-bots--llm-designs-drp--phases-and-decisions.md) | The local-side equivalent: `followRetentionPaths(locator)` uses the same retention-accumulator pattern to coalesce path-graph updates. |

## See also

- [[crdt-in-formula-persistence]] — why the accumulator is *not* a CRDT (single writer per peer-pair).
- [[four-tables-coordinated-retention]] — the data-shape the accumulator feeds.
