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
title: §Async-generator-yields-as-it-decodes
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

```js
async function* makeNetstringIterator(input, opts) {
  for await (const chunk of input) {
    ...
    yield data;
    ...
  }
}
```

§Not-buffer-everything-then-yield. §Stream-in-stream-out.

§Each-complete-netstring-yields-to-consumer. §Backpressure-
via-async-iteration: §if-consumer-is-slow-the-generator-
pauses.

§Cycle-171-stream/index.js's §functional-async-queue + §back-
pressure-via-acks have a sibling discipline. Here, §back-
pressure-via-await-of-next.

§Async-generator-as-resumable-state-machine (cycle 169
atomics.js, cycle 173 promise-executor-kit) is the §JS-
language-feature-as-control-flow-primitive at work.
