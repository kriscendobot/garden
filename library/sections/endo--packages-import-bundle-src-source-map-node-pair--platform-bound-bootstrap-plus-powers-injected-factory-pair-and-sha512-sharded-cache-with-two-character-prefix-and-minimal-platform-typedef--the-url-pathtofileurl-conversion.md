---
title: §The url.pathToFileURL conversion
source-slug: endo--packages-import-bundle-src-source-map-node-pair
section-slug: platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
source-url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/source-map-node.js
source-repo: endojs/endo
source-path: packages/import-bundle/src/source-map-node.js + source-map-node-powers.js
source-author: Endo project (collective)
total-lines: 45 (10 + 35)
ingest-cycle: 276
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-import-bundle-src-source-map-node-pair--platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
---

Line 22: `const cacheLocation = url.pathToFileURL(cacheDirectory);`

§First-explicit-observation in library: **§the-url.pathToFileURL-conversion-IS-named-cross-platform-discipline — §the-cacheDirectory-IS-a-platform-specific-path (Unix-style or Windows-style) + §`url.pathToFileURL`-converts-it-to-a-platform-agnostic-file-URL + §the-rest-of-the-code-uses-the-URL-form**.

§Sibling-pattern to many Node modules that take URLs not paths; §the-discipline-IS-the-platform-binding-only-at-the-boundary + §the-URL-form-IS-platform-agnostic-thereafter.
