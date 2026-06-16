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
title: §Cycle-152-memo-race.js GC-friendliness sibling observation
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

Cycle 152's memo-race.js noted §promise-kit's-GC-friendly-
collection-semantics. §where/index.js has an analog at the
filesystem layer: §re-creatable-cache-in-XDG_CACHE-permits-
purge-without-losing-state, mirroring §weak-collections-
permit-collection-without-losing-strong-references.

§Same-discipline-different-scope: at the heap layer, §weak-
collections-don't-keep-things-alive. At the filesystem
layer, §cache-can-be-purged-without-losing-state.
