---
title: §Removed-feature-preservation-document-genre + §Removed-Files-table (8 files with named-role) + §Architecture-Overview-with-four-layers + §nine-Detailed-Component-Descriptions + §seven-Patterns-Worth-Preserving + §Note-on-the-Next-Rendition (`@webs`-as-directory-of-pet-named-web-applications + readable-tree-as-content-addressed-static-content) + §Prompt-preserves-the-removal-instruction — endo-but-for-bots designs/weblet-next.md
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
---

# weblet-next — §removed-feature-preservation-document-genre + §Removed-Files-table + §Architecture-Overview-four-layers + §nine-Detailed-Component-Descriptions + §seven-Patterns-Worth-Preserving + §Note-on-the-Next-Rendition

## Source

- `endo-but-for-bots designs/weblet-next.md` — 454 lines
- Status: **Reference** (created 2026-03-24; §removed-feature-preservation-document)
- Author: Kris Kowal (prompted)
- Cycle 204 of `/loop resume the librarian work.` (designs-lane; alternates from cycle 203's chat-lane @endo/cache-map; §thirty-eighth consecutive designs/chat alternation cycle 166-204).

## Single most structurally interesting move

§Removed-feature-preservation-document-genre — §a-design-document-as-archaeology that preserves §what-was-removed in §enough-detail-that-it-can-be-rebuilt. §Distinct-from-typical-design-genres (proposal / reference / in-progress) — this is §"design-after-removal" with §a-named-purpose: §"intended-as-a-reference-for-anyone-rebuilding-this-functionality".

§Sibling-pattern to cycle 192 daemon-engo-supervisor (Not Started, §unrealized Go predecessor of cycle 176 endor) and cycle 200 worker-rust-xs (Not Started, §foundational predecessor) — §three-different-shapes-of-unrealized-design:
- Cycle 192 (engo-supervisor): §design-that-was-never-shipped because the team pivoted; the engo design is §still-just-the-design.
- Cycle 200 (worker-rust-xs): §design-that-was-discarded-mid-design-cycle in favor of a different approach.
- Cycle 204 (weblet-next): §design-that-was-implemented-and-then-removed; the implementation existed and was deleted.

§Cycle-204-is-the-only-one-of-the-three-where-code-was-deleted-from-the-tree. §The-Removed-Files-table is §the-archaeological-record.

## §Removed-Files table — 8 files with §named-role per file

> | File | Role |
> |------|------|
> | `packages/daemon/src/web-server-node.js` | Unified HTTP/WebSocket server and weblet factory |
> | `packages/daemon/src/web-server-node-powers.js` | HTTP server powers (port binding, WebSocket upgrade) |
> | `packages/daemon/src/web-page.js` | Browser-side bootstrap (CapTP client, bundle executor) |
> | `packages/daemon/src/interfaces/web.js` | `WebPageControllerInterface` Exo interface |
> | `packages/daemon/src/serve-private-port-http.js` | Alternate private-port HTTP server (dead code) |
> | `packages/cli/src/commands/install.js` | CLI handler for `endo install` |
> | `packages/cli/src/commands/open.js` | CLI handler for `endo open` |
> | `packages/cli/demo/cat.js` | Demo weblet (permission management UI, ~1065 lines) |

§Eight-files-enumerated with §one-line-role-per-file. §Greppable in a way that §"the weblet feature" alone is not.

§Note: §`serve-private-port-http.js` is marked §"dead code" — §honest-about-what-was-already-vestigial. §Reading-the-Removed-Files-with-roles is §the-fastest-way-to-grasp-the-removed-feature's-shape.

§Borrowable-pattern: §Removed-Files-table-with-named-role-per-file as §the-canonical-shape for §removed-feature-preservation-documents.

§The §`@apps` special formula was removed from `daemon-node.js`. §The-`specials`-mechanism-itself-is-preserved (defaults to `{}`) — §the-extension-point-survives-the-removal-of-its-content. §This-distinction matters for the §Note-on-the-Next-Rendition.

## §Architecture-Overview-with-four-layers

> 1. **CLI** (`endo install`, `endo open`) — bundled a JS file, stored it in the daemon, evaluated a formula that created a weblet, and optionally opened the resulting URL in a browser.
> 2. **Special formula** (`@apps`) — a `make-unconfined` formula injected by `daemon-node.js` that loaded `web-server-node.js` in the MAIN worker.
> 3. **Unified server** (`web-server-node.js`) — a single HTTP/WebSocket server that served all weblets and the gateway. Weblets were registered by hostname, and the server dispatched requests based on the `Host` header.
> 4. **Browser bootstrap** (`web-page.js`) — loaded in the browser, connected back to the daemon over WebSocket/CapTP, received the application bundle, and executed it with `importBundle`.

§Four-layers-with-named-role-per-layer. §The-bottom-three-are-server-side; §the-top-is-browser-side. §The-CapTP-connection-bridges-layer-3-and-layer-4 via WebSocket.

§Hostname-based dispatch is §the-load-bearing-multiplexing-mechanism — a single HTTP server multiplexes many applications.

§Borrowable-pattern: §four-layer-architecture-overview as §the-canonical-shape for §multi-layer-systems where each layer has §a-distinct-role + §a-distinct-runtime-environment.

## §Nine Detailed Component Descriptions

Each component has §a-uniform-template:
- **§Entry**: where the code is registered (e.g., `packages/cli/src/endo.js`).
- **§Handler**: the implementing file path.
- **§Arguments/Options**: table of CLI flags with descriptions.
- **§Flow**: numbered steps describing the runtime behavior.
- **§Code-snippets**: actual code preserved verbatim where structurally interesting.

§Nine-components: install / open / @apps / web-server-node / makeWeblet / web-page / web-server-node-powers / serve-private-port-http / cat.js (demo).

§Each-component is §a-self-contained-archaeological-fragment. §Reading-one-component-tells-you-its-role-without-needing-to-read-the-others.

§Borrowable-pattern: §uniform-Detailed-Component-Descriptions-template (Entry / Handler / Arguments / Flow / Code-snippets) for §multi-component-systems where each component should be §independently-comprehensible.

§Sibling-pattern to cycle 200 worker-rust-xs's §six-Implementation-Phases (each phase with named test cases) and cycle 196 endoclaw's §thirteen-feature-categories (each with status). §Different-shapes for §different-purposes: 200 names §future-work; 196 names §inventory-comparison; 204 names §archaeological-fragments.

## §Seven Patterns Worth Preserving

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

## §Note-on-the-Next-Rendition

> The next iteration may use a special named `@webs` — a directory where each entry is a registered local HTTP web application, keyed by pet name. Each entry would combine some powers with a readable filesystem, producing a served web application.
>
> The filesystem should probably be restricted to a `readable-tree` so that the content address can be passed to a static file server. A readable-tree is immutable and content-addressed, which means the server can serve files without needing ongoing access to mutable storage — it just needs the tree's formula identifier.

§The-next-rendition-named-but-not-designed-in-this-document. §`@webs` is §the-proposed-successor-special-name (vs `@apps` in the removed version). §The-shape-is-§a-directory-keyed-by-pet-name (vs §an-unstructured-collection in the removed version).

§Readable-tree-as-content-addressed-static-content is §the-load-bearing-shift. §The-server-can-serve-files-without-needing-ongoing-access-to-mutable-storage — §it-just-needs-the-tree's-formula-identifier.

§Sibling-pattern to cycle 202 endor-run-expanded's §root-hash-printed-to-stderr (CAS-content-addressing as §the-hash-becomes-the-handle) and cycle 178 daemon-xs-worker-snapshot's §CAS-streaming-snapshot. §Three-cycles converging on §content-addressed-storage as §the-substrate-for-stateless-or-quasi-stateless-services.

§Future-direction-named: §"static-and-dynamic-routing-rules + dynamic-content" for §applications-defining-server-side-behavior-beyond-static-file-serving. §First-pass-static-serving-from-a-readable-tree is §sufficient.

§Borrowable-pattern: §Note-on-the-Next-Rendition as §a-section-shape in §removed-feature-preservation-documents — §forward-looking-shape-without-commitment.

## §Prompt-section preserves the removal instruction

> Remove the "install" command in the CLI and the "weblet" feature in the daemon. Leave a design, based on insights about the current design, about how to reconstruct this feature. Capture a detailed description of the erstwhile weblet design, such that the portions we have abandoned can be reused.

§The-maintainer's-instruction-quoted-verbatim. §Three-named-tasks: §remove-the-feature + §leave-a-design-for-reconstruction + §capture-a-detailed-description-of-the-erstwhile-design.

§Sibling-pattern to cycle 200 worker-rust-xs's §Prompt-section-preserves-discard-prior-design-narrative — both designs §preserve-the-maintainer's-narrative for §future-readers-to-understand-the-decision-shape.

§The-difference: §cycle-200-preserved-a-design-discard-instruction; §cycle-204-preserved-a-feature-removal-instruction. §Two-different-kinds-of-decisions, §both-recorded-honestly-in-the-Prompt-section.

## §Honest-design-evolution-record family — extended

This cycle's design extends the §honest-design-evolution-record family (cycles 178/180/183/184/188/192/196/197/198/200/200) with §a-new-shape: §a-document-that-records-a-feature-removal-decision and §preserves-the-removed-code's-shape-for-future-reconstruction.

§Eleven-now-twelve-members of the family across §different-evolution-shapes:
- Cycle 178: §Revised-scope-2026-04-15.
- Cycle 180: hex-package §design-after-implementation-as-ratification.
- Cycle 183: init+lockdown §NOTE-TO-REVIEWERS pattern.
- Cycle 184: daemon-xs-worker-metering §design-evolution-realization in Prompt section.
- Cycle 188: daemon-rust-xs-performance §Working-copy-inventory section.
- Cycle 192: daemon-engo-supervisor §implicit-supersedes-lesson-learned (engo never shipped).
- Cycle 196: endoclaw §inline-co-author-quote-blocks for editorial-disagreement-preserved.
- Cycle 197: panic README §historical-note-as-retroactive-justification.
- Cycle 198: patterns-diagnostic-feedback §three-revision-pivots visible in Prompt section.
- Cycle 200 (retention-path-notation): §Reference-status-at-landing (pre-emptive-supersedes).
- Cycle 200 (hardened-url-shim): §Comparison-to-the-original-`@endo/url`-package-proposal section.
- Cycle 200 (worker-rust-xs): §Prompt-section-preserves-discard-prior-design-narrative.
- Cycle 204 (this cycle): §removed-feature-preservation-document-genre with §Prompt-section-preserves-the-removal-instruction.

§Twelfth-family-member at §the-most-extreme-end of the spectrum — §the-implementation-existed-and-was-deleted. §Other-family-members preserve §unrealized-or-discarded-design-narrative; §cycle-204 preserves §deleted-code's-shape.

## §Borrowable patterns (tier-1)

1. **§Removed-feature-preservation-document-genre** as §a-design-document-as-archaeology distinct from proposal/reference/in-progress. §Purpose-named-explicitly: "intended as a reference for anyone rebuilding this functionality".
2. **§Removed-Files-table with named-role-per-file** as §the-canonical-shape — greppable, scannable, one-line-per-file.
3. **§Architecture-Overview-with-N-layers** with §named-role-per-layer for §multi-layer-systems.
4. **§Uniform-Detailed-Component-Descriptions-template** (Entry / Handler / Arguments / Flow / Code-snippets) for §multi-component-systems where each component should be §independently-comprehensible.
5. **§Seven-Patterns-Worth-Preserving section** with §a-reusable-shape per pattern — extracts §the-load-bearing-discipline from §the-removed-code into §a-portable-fragment.
6. **§The `specials` extension point** — special names become first-class daemon capabilities via host's pet store, no per-host configuration needed.
7. **§Distinguishing extension-point from extension-content** — `@apps`-content removed; `specials`-mechanism preserved. The §extension-point survives §the-removal-of-its-content.
8. **§CapTP-over-WebSocket** with §map-writer / map-reader composition for §CapTP-over-arbitrary-byte-stream.
9. **§Hostname-based dispatch** with §`{ respond, connect }`-handler-pairs-per-hostname + §cleanup-on-cancellation.
10. **§Access-token-derivation-from-formula-ID** (first 32 chars) for §deterministic-unforgeable-tokens-without-additional-state.
11. **§Per-key-next-allowed-timestamp-with-lazy-sweeping** for §minimal-zero-dependency-rate-limiter without timer overhead.
12. **§Promise.race-between-transport-close-and-CapTP-close** + §connectionClosedPromises-set + §await-all-on-cancellation for §graceful-shutdown.
13. **§Browser-endowment-collection** via §collectPropsAndBind (prototype-chain-traversal + method-binding + Compartment-conflict-exclusion).
14. **§Note-on-the-Next-Rendition section** as §forward-looking-shape-without-commitment in §removed-feature-preservation-documents.
15. **§Prompt-section preserves the maintainer's instruction** — sibling to cycle 200 worker-rust-xs's §Prompt-preserves-discard-prior-design-narrative.
16. **§Honest-self-critique-in-design-archaeology** — the design questions its own preserved patterns ("the new design should consider whether hostname-only isolation eliminates the need for explicit tokens").
17. **§Readable-tree-as-content-addressed-static-content** for §static-file-server-without-ongoing-mutable-storage-access — §the-tree's-formula-identifier-is-all-the-server-needs.
18. **§`@webs`-as-directory-of-pet-named-web-applications** with each entry combining §powers + §readable-filesystem as §the-shape-of-the-next-rendition.

## §Synthesis-target

Slot machine library §removed-feature-archaeology for §previously-experimented-game-modes:

- §Removed-Files-table with §named-role-per-file borrowable directly for §removing-game-modes-cleanly while §preserving-the-design-shape for future iteration.
- §Seven-Patterns-Worth-Preserving section borrowable for §extracting-load-bearing-discipline from §removed-code into §portable-fragments.
- §Note-on-the-Next-Rendition borrowable for §forward-looking-shape-without-commitment in §game-mode-archaeology-documents.

§Access-token-derivation-from-capability-identity borrowable for §unforgeable-game-session-tokens without per-session state table — the token derived from §the-game-session's-formula-identifier or §the-player's-capability-id.

§Per-key-next-allowed-timestamp-with-lazy-sweeping borrowable for §rate-limiting-bet-attempts without timer overhead — minimal, zero-dependency.

§Hostname-based-dispatch borrowable for §multi-tenant-game-server where §each-game-room is §a-hostname-keyed-handler-pair.

§Connection-lifecycle-tracking with Promise.race borrowable for §game-session-cleanup where §multiple-close-events-can-end-the-session (player disconnect + game timeout + admin termination).

§Browser-endowment-collection borrowable for §game-client-sandbox where §the-game-client-needs-browser-like-endowments-in-a-Compartment.

§Readable-tree-as-content-addressed-static-content borrowable for §static-game-assets (board layouts, card art, sound clips) served without ongoing mutable-storage access.

## §Cycle 204 meta-observations

§The-thirty-eighth-consecutive-designs/chat-alternation-cycle 166-204.

§Papers-lane-blocked 98+ consecutive cycles (since cycle ~106). §The-papers-lane-block is now §nearly-half-of-the-total-cycle-count.

§Library-reaches-709-sections at cycle 204.

§Library-protocol-from-cycle-200 applied: §grep-by-source-page-existence with `endo-but-for-bots--llm-designs-weblet-next` full slug — §no-prior-ingest-found. Confirmed before drafting.

§Honest-design-evolution-record family extended to §twelve-members with §a-new-shape: §deleted-code's-shape-preserved-for-reconstruction. §The-most-extreme-form of honest-design-evolution — §the-feature-existed-and-was-deleted, with the design document acting as §archaeological-record.

§Sibling-cluster to cycle 196 endoclaw (Reference; inventory document) and cycle 200 retention-path-notation (Reference; pre-emptive-supersedes) — §three-different-shapes-of-Reference-status:
- 196: §inventory-document for §comparison-with-OpenClaw.
- 200 (retention-path-notation): §captured-for-reference at landing because the narrower sibling was the implementable slice.
- 204 (weblet-next): §preservation-document for §removed-implementation.

§Three-different-purposes for §Reference-status. §The-status-tag-is-broader-than-any-single-purpose.

§The-readable-tree-as-content-addressed-static-content concept connects to cycle 202 endor-run-expanded's §root-hash-printed-to-stderr (CAS-content-addressing). §Cycle-204-Note-on-the-Next-Rendition points to §the-readable-tree-substrate that §cycle-178-snapshot and §cycle-202-archive-loading both use. §Convergence on §content-addressed-storage as §the-substrate-for-stateless-services across the endor family.
