---
title: §Synthesis-target
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
