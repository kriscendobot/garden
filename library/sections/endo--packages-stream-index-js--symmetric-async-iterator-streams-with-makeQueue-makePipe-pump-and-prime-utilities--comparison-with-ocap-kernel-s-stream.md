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
title: §Comparison with ocap-kernel's stream
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

> *§Channel = communication-pathway; §stream = remote-async-
> iterator from @endo/stream (shared substrate)* (from
> cycle 163's glossary section).

§Vocabulary-drift-where-substrate-is-shared (cycle 163
named this).

| System | Term | Meaning |
|--------|------|---------|
| ocap-kernel | channel | bidirectional comm pathway |
| ocap-kernel | stream | unidirectional async iterator |
| @endo/stream | Stream | symmetric (Reader OR Writer) |
| @endo/captp | connection | bidirectional CapTP wire |

§Three-different-vocabularies for §two-or-three-different-
things. The §symmetric-stream from this file is more
general than ocap-kernel's *stream* (which is
unidirectional).

§Synthesis-target: clarifying the relationship between
§Reader/Writer/Pipe in @endo/stream and §unidirectional-
stream / §bidirectional-channel in ocap-kernel could help
the OCapN specification.
