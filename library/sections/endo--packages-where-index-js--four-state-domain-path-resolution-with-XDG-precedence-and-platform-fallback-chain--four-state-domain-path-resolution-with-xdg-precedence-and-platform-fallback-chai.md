---
source: packages/where/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/where/index.js
source_path: packages/where/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
  - getting-started
genre: §endo-source-comment-fragment
cycle: 167
lane: chat
status: current
title: Four-state-domain path resolution with XDG precedence and platform-fallback chain
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

> §Chat-lane after cycle 166's designs-lane break in the
> §ocap-kernel-mini-series. §Endo-source-comment-fragment
> genre (the file is short — 115 lines — but the load-
> bearing knowledge is §where-Endo-finds-its-files-per-
> platform, which is otherwise scattered across deployment
> notes).

`packages/where/index.js` (115 lines) is the **§canonical-
path-resolution-surface** for Endo across all platforms.
Five exported functions plus one internal helper resolve
four distinct §state-domains — durable state, ephemeral
state, UNIX socket / named pipe, cache — across three
platform families — Linux/XDG, macOS, Windows.

The file's *behavior* is the load-bearing knowledge; the
*comments* are sparse but pointed. The single most
structurally interesting move is the §XDG-precedence-with-
platform-fallback-chain pattern, repeated for each state
domain with consistent shape.
