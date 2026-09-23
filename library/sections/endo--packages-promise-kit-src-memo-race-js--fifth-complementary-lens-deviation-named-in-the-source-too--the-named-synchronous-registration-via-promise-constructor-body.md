---
title: §the-named-synchronous-registration-via-promise-constructor-body
source: endo--packages-promise-kit-src-memo-race-js
url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/memo-race.js
authors: [Brian Kim (original), Endo project (adopted)]
repo: endojs/endo
path: packages/promise-kit/src/memo-race.js
total-lines: 170
ingest-cycle: 336
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-deviation-named-in-the-source-too
  - the-named-implementation-of-the-accommodation
  - the-named-public-domain-license-header-preserved-verbatim
  - the-named-attribution-discipline-when-adopting-public-domain-code
  - the-named-explicit-acknowledgment-of-cross-package-layering-constraint
  - the-named-name-both-the-goal-and-the-obstacle
  - the-named-helpers-private-export-single-public
  - the-named-export-the-noun-not-the-verbs
  - the-named-in-place-transition-for-shared-references
  - the-named-assign-then-freeze-transition
  - the-named-fake-record-honors-real-record-discipline
  - the-named-named-function-via-object-destructure
  - the-named-api-name-vs-impl-name-asymmetry
  - the-named-JSDoc-generic-this-binding
  - the-named-cachedValues-defends-against-one-shot-iterables
  - the-named-complementary-lens-re-ingest
  - the-named-streak-resumes-after-one-cycle-gap
  - five-cycles-with-named-complementary-lens-re-ingest
  - twenty-seven-cycles-with-named-pivot-domain-stay
  - fifty-citation-arc-closures-in-pivot-now
parent: endo--packages-promise-kit-src-memo-race-js--fifth-complementary-lens-deviation-named-in-the-source-too
---

Lines 142-155: the entire promise-input registration happens **synchronously** inside the `new C(...)` constructor's executor body. All values are walked, memoized, and registered with deferred sets before the constructor returns.

**§the-named-synchronous-registration-via-promise-constructor-body** — first-explicit-observation. The promise constructor's executor function is the natural synchronous registration point because: (a) it runs synchronously during `new Promise(...)`; (b) it captures `resolve`/`reject` for later use; (c) it sees the input iterable from the enclosing scope. The pattern: **use the promise constructor body as your synchronous-initialization hook** when you need to capture continuation references before any awaits.

Compare to cycle 173's @endo/promise-kit/src/promise-executor-kit.js (§executor-is-single-use, §reference-release-on-settle): the executor body in that file captures `internalResolve`/`internalReject` for later release; the cycle 336 memo-race executor body captures `deferred` for later cleanup. **§two-cycles-with-named-executor-body-as-synchronous-capture-hook** (173 + 336).
