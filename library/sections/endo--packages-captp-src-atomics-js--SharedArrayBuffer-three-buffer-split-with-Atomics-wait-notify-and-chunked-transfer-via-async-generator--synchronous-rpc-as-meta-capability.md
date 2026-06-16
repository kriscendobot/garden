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
title: §Synchronous-RPC-as-meta-capability
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

§Why-this-matters: synchronous RPC across worker boundaries
is a §rare-and-valuable-primitive in the JavaScript
ecosystem. Most cross-worker communication is async
(postMessage). §Atomics-based-blocking is the §only-way to
get *truly synchronous* cross-thread calls.

§This-enables-XS-debugger-style-stepping (cycle 159's
daemon-debug-worker-restart): a debugger must be able to
synchronously pause a worker and read its state.

§This-enables-Trap-in-cycle-154: the *trap* mechanism
appears synchronous to the caller, even though the actual
work happens in a different thread.

§Synthesis-target: future synchronous-RPC needs (e.g., slot
machine's blocking-mode operations) can §reuse-this-
substrate rather than reinventing.
