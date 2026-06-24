---
title: "§Library-scope: first compartment-mapper ingest"
source-slug: endo--packages-compartment-mapper-src-generic-graph
section-id: Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution
url: https://github.com/endojs/endo/blob/master/packages/compartment-mapper/src/generic-graph.js
authors: [Endo contributors; portions from datavis-tech/graph-data-structure by Curran Kelleher]
repo: endojs/endo
path: packages/compartment-mapper/src/generic-graph.js
total-lines: 326
status: shipping
ingest-cycle: 235
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution
---

The @endo/compartment-mapper package has been referenced as a §heavy-machinery-substrate in many cycles but never ingested directly:
- Cycle 200 worker-rust-xs (§XS-hosted compartment-mapper).
- Cycle 202 endor-run-expanded (uses compartment-mapper).
- Cycle 221 @endo/bundle-source (§thin-dispatch-layer over compartment-mapper).
- Cycle 230 endor-npm-registry-proxy (Phase 4 integration with compartment mapper).

§Cycle-235 is §the-first-direct-ingest from `@endo/compartment-mapper/src/`. §The-package-IS-the-foundational-machinery + §the-thin-dispatchers-have-been-ingested-first.

§Borrowable-pattern: §when-a-package-is-foundational-machinery, §ingest-its-thin-dispatchers-first + §work-down-to-the-heavy-files-over-time. §The-library-builds-up-the-shape-of-the-package-from-its-edges-inward.
