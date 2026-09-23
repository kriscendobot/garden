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
title: §Three-status-bit-flags
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

```js
const STATUS_WAITING = 1;       // guest waiting for host
const STATUS_FLAG_DONE = 2;     // last chunk in this transfer
const STATUS_FLAG_REJECT = 4;   // the trapped value is a rejection
```

§Bit-flags-not-enum: §three-flags-compose. The status byte
can simultaneously say *this is the last chunk AND it's a
rejection*: `STATUS_FLAG_DONE | STATUS_FLAG_REJECT`.

§Why-not-an-enum: an enum can't express *multiple states
at once*. §Bitfield-when-states-are-orthogonal discipline.

§STATUS_WAITING-as-the-initial-guest-state: the guest sets
this *before* calling it.next() and Atomics.wait. The host
overwrites it when ready.
