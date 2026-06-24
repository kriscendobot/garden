---
title: §Architecture-Overview-with-four-layers
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

> 1. **CLI** (`endo install`, `endo open`) — bundled a JS file, stored it in the daemon, evaluated a formula that created a weblet, and optionally opened the resulting URL in a browser.
> 2. **Special formula** (`@apps`) — a `make-unconfined` formula injected by `daemon-node.js` that loaded `web-server-node.js` in the MAIN worker.
> 3. **Unified server** (`web-server-node.js`) — a single HTTP/WebSocket server that served all weblets and the gateway. Weblets were registered by hostname, and the server dispatched requests based on the `Host` header.
> 4. **Browser bootstrap** (`web-page.js`) — loaded in the browser, connected back to the daemon over WebSocket/CapTP, received the application bundle, and executed it with `importBundle`.

§Four-layers-with-named-role-per-layer. §The-bottom-three-are-server-side; §the-top-is-browser-side. §The-CapTP-connection-bridges-layer-3-and-layer-4 via WebSocket.

§Hostname-based dispatch is §the-load-bearing-multiplexing-mechanism — a single HTTP server multiplexes many applications.

§Borrowable-pattern: §four-layer-architecture-overview as §the-canonical-shape for §multi-layer-systems where each layer has §a-distinct-role + §a-distinct-runtime-environment.
