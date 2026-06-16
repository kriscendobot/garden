---
title: §Four-different-underscore-or-hash-conventions for privacy
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

| Cycle | Source | Convention | Privacy level |
|-------|--------|-----------|---------------|
| 217 | @endo/errors | `__HIDE_<name>` (double-prefix marker) | visible; SES stack-trace protocol |
| 223 | @endo/module-source | `__name__` (double-underscore-wrap) | visible; SES Compartment internal contract |
| 233 | @endo/init/node-async-local-storage-patch | `_name` (single-underscore-prefix) | visible; Node internal API convention |
| 235 | @endo/compartment-mapper/generic-graph | `#name` (class-private-field) | truly-private; JavaScript language feature |

§Four-different-privacy-conventions for §four-different-substrates. §Cycle-235-is-the-language-level-true-privacy.
