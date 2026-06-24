---
title: §Implicit-thin-dispatch-layer pattern
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

@endo/bundle-source is mostly §dispatch-shape — §the-heavy-lifting-is-in-@endo/compartment-mapper. §The-public-API-surface (bundleSource(startFilename, options)) is §a-thin-dispatch-layer-over-the-machinery.

§Borrowable-pattern: §when-a-package-needs-a-friendly-public-surface-over-heavy-machinery, §the-package-is-a-thin-dispatch-layer-not-a-reimplementation. §The-thin-layer-knows-the-format-defaults + §the-feature-flags + §the-error-messages; §the-machinery-knows-the-substrate.

§Sibling to cycle 217 @endo/errors (§public-API-for-SES-assert — a thin layer over the SES substrate). §Two-different-packages-as-thin-dispatch-layers-over-heavier-substrate.
