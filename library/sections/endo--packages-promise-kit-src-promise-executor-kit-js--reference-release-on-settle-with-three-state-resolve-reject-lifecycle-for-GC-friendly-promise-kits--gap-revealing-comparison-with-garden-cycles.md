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
title: §Gap-revealing-comparison with garden cycles
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

| Cycle | Connection |
|-------|------------|
| 152 (memo-race.js) | §Sibling-file-in-same-package; §promise-lifecycle discipline |
| 171 (stream/index.js) | §Consumer-of-makePromiseKit; this file's release is §what-makes-the-stream-queue-GC-friendly |
| 156 (finalize.js) | §WeakValueMap-GC-pattern sibling; §weak-vs-explicit-release distinction |
| 66 (handled-promise.js) | §Promise-constructor that this kit's executor could feed |
| 146 (E.js) | §Consumer-of-HandledPromise; uses kit-style executors indirectly |
| 90 (track-turns.js) | §Promise-pipeline-hygiene sibling |
