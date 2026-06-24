---
id: changes-versus-latest
aliases: ["changes vs latest", "changes versus latest", "latest vs changes", "lossy vs lossless", "lossless deltas vs lossy latest", "makeChangeTopic vs makeLatestTopic", "signal vs behavior", "changes topic", "latest topic", "lossy topic", "lossless topic", "forward-lossless", "fully lossless", "current value vs change stream", "notifier vs subscription"]
topics: [change-propagation, streams]
status: current
---

# changes-versus-latest

The recurring duality at the heart of change propagation: a derived consumer either wants **every change** (a lossless, order-significant stream of deltas) or only the **latest value** (a lossy, convergent current-state sample). The same axis appears, with the same shape, in three places in the corpus:

- **gtor** — a **signal** is discrete and *pushed* (deliver every change via `observable.forEach`); a **behavior** is continuous and *polled* (sample the latest via `next`). gtor's bridge: an observable *also* implements `next`, so one signal exposes both faces — "poll a signal as if it were a behavior."
- **`@endo/pubsub`** (PR #513) — `makeChangeTopic()` is **lossless**: every subscriber sees every value published after its iteration begins. `makeLatestTopic()` is **lossy**: only the most-recent value is retained; a late subscriber sees the latest immediately and then blocks for future values.
- **`@agoric/notifier`** — the same axis with a labelled middle point: **fully lossless** (subscription: every state), **forward-lossless** (every state from the point of subscription forward), and **lossy** (notifier: only the latest, may skip intermediate states).

## Why the duality is fundamental, not incidental

The two faces answer different questions about the *meaning* of the data (gtor: "the appropriate transport is domain specific"):

- **Latest / behavior / lossy** suits time-series data where intermediate states are *irrelevant* — the current temperature, a scrollbar position, the newest weather forecast. Old values may be forgotten as new ones arrive. Because re-delivering the latest value reaches the same state, the latest face is **idempotent and convergent**: it tolerates loss, reordering, and a slow or late consumer. This is also why it composes with constraint/propagator-style merge.
- **Changes / signal / lossless** suits data where *every delta is significant* and order and completeness must be preserved — appending to a log, the range-change records that drive an FRB incremental transform, a sequence whose replay must reconstruct exact state. Dropping or reordering a delta corrupts the derived result, so the changes face cannot be made lossy without changing its meaning.

## How they compose

The maintainer's notifier-pubsub-migration design (#507) and the #513 implementation treat the two as composable rather than parallel:

- **forward-lossless = changes + a one-shot latest snapshot.** `makeUpdateTopic` (the notifier's forward-lossless shape) is *retired* and recovered by composition: `makeChangeTopic` plus a one-shot `latestSnapshot()` accessor. Subscribe-time semantics differ per face: a latest-topic's new subscriber sees the latest cell immediately; a change-topic's new subscriber sees only the future.
- **One mechanism underneath.** Both topic factories sit over the same `makePubSub` sink/spring primitive (see [[endo-pubsub]]); the lossy/lossless behavior is a per-topic retention policy, not a different transport — mirroring gtor's "one signal, two getter disciplines."

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [gtor--readme--signals-and-behaviors](../sections/gtor--readme--signals-and-behaviors.md) | Discrete pushed signals (changes) vs continuous polled behaviors (latest); observable's `forEach` vs `next`. |
| [gtor--readme--reactivity-taxonomy](../sections/gtor--readme--reactivity-taxonomy.md) | Broadcast publish/subscribe is discontinuous (a late subscriber misses earlier values); time-series order may not matter. |
| [frb--readme--tutorial-aggregations](../sections/frb--readme--tutorial-aggregations.md) | FRB's `last` operator (no jitter) keeps the latest value of a changing source — a latest-face binding. |

(The `@agoric/notifier` lossy/forward-lossless/fully-lossless taxonomy is indexed under the `agoric-sdk--pkg-notifier-readme` section family; see `keywords.md` for the entry points added by the 2026-06-23 pubsub research.)

## See also

- [[change-propagation]] — the through-line this duality sits at the center of.
- [[endo-pubsub]] — the package that makes both faces concrete as `makeChangeTopic` / `makeLatestTopic`.
- [[retention-accumulator]] — coalesce-then-deliver delta batching; a lossless-changes consumer that lossily coalesces under back-pressure.

## Common confusions

- **Lossy is not "broken."** A latest-topic deliberately discards intermediate states because they carry no meaning for its consumer; that is the correct contract for a current-value, not a defect.
- **Forward-lossless is a middle point, not a third mechanism.** It is the changes face seeded with one latest snapshot at subscribe time; the design recovers it by composition rather than a dedicated factory.
