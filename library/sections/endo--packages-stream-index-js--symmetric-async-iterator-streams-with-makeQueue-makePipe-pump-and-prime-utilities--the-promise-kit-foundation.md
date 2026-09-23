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
title: §The-promise-kit-foundation
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

This file uses `makePromiseKit` from `@endo/promise-kit`
(cycle 152's memo-race.js sibling). §Promise-kit-is-the-
substrate. §Every-cons-cell-uses-a-promise-kit.

§Cycle-152's-memo-race is for racing-with-cleanup; this
file's makeQueue is for sequencing-with-back-pressure.
§Two-promise-based-async-primitives in the @endo
ecosystem.
