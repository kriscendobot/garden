---
title: §Nine Detailed Component Descriptions
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
