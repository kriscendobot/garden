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
title: §Five-functions-form-a-coherent-surface
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

```
whereHomeWindows  (internal helper)
whereEndoState    → durable
whereEndoEphemeralState → ephemeral (sockets + PIDs at OS level)
whereEndoSock     → IPC socket path (UNIX socket or named pipe)
whereEndoCache    → re-creatable cache
```

§Five-functions-cover-the-four-domains plus the §internal-
helper. §Each-function-takes-the-same-three-args (platform,
env, info) and §returns-a-string. §Uniformity-of-signature
makes the §callers-trivially-platform-agnostic.

§Comparison-with-cycle-165's-platform-specific.md: ocap-
kernel splits platform-specific code into separate
*packages* with conditional exports; @endo/where puts
§platform-specific-behavior-inside-the-functions and the
caller is §platform-agnostic. §Two-strategies-for-the-same-
problem.
