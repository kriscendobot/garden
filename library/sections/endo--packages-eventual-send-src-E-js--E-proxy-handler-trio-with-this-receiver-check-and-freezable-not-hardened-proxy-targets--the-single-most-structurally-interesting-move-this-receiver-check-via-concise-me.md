---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: The §single most structurally interesting move — §this-receiver check via concise-method-syntax
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

The `get` trap returns a function that performs a `this`-identity
check:

```js
get: (_target, propertyKey, receiver) => {
  return harden({
    [propertyKey](...args) {
      if (this !== receiver) {
        return HandledPromise.reject(
          makeError(X`Unexpected receiver for "${q(propertyKey)}" method of E(${q(recipient)})`),
        );
      }
      // ...
      return HandledPromise.applyMethod(recipient, propertyKey, args);
    },
  }[propertyKey]);
}
```

The §this-receiver-check discipline: the returned function *must* be
called as `E(x).method(...args)`. If anyone detaches it via
`const m = E(x).method; m(...args)`, the detached call rejects with
*Unexpected receiver*. The §detach-protection discipline.

The §concise-method-syntax-not-arrow discipline (file's own comment):
*defined using concise method syntax rather than as an arrow function
... `this`-sensitive*. Arrow functions don't have their own `this`.
Concise method syntax `{ [propertyKey](...args) { ... } }[propertyKey]`
produces a function whose `this` is the receiver at call time.

The §avoid-function-syntax discipline (same comment): *To ensure the
function is not constructable*. ES6 `function` declarations have a
`[[Construct]]` internal slot; concise methods don't. The
§non-constructable-via-syntax-choice trick: callers cannot
`new E(x).method(...)`.

The §computed-property-key-preserves-name idiom: `{ [propertyKey](...) { ... } }[propertyKey]`
produces a function whose `name` is the property key. Better stack
traces.

The §`@ts-expect-error` for TS#50319 (microsoft/TypeScript#50319)
acknowledges TypeScript can't yet narrow the type of a computed-key
method access.
