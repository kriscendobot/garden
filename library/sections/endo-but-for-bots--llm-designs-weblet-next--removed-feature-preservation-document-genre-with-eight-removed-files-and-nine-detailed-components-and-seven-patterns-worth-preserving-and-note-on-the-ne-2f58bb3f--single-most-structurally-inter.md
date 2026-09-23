---
title: Single most structurally interesting move
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

§Removed-feature-preservation-document-genre — §a-design-document-as-archaeology that preserves §what-was-removed in §enough-detail-that-it-can-be-rebuilt. §Distinct-from-typical-design-genres (proposal / reference / in-progress) — this is §"design-after-removal" with §a-named-purpose: §"intended-as-a-reference-for-anyone-rebuilding-this-functionality".

§Sibling-pattern to cycle 192 daemon-engo-supervisor (Not Started, §unrealized Go predecessor of cycle 176 endor) and cycle 200 worker-rust-xs (Not Started, §foundational predecessor) — §three-different-shapes-of-unrealized-design:
- Cycle 192 (engo-supervisor): §design-that-was-never-shipped because the team pivoted; the engo design is §still-just-the-design.
- Cycle 200 (worker-rust-xs): §design-that-was-discarded-mid-design-cycle in favor of a different approach.
- Cycle 204 (weblet-next): §design-that-was-implemented-and-then-removed; the implementation existed and was deleted.

§Cycle-204-is-the-only-one-of-the-three-where-code-was-deleted-from-the-tree. §The-Removed-Files-table is §the-archaeological-record.
