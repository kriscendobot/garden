---
title: §Borrowable patterns (tier-1)
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
