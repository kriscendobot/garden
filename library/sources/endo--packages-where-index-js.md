---
source: packages/where/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/where/index.js
source_branch: master
source_commit: e2b783712758f5976e504ecd6f8cb9fb20e95e7a
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 167. **Chat-lane after cycle 166's designs-lane
  break**. §Endo-source-comment-fragment genre.

  115-line file, 5 exports + 1 internal helper. §Canonical-
  path-resolution-surface for Endo across all platforms.
  §The-LOC-doesn't-reflect-the-load-bearing-knowledge.

  Three platform conventions (POSIX / macOS / Windows),
  four state domains (durable / ephemeral / sock / cache),
  two IPC mechanisms (UNIX socket / named pipe), one XDG-
  precedence pattern, one Windows-historical-env-var
  fallback chain — all encoded in 115 lines.

  **Single most structurally interesting move**: §XDG-
  precedence-with-platform-fallback-chain master pattern,
  repeated for each state domain with consistent shape:
  1. XDG env var wins regardless of platform.
  2. Branch on platform (win32 / darwin / else POSIX).
  3. Per-platform fallback chain (Windows has 4-level
     env-var precedence).

  §Four-state-domains-as-distinct-paths:
  - whereEndoState — durable (apps, capabilities, pet
    names)
  - whereEndoEphemeralState — ephemeral (PIDs, sockets at
    OS level)
  - whereEndoSock — UNIX socket / named pipe path
  - whereEndoCache — re-creatable cache

  §Cache-vs-state-split-honors-XDG-canon: XDG_STATE_HOME
  survives `rm -rf ~/.cache`; XDG_CACHE_HOME doesn't.
  §Why-PID-files-are-ephemeral: meaningless after reboot;
  XDG_RUNTIME_DIR cleared on logout means §the-OS-cleans-
  up-after-us.

  §whereHomeWindows internal helper: §four-env-var-fallback-
  chain (LOCALAPPDATA → APPDATA → USERPROFILE →
  HOMEDRIVE+HOMEPATH → info.home). Reflects §Windows-
  historical-accretion. §Earlier-vars-superseded-by-later-
  ones; code preserves backward compat.

  §Comment-with-honest-reasoning on roaming AppData:
  *Favoring local app data over roaming app data since I
  don't expect to be able to listen on one host and connect
  on another.* §TODO-named for future roaming with content-
  addressable state merge.

  §Per-platform-naming-conventions: POSIX = lowercase-with-
  dot-prefix (~/.local/state/endo); macOS = CapitalE-with-
  space (~/Library/Application Support/Endo); Windows =
  CapitalE-backslash-path. §When-in-Rome — match the
  platform's aesthetic.

  §UNIX-socket-vs-Windows-named-pipe-asymmetry: UNIX
  sockets are filesystem paths with permissions; Windows
  named pipes are kernel objects in `\\?\pipe\` namespace.
  §The-comment-is-the-load-bearing-knowledge: *Named pipes
  have a special place in Windows (and in our ashen
  hearts).* §Wry-acknowledgment-of-Windows-IPC-quirks.

  §ENDO_SOCK-override discipline: a single env var bypasses
  all platform-specific logic. §Last-resort-user-override.
  Explained-because XDG_RUNTIME_DIR is POSIX-only — Windows
  needs a separate override env var.

  §Protocol-suffix-in-socket-names (`captp0` default):
  §Reserves-the-pattern-for-future-protocols; §additive-API;
  §no-breaking-change-when-adding-new-protocols.

  §XDG_RUNTIME_DIR for ephemeral state: §canonical-tmpfs-
  cleared-on-reboot location on systemd-managed Linux;
  §OS-cleans-up-on-reboot is §intended-PID-file-and-socket-
  lifecycle.

  §Comparison-with-cycle-165's-platform-specific.md: ocap-
  kernel splits platform-specific code into separate
  *packages*; @endo/where puts §platform-specific-behavior-
  inside-the-functions and the caller is §platform-
  agnostic. §Two-strategies-for-the-same-problem.

  §Comparison-with-cycle-152's-memo-race.js: §re-creatable-
  cache-permits-purge-without-losing-state mirrors §weak-
  collections-permit-collection. §Same-discipline-different-
  scope.

  §Reading-this-file-tells-you-Endo's-deployment-shape:
  durable user data → whereEndoState; one daemon socket
  per protocol → whereEndoSock with captp0; cache for
  bundles → whereEndoCache; PID + sock during runtime →
  whereEndoEphemeralState.

  §Synthesis-target: slot machine library can §reuse-
  @endo/where rather than reinventing path resolution.

  §Tier-1 vocabulary borrowing candidates: §four-state-
  domains, §XDG-precedence-with-platform-fallback-chain,
  §protocol-suffix-in-socket-names, §ENDO_SOCK-override.

  §Named-TODO-future-design-target: §roaming-AppData-
  with-content-addressable-state-merge.

  Cycle 167 was nominally chat-lane (after cycle 166's
  designs-lane). Papers-lane blocked 61+ consecutive
  cycles.
---

> Abstract: `packages/where/index.js` (115 lines) is the
> **§canonical-path-resolution-surface** for Endo across
> all platforms. Five exports + one internal helper resolve
> four §state-domains across three platform families.
>
> **Cycle 167 — chat-lane** after cycle 166's designs-lane
> daemon-mount ingest. §Endo-source-comment-fragment genre.
>
> §Four-state-domains: durable / ephemeral / sock / cache.
> §Cache-vs-state-split-honors-XDG-canon.
>
> **Single most structurally interesting move**: §XDG-
> precedence-with-platform-fallback-chain master pattern,
> repeated for each state domain.
>
> §Per-platform-naming: POSIX lowercase-dotted, macOS
> CapitalE-with-space, Windows CapitalE-backslash.
> §When-in-Rome discipline.
>
> §UNIX-socket-vs-Windows-named-pipe asymmetry with the
> wry comment *Named pipes have a special place in Windows
> (and in our ashen hearts).*
>
> §Protocol-suffix-in-socket-names (`captp0` default) —
> §reserves-pattern-for-future-protocols.
>
> §The-LOC-doesn't-reflect-the-load-bearing-knowledge.
> §Reading-this-file-tells-you-Endo's-deployment-shape.
>
> §Tier-1 vocabulary borrowing candidates: §four-state-
> domains, §XDG-precedence-with-platform-fallback-chain,
> §protocol-suffix-in-socket-names, §ENDO_SOCK-override.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain](../sections/endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain.md) | tooling, daemon, getting-started | current |

One cohesion-honest section. §The-five-functions-form-a-
coherent-surface (uniform 3-arg signature, four state
domains, one master pattern); splitting would fragment.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@master`
  (file last touched in commit `e2b78371`).
- Author: Kris Kowal (prompted).
- Cycle 167 was nominally **chat-lane** (after cycle 166's
  designs-lane daemon-mount). Papers-lane has been blocked
  for **61+ consecutive cycles**.
- One cohesion-honest section.
