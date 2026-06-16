---
source: packages/stream/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/stream/index.js
source_path: packages/stream/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 171
lane: chat
status: current
title: §Synthesis-target
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

The §symmetric-stream-interface pattern is borrowable:
when designing a two-ended async protocol, consider
whether the two ends can be §structurally-identical-
differing-only-by-convention. §Less-code-than-asymmetric-
shapes.

§makePipe-from-two-queues idiom: when you need a paired
channel, build it from two opposing queues. §The-pipe-is-
just-cross-wiring.

§Slot machine library will need stream-like primitives for
its game-state-stream and player-action-stream. §Reuse-
this-substrate.
