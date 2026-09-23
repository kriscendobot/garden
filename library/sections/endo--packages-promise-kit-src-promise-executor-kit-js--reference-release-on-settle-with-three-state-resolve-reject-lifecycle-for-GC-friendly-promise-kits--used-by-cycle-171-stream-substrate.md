---
source: packages/promise-kit/src/promise-executor-kit.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/promise-executor-kit.js
source_path: packages/promise-kit/src/promise-executor-kit.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - patterns
  - async-flow
genre: §endo-source-comment-fragment
cycle: 173
lane: chat
status: current
title: §Used-by-cycle-171-stream-substrate
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

`packages/stream/index.js` (cycle 171) calls
`makePromiseKit()` to create the §functional-async-queue's
cons-cells. Each cons-cell's `{value, promise}` involves a
promise that needs to be GC-eligible after consumption.

§If-promise-kits-didn't-release-internal-refs: the stream's
cons-cell chain would §retain-each-resolve-function until
the cons-cell itself was collected. With §reference-release-
on-settle, each settled cons-cell's promise can be GC'd
§independently-of-cons-cell-lifetime.

§Cycle-171's-promise-as-pointer pattern §depends-on-this-
hygiene. The §queue-can-be-long because §settled-cells-
don't-pin-resolution-functions.
