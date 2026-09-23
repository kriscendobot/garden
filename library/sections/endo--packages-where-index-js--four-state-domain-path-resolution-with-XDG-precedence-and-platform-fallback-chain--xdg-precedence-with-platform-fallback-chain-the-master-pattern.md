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
title: §XDG-precedence-with-platform-fallback-chain (the master pattern)
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

Every resolver follows the same §three-tier-decision-tree:

1. **§XDG-env-var-wins**: if `XDG_STATE_HOME` (or
   `XDG_CACHE_HOME` / `XDG_RUNTIME_DIR`) is set, use
   `${XDG}/endo` regardless of platform.
2. **§Per-platform-default**: branch on `platform === 'win32'`
   / `platform === 'darwin'` / else (POSIX).
3. **§Per-platform-fallback-chain**: each platform's branch
   itself has fallbacks (especially Windows, which has 4-
   level env-var precedence).

§The-user-can-always-override-via-XDG. §The-platform-
defaults-respect-the-platform's-conventions. §The-fallback-
chains-never-leave-the-user-without-a-path.

§Cycle-165's-platform-obvious-vs-platform-implicit-exports
(ocap-kernel) is a sibling discipline at the package layer;
this is the analog at the §runtime-environment-layer:
§platform-conditional-behavior-encoded-as-a-three-tier-
decision-tree.
