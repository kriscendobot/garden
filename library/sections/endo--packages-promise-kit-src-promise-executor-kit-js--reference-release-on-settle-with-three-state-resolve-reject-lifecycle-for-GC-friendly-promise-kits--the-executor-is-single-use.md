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
title: §The-executor-is-single-use
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

```js
const executor = (res, rej) => {
  assert(internalResolve === undefined && internalReject === undefined);
  internalResolve = res;
  internalReject = rej;
};
```

§assert-on-double-invocation. The executor expects to be
called §exactly-once by the promise constructor.

§Why-this-matters: Promise constructors invoke the executor
synchronously, once. §The-assertion-catches-misuse if
someone tries to reuse the executor.

§State-0-precondition: §undefined-undefined-both-must-hold.
