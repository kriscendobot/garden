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
title: Symmetric async-iterator streams with makeQueue makePipe pump and prime utilities
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

> §Chat-lane after cycle 170's designs-lane. §Endo-source-
> comment-fragment genre. §The-canonical-async-stream-
> substrate referenced by cycle 137's daemon-message-
> streaming, cycle 163's ocap-kernel glossary, and CapTP's
> wire transport.

`packages/stream/index.js` (247 lines) is the **§Endo-async-
stream-substrate**. Exports seven utilities: `makeQueue`,
`makeStream`, `makePipe`, `pump`, `prime`, `mapReader`,
`mapWriter`. The single most structurally interesting move
is the **§symmetric-stream-interface** where Reader and
Writer differ only by convention, not by structure.
