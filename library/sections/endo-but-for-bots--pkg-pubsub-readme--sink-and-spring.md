---
title: "@endo/pubsub Sink and Spring"
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

> Abstract: A pubsub topic decomposes into a publisher-side **sink** and a per-subscriber **spring** over a single async promise linked list. The sink extends the linked list one node at a time as the publisher emits values; each spring is an independent cursor over the same list, starting (when created) at the next node the publisher will add. This is the same primitive `@endo/stream` introduced in commit `cbbd57c03` and later removed during the `@endo/harden` refactor; `@endo/pubsub` lifts the primitive back into a sibling package. The low-level entry point is `makePubSub()` returning `{ pub, sub }`, where `pub.put(value)` extends the list and `sub()` mints an independent cursor.

A pubsub topic decomposes into a publisher-side **sink** and a per-subscriber **spring** over a single async promise linked list. The sink extends the linked list one node at a time as the publisher emits values. Each spring is an independent cursor over the same list; when a spring is created, its cursor starts at the next node the publisher will add. This is the same primitive `@endo/stream` introduced in commit `cbbd57c03` (later removed during the `@endo/harden` refactor); the present package lifts the primitive into a sibling.

```js
import { makePubSub } from '@endo/pubsub/pub-sub.js';

const { pub, sub } = makePubSub();
const a = sub();
pub.put(1);
const b = sub();
pub.put(2);
await a.get(); // 1
await a.get(); // 2
await b.get(); // 2
```

The example shows the cursor independence: `a` was minted before either `put`, so it drains both `1` and `2`; `b` was minted after `put(1)`, so its cursor starts at the next node and it sees only `2`. This is the broadcast publish/subscribe shape gtor names (one setter, many getters, no continuity guarantee for a late subscriber), and the async-promise-linked-list queue is the substrate `@endo/stream`'s `makeQueue` realizes as cons-cells.

Source: [packages/pubsub/README.md](https://github.com/endojs/endo-but-for-bots/blob/d15e34cba55a24ff03f5ac414dae7a14d534d555/packages/pubsub/README.md) at commit `d15e34cb` (unmerged PR #513, branch `feat/endo-pubsub`).
