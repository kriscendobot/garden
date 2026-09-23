---
title: "Notifier pubsub migration: back-pressure, wire protocol, and consumer overflow policy"
source: designs/notifier-pubsub-migration.md
source_repo: endojs/endo-but-for-bots
source_branch: design/notifier-pubsub-migration
source_commit: 8c2a46bed3fb072b25d10e96cae16859e63b6812
source_pr: endojs/endo-but-for-bots#507
source_pr_state: draft
source_date: 2026-06-24
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-25
ingested_by: scholar
topics: [change-propagation, streams, captp]
status: current
notes: Unmerged draft PR #507, revision 5; see the source-index file for the lifecycle caveat.
---

> Abstract: The back-pressure discipline is inherited from `@endo/exo-stream`: a slow consumer accumulates backlog **in the consumer process**, not the producer process. The producer observes a slow consumer only as a slower acknowledgement of the chain-head advance; it does not queue per-consumer deltas itself. CapTP ferries `StreamNode` cells from producer to consumer as the producer's chain-head advances, and the cells sit in the consumer's heap until drained; the producer side holds only the chain-head reference per active iteration and is bounded. `@endo/pubsub`'s changes variant matches this locally (each spring is a cursor; cells live on the shared async promise linked list until the slowest cursor advances past them), while the latest variant carries only one cell regardless of consumer count. This is `@agoric/notifier`'s "producer not vulnerable to consumers" invariant carried into both layers via the same mechanism `@endo/stream` / `@endo/exo-stream` already use. The wire-side accumulation is **unbounded by default**; a consumer that needs a bound applies it locally after `readerFromTopic` (wrapping with `coalesceReader` plus its own reducer/debounce, or a drop-oldest policy of its choosing) — the adapters bake no overflow policy into the topic, because the consumer that knows its memory budget knows the right policy.

## Back-pressure and wire protocol

The wire-protocol discipline is inherited from `@endo/exo-stream`: a slow consumer accumulates backlog **in the consumer process**, not in the producer process. The producer side observes a slow consumer only as a slower acknowledgement of the chain-head advance from that consumer; it does not queue per-consumer deltas itself.

CapTP ferries `StreamNode` cells from the producer side to the consumer side as the producer's chain-head advances, and the cells sit in the consumer process's heap until the consumer drains them. A consumer that reads slowly piles cells in its own heap; the producer side holds only the chain-head reference per active iteration and is bounded.

`@endo/pubsub`'s changes variant matches this on the local side: each spring is a cursor, and the cells live on the shared async promise linked list until the slowest-cursor consumer advances past them. The lossy variant carries only one cell (the latest) regardless of consumer count, so the local-side memory cost is bounded irrespective of consumer lag.

This is `@agoric/notifier`'s "producer not vulnerable to consumers" invariant carried into both layers via the same mechanism `@endo/stream` and `@endo/exo-stream` already use.

## Overflow policy on the consumer

The wire-protocol-side accumulation is unbounded by default. A consumer that does not drain pins consumer-process memory. A consumer that needs a bound applies it on the local side, after `readerFromTopic` recovers the local reader: the consumer wraps its local reader with `coalesceReader` supplying its own reducer / debounce window, or with a drop-oldest policy of its own choosing. The adapters do not bake an overflow policy into the topic itself; the consumer that knows its memory budget knows the right policy.

Source: [designs/notifier-pubsub-migration.md](https://github.com/endojs/endo-but-for-bots/blob/8c2a46bed3fb072b25d10e96cae16859e63b6812/designs/notifier-pubsub-migration.md) at commit `8c2a46be` (unmerged draft PR #507, branch `design/notifier-pubsub-migration`).
