---
source: packages/captp/src/atomics.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
source_path: packages/captp/src/atomics.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - captp
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 169
lane: chat
status: current
title: §Async-generator-as-trapHost
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

```js
return harden(async function* trapHost([isReject, serialized]) {
  ...
  while (!done) {
    ... fill databuf with next slice ...
    statusbuf[0] = rejectFlag | doneFlag;
    Atomics.notify(statusbuf, 0, +Infinity);
    if (!done) {
      yield;  // suspend until next it.next()
    }
  }
});
```

§Async-generator-as-resumable-state-machine. §yield-as-
resume-point — yield blocks until guest calls it.next()
again. §Host-state-is-implicit-in-generator-position.

§Why-async-generator-not-callback-loop: async generators
let the host §pause-mid-transfer naturally, without
explicit state machine. §JS-language-feature-as-control-
flow-primitive.

§Comment-from-code:

> *Wait until the next call to `it.next()`. If the guest
> calls `it.return()` or `it.throw()`, then this yield will
> return or throw, terminating the generator function
> early.*

§Iterator-protocol-as-bidirectional-channel: host sends
chunks via Atomics.notify; guest controls iteration via
it.next() / it.return() / it.throw(). §Two-channels-
multiplexed-on-the-iterator-protocol.

§Atomics.notify(statusbuf, 0, +Infinity): wake §all-
waiters. The +Infinity argument means *unbounded-number-of-
threads-to-wake*; in practice it's one guest. §Defensive-
unbounded-wake.
