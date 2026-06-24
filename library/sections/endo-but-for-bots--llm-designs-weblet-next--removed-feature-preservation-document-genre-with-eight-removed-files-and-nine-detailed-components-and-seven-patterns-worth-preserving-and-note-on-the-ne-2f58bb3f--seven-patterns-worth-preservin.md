---
title: §Seven Patterns Worth Preserving
source: endo-but-for-bots designs/weblet-next.md
source-slug: endo-but-for-bots--llm-designs-weblet-next
ingest-cycle: 204
ingest-date: 2026-06-06
lane: designs
status: Reference (2026-03-24; removed-feature-preservation-document)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-daemon-weblet-application (forward-looking successor design)
  - endo-but-for-bots--llm-designs-familiar-unified-weblet-server (forward-looking successor design)
  - endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting (forward-looking successor design)
  - endo-but-for-bots--llm-designs-endo-gateway (gateway-package design that this design's removed rate-limiter pattern inspires)
  - endo-but-for-bots--llm-designs-endor-run-expanded (cycle 202; the readable-tree-content-addressing kinship)
  - endo-but-for-bots--llm-designs-daemon-cas-management (CAS-as-content-addressed-storage; this design's @webs-readable-tree-future-direction)
  - endo--packages-captp (the CapTP-over-WebSocket pattern named as worth-preserving)
  - endo-but-for-bots--llm-designs-daemon-engo-supervisor (cycle 192; another §unrealized-design — different shape but same family)
  - endo-but-for-bots--llm-designs-worker-rust-xs (cycle 200; another §unrealized-design; both name forward-looking successors)
keywords:
  - removed-feature-preservation-document genre
  - design-as-archaeology
  - Removed-Files table with named-role per file
  - four-layer architecture (CLI / special-formula / unified-server / browser-bootstrap)
  - nine Detailed Component Descriptions
  - seven Patterns Worth Preserving
  - the specials extension-point
  - CapTP-over-WebSocket pattern
  - hostname-based dispatch (single HTTP server multiplexes many applications)
  - access-token-derivation from formula-ID (deterministic unforgeable token without additional state)
  - rate-limiting-via-per-key-next-allowed-timestamp-with-lazy-sweeping
  - connection-lifecycle-tracking with connectionClosedPromises set
  - browser-endowment-collection (collectPropsAndBind traversing prototype chain)
  - Note-on-the-Next-Rendition (forward-looking shape)
  - @webs-as-directory-of-pet-named-web-applications
  - readable-tree-as-content-addressed-static-content
  - Prompt-section preserves the removal instruction from the maintainer
  - cycle 204 designs-lane
  - thirty-eighth consecutive designs/chat alternation cycle 166-204
parent: endo-but-for-bots--llm-designs-weblet-next--removed-feature-preservation-document-genre-with-eight-removed-files-and-nine-detailed-components-and-seven-patterns-worth-preserving-and-note-on-the-next-rendition
---

§The-design's-most-valuable-section. §Seven-explicitly-named-patterns extracted from the removed implementation, each with §a-reusable-shape:

### 1. §The `specials` extension point

> The mechanism for injecting platform-specific formulas via `specials` in `makeDaemon` is clean and general. The new web application formula can reuse it. The key insight is that special names become available in every host's pet store via `makePetSitter`, making them first-class daemon capabilities without requiring per-host configuration.

§First-class-daemon-capabilities-without-per-host-configuration via §special-formula-injection. §Sibling to cycle 105 daemon-capability-bank's §Design-Principle-1 (capabilities are objects, not configurations) — §the-`specials`-mechanism is §the-injection-point for §canonical-platform-capabilities.

§Note: §`@apps`-specific-name-was-removed but §the-`specials`-mechanism-survived. §Distinguishing §extension-point from §extension-content is §the-load-bearing-distinction for §removed-feature-preservation.

### 2. §CapTP over WebSocket

The `makeMessageCapTP` wrapper combined with `mapWriter(frameWriter, messageToBytes)` and `mapReader(frameReader, bytesToMessage)` provides §a-clean-abstraction-for-CapTP-over-any-byte-stream. The `openCapTPSession` helper showed §setup-with-connection-tracking-and-heartbeat-ping.

§Borrowable-pattern: §map-writer / map-reader composition for §CapTP-over-arbitrary-byte-stream.

### 3. §Hostname-based dispatch

> The unified server's `webletHandlers` map keyed by hostname demonstrated how a single HTTP server can multiplex many applications. The pattern of registering `{ respond, connect }` handler pairs per hostname, with cleanup on cancellation, is directly reusable.

§Single-HTTP-server-multiplexes-many-applications via §hostname-keyed-handler-map with §respond-and-connect-pair per host + §cleanup-on-cancellation.

§Borrowable-pattern: §hostname-based-dispatch with §handler-pair-per-hostname + §cleanup-on-cancellation.

### 4. §Access token derivation

> Deriving the access token from the formula ID (first 32 chars) provided a deterministic, unforgeable token without additional state. For dedicated ports this was used as a path prefix; for the unified server it was the hostname key. The new design should consider whether hostname-only isolation (via port or virtual host) eliminates the need for explicit tokens.

§Deterministic-unforgeable-token-without-additional-state via §first-32-chars-of-formula-ID. §No-state-table-needed; §the-token-is-derived-from-the-capability-identity. §Sibling-pattern to cycle 175 harden-selector's §race-to-install-at-well-known-slot — §both-derive-stable-identifiers-from-structure-not-from-allocation.

§Note: §the-design-explicitly-questions-its-own-pattern in the next-rendition: §"whether-hostname-only-isolation-(via-port-or-virtual-host)-eliminates-the-need-for-explicit-tokens" — §honest-self-critique-in-design-archaeology.

§Borrowable-pattern: §access-token-derivation-from-capability-identity for §unforgeable-tokens-without-additional-state.

### 5. §Rate limiting for gateway fetch

> The `makeRateLimiter` pattern (per-key next-allowed timestamp with lazy sweeping) is a minimal, zero-dependency rate limiter suitable for protecting capability-granting endpoints.

§Per-key-next-allowed-timestamp-with-lazy-sweeping — §minimal-zero-dependency. §Each-key tracks §when-it-can-next-be-allowed; §lazy-sweeping-cleans-stale-entries on access rather than via a separate timer.

§Borrowable-pattern: §per-key-next-allowed-timestamp-with-lazy-sweeping for §minimal-rate-limiter-without-timer-overhead.

### 6. §Connection lifecycle tracking

> The pattern of maintaining a `connectionClosedPromises` set and awaiting all on cancellation ensured graceful shutdown. Each connection tracked both its transport close and its CapTP close:
>
> ```js
> trackConnection(
>   Promise.race([connectionClosed, capTpClosed]),
>   `Closed connection ${connectionNumber}`,
> );
> ```

§Promise.race-between-transport-close-and-CapTP-close captures §the-first-close-event from either side. §The-connectionClosedPromises-set + §await-all-on-cancellation ensures §graceful-shutdown.

§Sibling-pattern to cycle 156 finalize.js's §weak-value-map-GC discipline — both designs §track-resources-so-cleanup-is-deterministic.

§Borrowable-pattern: §Promise.race-for-first-close-event + §promise-set-for-await-all-on-cancellation.

### 7. §Browser endowment collection

> `collectPropsAndBind(window)` traversed the prototype chain, bound methods to `window`, and excluded Compartment-conflicting globals. This is necessary for any future code that needs to provide a browser-like endowment set to a Compartment-based sandbox.

§Prototype-chain-traversal + §method-binding + §Compartment-conflict-exclusion as §three-step-endowment-collection. §The-result is §a-browser-like-endowment-set-suitable-for-a-Compartment.

§Sibling-pattern to cycle 161 daemon-capability-filesystem's §three-layer-architecture (Guest / Composition / Backends) — both designs §provide-host-API-to-a-Compartment-with-confinement-discipline.

§Borrowable-pattern: §collectPropsAndBind for §browser-like-endowment-collection-for-Compartments.
