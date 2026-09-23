---
source: packages/where/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/where/index.js
source_branch: master
source_commit: e2b783712758f5976e504ecd6f8cb9fb20e95e7a
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
re-ingested: 2026-06-15
ingested_by: scholar (cycle 167) + liaison (cycle 348)
section_count: 2
status: current
notes: |
  **Two ingest cycles** — cycle 167 (algorithm-and-vocabulary
  lens) + cycle 348 (implementation-pattern lens; EIGHTH
  complementary-lens re-ingest). The cycle 167 section
  named the algorithm and core vocabulary; the cycle 348
  section elevates the cross-function consistency to tier-3
  meta-patterns and adds cross-cycle comparisons.

  ## Cycle 167 lens (algorithm + vocabulary)

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

  ## Cycle 348 lens (implementation-pattern + cross-cycle)

  Cycle 348 chat-lane after cycle 347 designs-lane @endo/
  where README. FOURTEENTH INSTANCE of one-cycle README↔
  source pattern; EIGHTH complementary-lens re-ingest (after
  322 + 324 + 330 + 332 + 336 + 342 + 344 + 348); §eight-
  cycles-with-named-complementary-lens-re-ingest.

  Single most structurally interesting move in cycle 348:
  §the-named-cross-platform-spec-FIRST-platform-native-
  FALLBACK-discipline — the IMPLEMENTATION of cycle 347
  README's policy ("XDG first; native fallback"); cycle 348
  reveals it applied UNIFORMLY across all four functions
  (whereEndoState + whereEndoEphemeralState + whereEndoSock
  + whereEndoCache); §the-named-XDG-FIRST-platform-SECOND-
  fallback-pattern; §the-named-policy-uniformly-applied-
  across-functions-discipline as tier-3 meta-pattern.

  Other elevations to tier-3 meta-patterns: §the-named-Endo-
  canonical-storage-taxonomy (four-category: State +
  Ephemeral + Sock + Cache); §the-named-progressive-
  degradation-fallback (five-step Windows-home fallback
  chain); §the-named-XDG-doesnt-fit-so-we-invent-our-own
  (ENDO_SOCK custom env var); §the-named-protocol-version-
  in-path-for-coexistence; §the-named-pure-function-by-
  injection (testable + portable via env + info parameters);
  §the-named-separate-types-d-ts-for-public-API-types.

  Cross-cycle comparisons added:
  - §two-cycles-with-named-project-prefix-env-var (cycle 342
    LOCKDOWN_OPTIONS + cycle 348 ENDO_SOCK)
  - §two-shapes-of-emotional-tone-in-source-comments (cycle
    337 precise-without-pejorative + cycle 348 ashen-hearts-
    emotional-frustration)
  - §two-shapes-of-environment-access (cycle 342 direct-
    globals + cycle 348 injection-of-env-and-info)

  Closes five citation arcs: cycle 347 (1 cycle) + cycle 167
  (181 cycles, complementary-lens self-arc) + cycle 187 (161
  cycles) + cycle 342 (6 cycles) + cycle 337 (11 cycles).
  Pushes citation-arc-closures-in-pivot to ONE-HUNDRED-
  THIRTY (125 + 5 net new).
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
| [four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain](../sections/endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain.md) | tooling, daemon, getting-started | current (cycle 167, algorithm + vocabulary lens) |
| [eighth-complementary-lens-XDG-first-platform-second-fallback-and-Endo-canonical-storage-taxonomy](../sections/endo--packages-where-index-js--eighth-complementary-lens-XDG-first-platform-second-fallback-and-Endo-canonical-storage-taxonomy.md) | hardened-javascript-tooling, locator-discipline, cross-platform-spec-vs-native-fallback, storage-taxonomy, complementary-lens-re-ingest | current (cycle 348, implementation-pattern + cross-cycle lens) |

**Two cohesion-honest sections** from two complementary lenses: cycle 167 algorithm-and-vocabulary view (the algorithm + the four state-domains + the platform-specific paths) + cycle 348 implementation-pattern + cross-cycle view (the uniform discipline applied across functions + tier-3 meta-patterns + cross-cycle comparisons).

## Provenance

- Fetched 2026-06-03 from `endojs/endo@master` (file last touched in commit `e2b78371`).
- Author: Kris Kowal (prompted).
- Cycle 167 was nominally **chat-lane** (after cycle 166's designs-lane daemon-mount). Papers-lane has been blocked for **61+ consecutive cycles** at that point.
- **Re-ingested 2026-06-15 in cycle 348** as the **EIGHTH complementary-lens re-ingest** (after cycles 322 + 324 + 330 + 332 + 336 + 342 + 344). Cycle 348 takes the implementation-pattern lens; the cycle 167 section took the algorithm-and-vocabulary lens.
- **Two cohesion-honest sections** from two complementary lenses.
