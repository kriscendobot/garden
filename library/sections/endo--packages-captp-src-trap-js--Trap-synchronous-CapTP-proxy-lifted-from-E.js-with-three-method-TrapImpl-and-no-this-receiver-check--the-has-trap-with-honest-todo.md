---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §`has`-trap with §honest-TODO
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

```js
has(_target, _p) {
  // TODO: has property is not yet transferrable over captp.
  return true;
}
```

Both `TrapProxyHandler` and `makeTrapGetterProxy` have this
identical `has` trap with the identical TODO comment.

The §has-property-not-yet-transferrable-over-captp
acknowledgment: the `in` operator (`'foo' in Trap(x)`) cannot
*currently* be implemented over the CapTP wire because there's
no wire-level "has" message. The trap returns `true`
unconditionally — same as E.js, but with a TODO marker
because *for synchronous calls, accurate `has` would be
implementable* (unlike E.js where async-`has` is
semantically tricky).

The §honest-acknowledgment-of-API-gap discipline. The TODO is
*specific* (cite the missing feature) and *bounded* (says
exactly what would unblock the fix).
