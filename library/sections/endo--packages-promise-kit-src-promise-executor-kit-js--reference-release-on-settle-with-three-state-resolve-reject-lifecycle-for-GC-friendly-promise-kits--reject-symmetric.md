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
title: §reject-symmetric
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

```js
const reject = reason => {
  if (internalReject) {
    internalReject(reason);
    internalResolve = null;
    internalReject = null;
  } else {
    assert(internalReject === null);
  }
};
```

§Identical-structure-to-resolve. §Two-functions-symmetric-
in-shape; §the-only-difference-is-the-trigger-condition.

§Could-this-be-DRYed: yes, with a higher-order factory.
§Why-it-isn't: §two-functions-named-resolve-and-reject is
§clearer-than-one-function-with-a-mode-arg; the duplication
is §intentional-readability.
