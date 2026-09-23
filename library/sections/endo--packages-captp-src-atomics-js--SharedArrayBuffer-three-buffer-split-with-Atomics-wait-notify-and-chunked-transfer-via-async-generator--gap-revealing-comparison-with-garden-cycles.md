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
title: §Gap-revealing-comparison with garden cycles
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

| Cycle | Connection |
|-------|------------|
| 154 (trap.js) | §Pair-file — abstract interface; this is concrete transport |
| 158 (loopback.js) | §Local-CapTP-instance shape (two CapTP wired cross); this is the SharedArrayBuffer variant for cross-worker |
| 156 (finalize.js) | §WeakValueMap-GC pattern; this transport carries the values that finalize.js tracks |
| 167 (where/index.js) | §Small-file-but-load-bearing-knowledge sibling observation |
| 159 (daemon-debug-worker-restart) | §Synchronous-cross-worker-step needs §Atomics-based-blocking (this file's mechanism) |
