---
source: packages/{eventual-send,promise-kit,ses-ava}/* (shim + prepare-endo cluster)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages
source_path: packages/eventual-send/{shim,utils}.js, packages/eventual-send/src/postponed.js, packages/promise-kit/{shim,index}.js, packages/promise-kit/src/is-promise.js, packages/ses-ava/{index,prepare-endo,prepare-endo-config}.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - eventual-send
  - getting-started
  - testing
genre: §endo-source-comment-fragment §shim-and-prepare-cluster
cycle: 187
lane: chat
status: current
title: §`utils.js` — the canonical thin barrel
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

```js
export { getMethodNames } from './src/local.js';
export { makeMessageBreakpointTester } from './src/message-breakpoints.js';
```

§Two-lines. §The-pattern: §re-export-two-named-utilities from
deeper modules so that consumers don't reach into `src/`.

§Compare-to-cycle-183-init/index.js (6 lines) + lockdown/
commit.js (3 lines) + cycle-181-base64/index.js (14 lines).
§All-are-§thin-barrels that present a §public-API-surface
distinct from the internal `src/` layout.

§Why-barrels: §callers-import-from-the-package-name (`@endo/
eventual-send/utils.js`), not from `src/local.js`. §The-
barrel-can-rearrange-internal-files without breaking callers.
§Hex-package-design-Decision-2 (cycle 180) named the §barrel-
pattern; here it appears as the implementation.
