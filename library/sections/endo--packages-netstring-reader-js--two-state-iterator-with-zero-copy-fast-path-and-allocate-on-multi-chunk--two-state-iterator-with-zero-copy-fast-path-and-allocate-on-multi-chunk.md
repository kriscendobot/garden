---
source: packages/netstring/reader.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/netstring/reader.js
source_path: packages/netstring/reader.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mathieu Hofman (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 177
lane: chat
status: current
title: Two-state iterator with zero-copy fast-path and allocate-on-multi-chunk
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

> §Chat-lane after cycle 176's designs-lane. §Endo-source-
> comment-fragment genre. §The-canonical-netstring-decoder
> used by daemon socket framing (cycle 49 + cycle 176
> endor's client bridging), daemon-cas-management's
> envelope-bus (cycle 141), and OCapN-TCP-syrups-framing
> (cycle 174 dependency).

`packages/netstring/reader.js` (163 lines) decodes
**netstrings** — `<length>:<data>,` — from an async byte
stream. The single most structurally interesting move is
the §two-state-iterator (waiting-for-length-prefix /
waiting-for-data) with §zero-copy-fast-path and §allocate-
on-multi-chunk discipline.
