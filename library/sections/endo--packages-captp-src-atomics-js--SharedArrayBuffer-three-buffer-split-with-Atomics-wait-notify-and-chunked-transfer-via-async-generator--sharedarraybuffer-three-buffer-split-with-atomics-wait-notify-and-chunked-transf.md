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
title: SharedArrayBuffer three-buffer split with Atomics wait/notify and chunked transfer via async generator
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

> §Chat-lane after cycle 168's designs-lane. §Endo-source-
> comment-fragment genre. §Pair-with-cycle-154's-trap.js
> — that file defines `TrapHost` / `TrapGuest` as the
> abstract interface; this file is the SharedArrayBuffer
> implementation.

`packages/captp/src/atomics.js` (170 lines) is the
**§SharedArrayBuffer-as-synchronous-RPC-transport** for
@endo/captp's Trap mechanism. The single most structurally
interesting move is the §three-buffer-split-in-one-
SharedArrayBuffer paired with §Atomics-wait-notify-for-
blocking-RPC. The §load-bearing-premise: SharedArrayBuffer +
Atomics = blocking RPC across worker boundaries.
