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
title: §The-assert-without-condition-is-just-Fail
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

```js
} else {
  assert(internalResolve === null);
}
```

§assert(condition)-without-message: §relies-on-the-assert-
substrate-to-throw-a-default-message. §SES's-assert
(cycle 98) provides this.

§Why-not-`Fail`-template-tag: §the-assertion-is-a-genuine-
invariant-check, not a §user-facing-error. The default
message ("Check failed") is fine for §a-bug-not-a-user-
mistake.

§Comparison-with-Fail-X-template-discipline (cycles 87/96/
98): §those-are-for-user-facing-errors-with-context. §This-
is-for-impossible-states-that-indicate-a-bug.
