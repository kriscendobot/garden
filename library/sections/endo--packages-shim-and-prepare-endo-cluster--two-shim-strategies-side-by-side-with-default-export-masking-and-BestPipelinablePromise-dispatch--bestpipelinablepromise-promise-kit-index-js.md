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
title: §BestPipelinablePromise (promise-kit/index.js)
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

```js
/** @type {PromiseConstructor} */
const BestPipelinablePromise = globalThis.HandledPromise || Promise;
```

§The-dispatch-pattern: §pick-the-better-Promise-at-module-load.
§If-HandledPromise-was-installed (cycle 187-eventual-send-shim
or @endo/init/pre-remoting): use it. §Else: fall back to the
platform's `Promise`.

§Why-this-matters: cycle 66's HandledPromise supports
§eventual-send-pipelining via `then`-chained method calls
(`E(x).method().anotherMethod()` builds a pipeline rather
than awaiting each step). §A-`makePromiseKit()`-promise built
on HandledPromise inherits this property; on plain Promise,
it doesn't.

§The-`makePromiseKit` factory:

```js
export function makePromiseKit() {
  const { resolve, reject, executor } = makeReleasingExecutorKit();

  const promise = new BestPipelinablePromise(executor);

  return harden({ promise, resolve, reject });
}
harden(makePromiseKit);
```

§Three-step: get executor kit (cycle 173 §releasing-executor-
kit with §reference-release-on-settle) → wrap in best Promise
constructor → harden the resulting trio.

§Compare-to-cycle-183-init's §two-phase-init pre→commit. §This-
is §two-phase-build-the-promise: §allocate-the-executor (cycle
173) then §wrap-with-the-best-constructor (cycle 66's
HandledPromise if available).
