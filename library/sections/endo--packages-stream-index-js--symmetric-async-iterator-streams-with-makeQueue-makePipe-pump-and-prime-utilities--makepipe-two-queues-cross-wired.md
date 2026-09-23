---
source: packages/stream/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/stream/index.js
source_path: packages/stream/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 171
lane: chat
status: current
title: §makePipe — two queues, cross-wired
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

```js
export const makePipe = () => {
  const data = makeQueue();
  const acks = makeQueue();
  const reader = makeStream(acks, data);
  const writer = makeStream(data, acks);
  return harden([writer, reader]);
};
```

§Two-queues-one-pipe. The Reader has (acks, data); the
Writer has (data, acks) — §args-flipped. §What-Reader-puts-
in-data-is-what-Writer-gets-from-data.

§Three-line-implementation reveals the simplicity. §The-
symmetric-makeStream-makes-this-possible: §swap-args-get-
the-other-direction.

§Conceptually-Reader-receives-from-data-and-acks-back-via-
acks. §Writer-sends-to-data-and-awaits-ack-via-acks. §Each-
operation-handshakes (no fire-and-forget).

§Why-handshake: §back-pressure. The writer's `next()`
doesn't resolve until the reader has acked. §The-rate-of-
flow-is-rate-of-acks.
