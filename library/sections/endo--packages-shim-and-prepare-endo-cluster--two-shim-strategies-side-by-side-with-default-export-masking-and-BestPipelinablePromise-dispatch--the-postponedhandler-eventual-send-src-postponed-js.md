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
title: §The-postponedHandler (eventual-send/src/postponed.js)
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

```js
export const makePostponedHandler = HandledPromise => {
  let donePostponing;

  const interlockP = new Promise(resolve => {
    donePostponing = () => resolve(undefined);
  });

  const makePostponedOperation = postponedOperation => {
    return function postpone(x, ...args) {
      return new HandledPromise((resolve, reject) => {
        interlockP
          .then(_ => {
            resolve(HandledPromise[postponedOperation](x, ...args));
          })
          .catch(reject);
      });
    };
  };
  // ...
};
```

§The-postponedHandler-pattern: §six-handler-traps (get /
getSendOnly / applyFunction / applyFunctionSendOnly /
applyMethod / applyMethodSendOnly) all postpone via
`interlockP.then(...)`.

§The-interlockP-promise is resolved when `donePostponing()` is
called. §Until-then, every operation against the postponed
target waits in the `interlockP.then` chain.

§Why-this-matters: §async-bootstrap-discipline. When a guest
formula returns a promise to an object whose handler isn't
yet ready, the daemon installs a postponed handler so messages
queue rather than synchronously fail. §When-the-real-handler-
becomes-available, `donePostponing()` releases the queue.

§The-`@ts-expect-error 2454` on the `assert(donePostponing)`:

```js
// @ts-expect-error 2454
assert(donePostponing);
```

§TypeScript-can't-see that the Promise executor runs
synchronously, so it considers `donePostponing` possibly
undefined. §The-`@ts-expect-error` acknowledges that the
runtime invariant is correct even though the type system
can't see it.

§Compare-to-cycle-181-base64's `/** @type {any} */ (Uint8Array
.prototype).toBase64` cast for the §native-detection-pattern.
§Both-are-§ts-expect-error-where-runtime-knows-better.
