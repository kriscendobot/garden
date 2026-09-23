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
title: §Endo's-overall-state-shape implied
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

Reading this file tells you Endo's deployment shape:

- **Durable user data**: pet names, capabilities, apps,
  bundles — under `whereEndoState`.
- **One daemon socket per protocol**: `whereEndoSock` with
  `protocol='captp0'` is the well-known address.
- **Cache for compiled bundles**: `whereEndoCache` is the
  re-creatable artifact store.
- **PID file + sock during runtime**: under
  `whereEndoEphemeralState`.

§The-shape-of-the-runtime-is-readable-from-the-paths.
§Reading-this-file-tells-you-how-Endo-organizes-itself.
