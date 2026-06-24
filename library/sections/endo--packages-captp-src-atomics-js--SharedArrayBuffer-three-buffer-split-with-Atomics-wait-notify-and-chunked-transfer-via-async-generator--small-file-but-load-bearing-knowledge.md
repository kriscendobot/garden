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
title: §Small-file-but-load-bearing-knowledge
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

170 lines. Encodes:
- §SharedArrayBuffer-three-buffer-split shape.
- §Atomics.wait-notify usage pattern.
- §Async-generator chunking protocol.
- §Iterator-protocol-as-bidirectional-channel.
- §JSON-encoding-then-UTF-8-bytes layering.
- §Two-status-bit-flags (DONE / REJECT) plus initial WAITING.

§Reading-this-file-tells-you-how-Trap-works across worker
boundaries. §Sibling-observation to cycle 167's where/
index.js and cycle 165's platform-specific.md: small docs
can encode large knowledge.
