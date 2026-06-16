---
source: packages/check-bundle/{index,lite,src/json}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/check-bundle
source_path: packages/check-bundle/index.js, packages/check-bundle/lite.js, packages/check-bundle/src/json.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - capability-security
  - bundles
  - hardened-javascript
genre: §endo-source-comment-fragment §canonical-powered-powerless-pair
cycle: 185
lane: chat
status: current
title: §`await null` discipline at the start
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
export const checkBundle = async (bundle, computeSha512, bundleName) => {
  await null;
  assert.typeof(...);
  // ...
};
```

§The-`await null` at the very first line of the async function.

§Why-required: without `await null`, synchronous `assert.typeof`
throws would propagate immediately to the caller (before any
microtask boundary), which can violate caller-expectation of
"all errors come as promise rejections."

§With-`await null`: the function returns a promise immediately;
any subsequent throw (from assert.typeof) becomes a rejection
on that promise rather than a synchronous exception.

§Compare-to-cycle-90-eventual-send/track-turns.js' §async-
boundary-discipline. §Same-shape-different-context: ensure the
function's effect on the call stack matches its declared async
nature.

§Cycle-100-unhandled-rejection.js's GC-driven tracking depends
on this discipline being followed widely — if some async
functions throw synchronously, the lost-rejection tracking
becomes confused.
