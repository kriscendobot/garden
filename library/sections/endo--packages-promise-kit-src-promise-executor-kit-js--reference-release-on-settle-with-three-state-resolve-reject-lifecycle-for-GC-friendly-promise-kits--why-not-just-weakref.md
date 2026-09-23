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
title: §Why-not-just-WeakRef
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

A reader might ask: why not use `WeakRef` to hold
internalResolve/internalReject and let GC handle the
release?

§Answer: §timing-guarantees. WeakRef doesn't give §immediate-
release; it gives §release-when-GC-runs (which could be
arbitrarily later). For §promise-settlement-pipeline-
hygiene, §immediate-release-by-explicit-assignment is the
right shape.

§Cycle-156's-finalize.js (WeakValueMap pattern) is the
sibling: that file uses WeakRef-equivalent for §observe-
when-no-strong-ref-remains. This file uses §explicit-
release-on-known-event.

§Two-different-promises-about-GC: §weak-when-no-strong-
reference (finalize.js) vs §release-on-known-event (this
file).
