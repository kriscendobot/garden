---
title: §The 11-line platform-bound bootstrap
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

`source-map-node.js`:
```js
/* global process */
import url from 'node:url';
import os from 'node:os';
import { makeEndoSourceMapLocator } from './source-map-node-powers.js';

export const computeSourceMapLocation = makeEndoSourceMapLocator({
  url,
  os,
  process,
});
```

§The-file-does-three-things-only:
1. §**Imports node:url and node:os** — Node-specific platform modules via `node:` URL scheme.
2. §**Names `process` as a global** via the `/* global process */` ESLint directive.
3. §**Delegates to the factory** with `{url, os, process}` as the powers triple.

§First-explicit-observation in library: **§the-thin-Node-bootstrap-IS-only-three-things — §named-platform-imports + §global-process-named-via-eslint-comment + §single-call-to-the-platform-agnostic-factory**.

§The-`/* global process */`-comment IS the §named-eslint-directive-as-named-discipline; §sibling-pattern to cycle 245's eslint-disable comments and cycle 254's named-eslint-disable. §three-cycles-with-named-eslint-directive-as-acknowledged-platform-binding (245 + 254 + 276); §the-eslint-comment-IS-part-of-the-platform-binding-vocabulary.

§The-`node:`-URL-scheme — §sibling-pattern to Node.js's modern import discipline; §the-import-IS-explicit-that-this-IS-a-Node-built-in; §two-cycles-with-`node:`-URL-imports-as-named-discipline (this is the first explicit observation; could be a recurring pattern).

§First-explicit-observation in library: **§the-`node:`-URL-scheme-import-as-named-Node-built-in-discipline — §`node:url`-and-`node:os`-not-`url`-and-`os` + §the-`node:`-prefix-IS-the-explicit-marker-that-this-IS-a-platform-binding-not-a-userland-package**.
