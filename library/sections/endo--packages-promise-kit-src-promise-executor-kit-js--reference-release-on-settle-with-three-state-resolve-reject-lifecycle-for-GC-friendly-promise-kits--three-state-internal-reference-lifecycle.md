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
title: §Three-state-internal-reference-lifecycle
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

```js
let internalResolve;   // state 0: undefined (initial)
let internalReject;    // state 0: undefined (initial)

const executor = (res, rej) => {
  assert(internalResolve === undefined && internalReject === undefined);
  internalResolve = res;     // state 0 → 1
  internalReject = rej;      // state 0 → 1
};

const resolve = value => {
  if (internalResolve) {
    internalResolve(value);
    internalResolve = null;  // state 1 → 2
    internalReject = null;   // state 1 → 2
  } else {
    assert(internalResolve === null);
  }
};
```

§Three-states-encoded-as-three-JS-values:

| State | `internalResolve` | Meaning |
|-------|-------------------|---------|
| 0 (initial) | `undefined` | Executor not yet called |
| 1 (armed) | function | Executor called; references captured |
| 2 (settled) | `null` | Resolved or rejected; references released |

§undefined-vs-null-meaningful-distinction. §undefined ≠
null in this design: §undefined-is-pre-arming, §null-is-
post-settlement. §The-falsy-check (`if (internalResolve)`)
distinguishes state 1 from states 0+2 (both falsy but
different).

§The-assert-discriminates: in state 2, `internalResolve ===
null`. In state 0, `internalResolve === undefined`. §State-
0-shouldn't-be-reachable-via-resolve (executor hasn't run
yet); the §assert would fire if a user did something
illegal.
