---
source: packages/promise-kit/src/promise-executor-kit.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/promise-executor-kit.js
source_path: packages/promise-kit/src/promise-executor-kit.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - patterns
  - async-flow
genre: §endo-source-comment-fragment
cycle: 173
lane: chat
status: current
title: §Resolve/reject-are-fire-once
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

```js
const resolve = value => {
  if (internalResolve) {           // state 1?
    internalResolve(value);         // fire
    internalResolve = null;         // → state 2
    internalReject = null;          // → state 2
  } else {
    assert(internalResolve === null); // must be state 2
  }
};
```

§First-call: state 1 → state 2 (fires, releases).
§Subsequent-calls: silent no-op (with assert).

§Why-silent-no-op-on-double-resolve: §Promise-semantics-
already-make-second-resolve-a-no-op; the kit honors this
without forwarding to the (now-released) resolve function.

§Symmetric-release: resolve releases *both* internalResolve
*and* internalReject. §Once-settled-neither-can-fire.
§Same-on-reject-side: rejection releases both.
