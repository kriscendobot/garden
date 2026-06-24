---
title: §Note-on-the-Next-Rendition
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

> The next iteration may use a special named `@webs` — a directory where each entry is a registered local HTTP web application, keyed by pet name. Each entry would combine some powers with a readable filesystem, producing a served web application.
>
> The filesystem should probably be restricted to a `readable-tree` so that the content address can be passed to a static file server. A readable-tree is immutable and content-addressed, which means the server can serve files without needing ongoing access to mutable storage — it just needs the tree's formula identifier.

§The-next-rendition-named-but-not-designed-in-this-document. §`@webs` is §the-proposed-successor-special-name (vs `@apps` in the removed version). §The-shape-is-§a-directory-keyed-by-pet-name (vs §an-unstructured-collection in the removed version).

§Readable-tree-as-content-addressed-static-content is §the-load-bearing-shift. §The-server-can-serve-files-without-needing-ongoing-access-to-mutable-storage — §it-just-needs-the-tree's-formula-identifier.

§Sibling-pattern to cycle 202 endor-run-expanded's §root-hash-printed-to-stderr (CAS-content-addressing as §the-hash-becomes-the-handle) and cycle 178 daemon-xs-worker-snapshot's §CAS-streaming-snapshot. §Three-cycles converging on §content-addressed-storage as §the-substrate-for-stateless-or-quasi-stateless-services.

§Future-direction-named: §"static-and-dynamic-routing-rules + dynamic-content" for §applications-defining-server-side-behavior-beyond-static-file-serving. §First-pass-static-serving-from-a-readable-tree is §sufficient.

§Borrowable-pattern: §Note-on-the-Next-Rendition as §a-section-shape in §removed-feature-preservation-documents — §forward-looking-shape-without-commitment.
