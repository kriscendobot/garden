---
title: §Removed-Files table — 8 files with §named-role per file
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
