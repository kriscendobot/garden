---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §`baseFreezableProxyHandler` mirror
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

```js
const baseFreezableProxyHandler = {
  set(_target, _prop, _value) { return false; },
  isExtensible(_target) { return false; },
  setPrototypeOf(_target, _value) { return false; },
  deleteProperty(_target, _prop) { return false; },
};
```

**Identical** to cycle 146's E.js. The §four-meta-traps-
return-false discipline carries over: `set` / `isExtensible`
/ `setPrototypeOf` / `deleteProperty` all return `false` (the
*correct* Proxy-meta-trap signal for "no", preserving strict-
mode invariants without throwing).

The §code-reuse-via-duplication discipline (not via shared
import): both files inline the same `baseFreezableProxyHandler`
object literally. Cross-package shared-helpers would create
a dependency between `@endo/captp` and `@endo/eventual-send`
that doesn't otherwise exist; the §duplicate-don't-import
discipline preserves package independence.
