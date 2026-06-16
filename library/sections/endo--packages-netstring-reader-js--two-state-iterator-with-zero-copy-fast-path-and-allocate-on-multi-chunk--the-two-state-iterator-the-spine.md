---
source: packages/netstring/reader.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/netstring/reader.js
source_path: packages/netstring/reader.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mathieu Hofman (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 177
lane: chat
status: current
title: §The-two-state-iterator (the spine)
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

```js
/** @type {number[] | null} */
let lengthBuffer = [];
/** @type {Uint8Array | null} */
let dataBuffer = null;
let remainingDataLength = -1;
```

§State-encoded-as-lengthBuffer-null-or-not:

| State | `lengthBuffer` | Meaning |
|-------|----------------|---------|
| Waiting for length | `number[]` (digits) | Accumulating length-prefix chars |
| Waiting for data | `null` | Have length; consuming data bytes |

§Boolean-state-as-null-vs-not-null. §Cycle-173's-promise-
executor-kit had a similar §undefined-vs-null-meaningful-
distinction; this is §null-vs-array-meaningful-distinction.

§Two-named-states-with-explicit-comment:

> *The iterator can be in 2 states: waiting for the
> length, or waiting for the data*

§Named-states-in-comments before they're implicit in
code. §The-comment-tells-you-the-machine.
