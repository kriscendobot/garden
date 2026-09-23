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
title: §Protocol-suffix in socket names
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

```js
export const whereEndoSock = (platform, env, info, protocol = 'captp0') => {
```

§Protocol-defaults-to-captp0. §Reserves-the-pattern-for-
future-protocols. §Future-Endo-might-host-CapTP-1-or-OCapN
on separate sockets simultaneously; §the-default-name-is-
captp0-now-but-the-shape-supports-versioning.

§Protocol-as-fourth-arg-with-default: §additive-API. Callers
that don't pass it get §captp0 (the current default);
callers that do can request a different protocol's socket
path. §No-breaking-change-when-adding-new-protocols.
