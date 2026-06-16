---
title: "`@endo/import-bundle/src/source-map-node.js` + `source-map-node-powers.js` — the platform-bound + powers-injected pair"
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

**45 lines total** across two files: an 11-line **platform-bound bootstrap** (`source-map-node.js`) plus a 35-line **powers-injected factory** (`source-map-node-powers.js`). The pair instantiates a **named platform-binding pattern**: the bootstrap binds to Node's platform modules at module load; the factory accepts those modules as injected powers without naming them at runtime.

§First-explicit-observation in library: **§the-platform-bound-bootstrap-plus-powers-injected-factory-pair-as-named-discipline — §when-a-module-needs-Node-platform-bindings, §a-thin-Node-bootstrap-imports-the-platform-modules-and-passes-them-as-powers-to-a-platform-agnostic-factory + §the-pair-IS-the-canonical-shape-for-Node-bound-functionality**.

§Sibling-pattern to cycle 245's panic-cluster pre-lockdown-capture and cycle 254's pony-vs-shim distinction — but here the structural shape is two-file-pair where one file imports platform globals and the other accepts them as parameters.

§Two-cycles-with-platform-binding-as-explicit-pair (245 panic-cluster's pre-lockdown-capture + 276 import-bundle's source-map-node-pair); §the-discipline-IS-the-same: §the-platform-binding-IS-explicit-not-implicit + §the-implementation-IS-platform-independent.
