---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_path: packages/harden/make-selector.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 175
lane: chat
status: current
title: §Comparison-with-cycle-108's-coordinated-update
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

Cycle 108 noted the §adopt-`@endo/harden` migration across
the @endo monorepo (commit `e56bf00f`). The §harden-import
discipline introduced *because* of this file:

```js
import harden from '@endo/harden';
```

§Every-file-imports-its-own-harden. §The-selector-makes-
them-all-be-the-same-harden-instance at runtime.

§Cycle-108's-15-file-cluster (now grown to cycles 108/
110/115/118/123/125/132/134/138/140/144/167/169/171/173)
all import from this package. §The-coordinated-update is
visible because every file got the same import-discipline
applied simultaneously.
