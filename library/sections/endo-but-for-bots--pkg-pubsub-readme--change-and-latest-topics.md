---
title: "@endo/pubsub change topic, latest topic, and termination"
source: packages/pubsub/README.md
source_repo: endojs/endo-but-for-bots
source_branch: feat/endo-pubsub
source_commit: d15e34cba55a24ff03f5ac414dae7a14d534d555
source_pr: endojs/endo-but-for-bots#513
source_pr_state: open
source_date: 2026-06-24
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-25
ingested_by: scholar
topics: [change-propagation, streams]
status: current
notes: Unmerged open PR #513; see the source-index file for the lifecycle caveat.
---

> Abstract: The two `Reader`/`Writer`-shaped topic factories and their shared termination contract. `makeChangeTopic` exposes the sink as a `Writer<TValue, TReturn>` and each spring as a `Reader<TValue, TReturn>`: an early subscriber drains every value in order, a late subscriber sees only values published after it subscribed, and the producer is never blocked by a subscriber's drain rate (a slow subscriber piles undrained nodes in its own cursor closure). `makeLatestTopic` shares the publisher/subscriber shapes but retains only the most-recent value: a late subscriber sees the latest on its first `next()` (replay-on-iterate), a pre-publish subscriber blocks on first `next()` until a value arrives. For both variants `publisher.return(value)` settles every subscriber with `{ value, done: true }` on the next `next()` and stays terminal; `publisher.throw(error)` settles them by rejecting; a subscriber created after termination immediately sees the terminal disposition without blocking.

## Lossless deltas (`makeChangeTopic`)

`makeChangeTopic` exposes the sink as a `Writer<TValue, TReturn>` and each spring as a `Reader<TValue, TReturn>`.

```js
import { makeChangeTopic } from '@endo/pubsub/change-topic.js';

const { publisher, subscribe } = makeChangeTopic();
const early = subscribe();
await publisher.next(1);
await publisher.next(2);
const late = subscribe();
await publisher.next(3);

await early.next(); // { value: 1, done: false }
await early.next(); // { value: 2, done: false }
await early.next(); // { value: 3, done: false }

await late.next(); // { value: 3, done: false }
```

The producer is not blocked by any subscriber's drain rate. A slow subscriber accumulates undrained nodes in its own cursor closure; the producer advances the shared linked list past every published value.

## Lossy updates (`makeLatestTopic`)

`makeLatestTopic` shares the publisher and subscriber shapes with `makeChangeTopic` but retains only the most-recent value. A slow subscriber that misses several publishes sees only the latest when it next drains.

```js
import { makeLatestTopic } from '@endo/pubsub/latest-topic.js';

const { publisher, subscribe } = makeLatestTopic();
const a = subscribe();
await publisher.next(1);
await publisher.next(2);
await publisher.next(3);

await a.next(); // { value: 3, done: false }
```

A subscriber created after at least one value has been published sees the most recent value on its first `next()` call (replay-on-iterate). A subscriber created before any value has been published blocks on its first `next()` until the publisher emits.

## Termination

For both topic variants, `publisher.return(value)` settles every subscriber with `{ value, done: true }` on the next `next()`, and every subsequent call keeps returning the same terminal result. `publisher.throw(error)` settles every subscriber by rejecting with the error on the next `next()`; subsequent calls reject with the same error. A subscriber created after the topic has terminated immediately sees the terminal disposition on its first `next()` call without blocking.

Source: [packages/pubsub/README.md](https://github.com/endojs/endo-but-for-bots/blob/d15e34cba55a24ff03f5ac414dae7a14d534d555/packages/pubsub/README.md) at commit `d15e34cb` (unmerged PR #513, branch `feat/endo-pubsub`).
