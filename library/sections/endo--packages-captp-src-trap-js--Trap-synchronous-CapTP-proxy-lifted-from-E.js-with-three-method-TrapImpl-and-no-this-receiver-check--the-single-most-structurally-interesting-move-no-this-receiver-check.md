---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §single most structurally interesting move — §no-`this`-receiver-check
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

Cycle 146's E.js implements the §this-receiver-check via
concise-method-syntax discipline: the dispatched function
rejects with *Unexpected receiver* if `this !== receiver`,
preventing method-detach attacks.

**Trap.js does NOT do this**:

```js
get(_target, p, _receiver) {
  return (...args) => trapImpl.applyMethod(x, p, args);
}
```

The returned function is an *arrow function* — *no `this`*.
Arrow functions take their `this` from the enclosing scope
(unused here), so detaching via `const m = Trap(x).method;
m(...args)` *works the same way as calling it directly*. The
detach-attack vector doesn't exist because the function
doesn't depend on `this`.

The §why-no-receiver-check-here observation:

- **`E.js`** returns a function that *closes over* `recipient`
  and *also* needs `this` to be the proxy (because the
  generated function does dispatch via `HandledPromise.applyMethod`
  but also needs to know the proxy's identity for breakpoint
  match). Method detach corrupts the dispatch logic.
- **`trap.js`** returns an arrow function that *closes over
  both* `x` and `p` and *only* calls `trapImpl.applyMethod(x,
  p, args)`. There's no `this`-dependent logic. Detaching is
  harmless.

The §arrow-function-is-already-detach-safe property emerges
*for free* from the closure semantics. No defensive code
needed.
