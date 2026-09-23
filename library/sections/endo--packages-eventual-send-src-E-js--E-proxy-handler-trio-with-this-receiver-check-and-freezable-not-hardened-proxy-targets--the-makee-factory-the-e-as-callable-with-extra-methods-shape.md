---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: The §makeE factory — the §E-as-callable-with-extra-methods shape
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

```js
const makeE = HandledPromise => {
  return harden(assign(
    x => new Proxy(funcTarget, makeEProxyHandler(x, HandledPromise)),
    {
      get: x => new Proxy(objTarget, makeEGetProxyHandler(x, HandledPromise)),
      resolve: HandledPromise.resolve,
      sendOnly: x => new Proxy(funcTarget, makeESendOnlyProxyHandler(x, HandledPromise)),
      when: (x, onfulfilled, onrejected) =>
        HandledPromise.resolve(x).then(...trackTurns([onfulfilled, onrejected])),
    },
  ));
};
```

The §callable-with-methods discipline: `E` is both a function (you
call `E(x)`) *and* an object with methods (`E.get`, `E.resolve`,
`E.sendOnly`, `E.when`). Implemented via `assign(fn, methods)` then
`harden(...)`.

§Five-surface api:

- `E(x).method(...)` — eventual method call (returns promise)
- `E(x)(...)` — eventual function call
- `E.get(x).prop` — eventual property get
- `E.resolve(x)` — convert to handled promise (= `HandledPromise.resolve(x)`)
- `E.sendOnly(x).method(...)` — fire-and-forget method
- `E.when(x, onf, onr)` — `resolve(x).then(onf, onr)` with cycle 90's
  trackTurns wrapping

The §E.when-wraps-trackTurns idiom: `trackTurns([onfulfilled,
onrejected])` annotates the callbacks so cycle 90's track-turns.js
can produce the causal-chain error annotations cycle 96's
console.js renders.
