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
title: §Why-this-file-exists
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

§Trap-needs-synchronous-cross-worker-RPC. Cycle 154's
trap.js lifted the synchronous-trap mechanism from E.js;
this file provides the concrete *transport* that makes it
work across web worker (or worker_thread / xs worker)
boundaries.

§SharedArrayBuffer-is-the-only-way: postMessage is async
(returns to event loop); only SharedArrayBuffer + Atomics
gives §truly-blocking-synchronous-communication. §No-polling-
required (Atomics.wait blocks the thread until notify).

§The-file-is-small-because-the-mechanism-is-tight: one
SharedArrayBuffer, one async generator, one wait/notify
pair. §The-LOC-doesn't-reflect-the-load-bearing-knowledge
(sibling observation to cycle 167's where/index.js).
