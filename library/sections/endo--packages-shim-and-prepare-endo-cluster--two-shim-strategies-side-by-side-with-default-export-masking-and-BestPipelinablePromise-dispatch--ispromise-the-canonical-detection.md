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
title: §`isPromise` — the canonical detection
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

```js
import harden from '@endo/harden';

export function isPromise(maybePromise) {
  return Promise.resolve(maybePromise) === maybePromise;
}
harden(isPromise);
```

§Twelve-lines. §The-detection-rule: `Promise.resolve(x) === x`
returns true iff x is a §thenable-that-is-already-a-Promise.

§Why-not-`x instanceof Promise`: §realm-boundary-issue. A
Promise from another realm has a different `Promise.prototype`,
so `instanceof` returns false. §`Promise.resolve` is §realm-
agnostic — it returns its argument unchanged if it's already
a Promise from the same realm or a compatible thenable.

§Compare-to-cycle-152-pass-style/symbol.js' §Hilbert-Hotel-
encoding and cycle 87-ses-error/assert.js' §`assert`-as-realm-
agnostic-substrate. §All-three-are-§cross-realm-discipline
patterns.
