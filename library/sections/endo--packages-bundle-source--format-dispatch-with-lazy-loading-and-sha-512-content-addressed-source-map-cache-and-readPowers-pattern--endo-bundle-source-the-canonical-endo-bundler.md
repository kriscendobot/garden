---
title: "@endo/bundle-source — the canonical Endo bundler"
source-slug: endo--packages-bundle-source
section-id: format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
url: https://github.com/endojs/endo/tree/master/packages/bundle-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/bundle-source/src/{bundle-source.js,zip-base64.js,script.js,endo.js,fs.js,main.js,is-entrypoint.js,tool.js,index.js}
status: shipping
ingest-cycle: 221
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-bundle-source--format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
---

`@endo/bundle-source` produces a hardened bundle (one of four named module formats) from a Node.js entry-point file. 913 source lines across 10 files plus types.ts. The library's central bundler — every Endo agent, weblet, and worker is bundled through this package. Imports from `@endo/compartment-mapper` (the heavy machinery) and is the §thin-dispatch-layer over that machinery.
