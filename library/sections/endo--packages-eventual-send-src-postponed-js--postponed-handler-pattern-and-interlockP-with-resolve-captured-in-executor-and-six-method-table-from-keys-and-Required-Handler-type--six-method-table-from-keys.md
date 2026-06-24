---
title: §Six-method table from keys
source-slug: endo--packages-eventual-send-src-postponed-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/postponed.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/postponed.js
total-lines: 46
ingest-cycle: 241
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type
---

```js
const postponedHandler = {
  get: makePostponedOperation('get'),
  getSendOnly: makePostponedOperation('getSendOnly'),
  applyFunction: makePostponedOperation('applyFunction'),
  applyFunctionSendOnly: makePostponedOperation('applyFunctionSendOnly'),
  applyMethod: makePostponedOperation('applyMethod'),
  applyMethodSendOnly: makePostponedOperation('applyMethodSendOnly'),
};
```

§The-six-method-handler-protocol enumerated in order:

1. **get** — read a property on the target.
2. **getSendOnly** — read a property with no return value (fire-and-forget).
3. **applyFunction** — call the target as a function with args.
4. **applyFunctionSendOnly** — same, fire-and-forget.
5. **applyMethod** — call a method on the target with method name + args.
6. **applyMethodSendOnly** — same, fire-and-forget.

§The-protocol's-six-methods-form-a-2x3-axis-table: §three-operations (get + applyFunction + applyMethod) × §two-send-modes (regular + send-only). §The-handler-protocol-IS-the-call-shape × §the-send-mode. §When-a-handler-protocol-has-orthogonal-axes, §enumerate-them-in-table-order-not-grouped-by-shape (the file lists them in `get` / `getSendOnly` pairs, then `applyFunction` / `applyFunctionSendOnly` pairs — the **axis pair** is the inner loop).

§postponedOperation-as-method-name-string-used-as-key-on-HandledPromise — §the-operation-name-is-both-the-method-on-postponedHandler-AND-the-method-on-HandledPromise. §When-the-handler-method-and-the-HandledPromise-method-have-the-same-name, §the-string-IS-the-uniform-protocol-key. §Sibling-pattern-to-cycle-239's-named-protocol-constant — both designs use a §single-string-as-the-protocol-key.

§makePostponedOperation-as-method-factory:

```js
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
```

§Each-handler-method-is-generated-from-a-single-shape-with-the-operation-name. §DRY-via-method-factory — the six methods on `postponedHandler` differ only in the string passed to `makePostponedOperation`. §When-N-methods-differ-only-in-the-string-name-of-the-operation-they-defer, §the-factory-takes-the-string-and-returns-the-deferring-function.

§The-returned-function-has-a-debug-name (`postpone`) — §when-a-factory-returns-an-anonymous-function-that-will-appear-in-stack-traces, §give-it-a-debug-name-via-`function`-keyword-syntax-not-arrow. §Sibling-pattern-to-cycle-129's `function method()` body inside a computed-property-key trick (cycle 129 used `{ [propertyKey](...) {} }[propertyKey]` to preserve the name; cycle 241 uses the `function postpone(...)` syntax directly).
