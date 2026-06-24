---
section: legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
source: endo--packages-patterns-src-patterns-getGuardPayloads-js
topics: [patterns, exo]
status: current
title: The §adaptMethodGuard re-builder — *builder-chain restores the
parent: endo--packages-patterns-src-patterns-getGuardPayloads-js--legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
---

current shape*

The §`adaptMethodGuard` private function is the structurally
interesting *legacy-record → current-builder-chain* converter:

```js
const adaptMethodGuard = methodGuard => {
  if (matches(methodGuard, LegacyMethodGuardShape)) {
    const {
      callKind,
      argGuards,
      optionalArgGuards = [],
      restArgGuard = M.any(),
      returnGuard,
    } = getMethodGuardPayload(/** @type {any} */ (methodGuard));
    const makeGuard = /** @type {(...args: any[]) => any} */ (
      callKind === 'sync' ? M.call : M.callWhen
    );
    return makeGuard(...argGuards)
      .optional(...optionalArgGuards)
      .rest(restArgGuard)
      .returns(returnGuard);
  }
  return methodGuard;
};
```

The §legacy methodGuard is *reconstructed by calling the public
builder chain* — `M.call(...)` or `M.callWhen(...)` depending on
sync/async, then `.optional(...)`, `.rest(...)`, `.returns(...)`.
The new shape is *whatever the builder chain produces today* —
this keeps the upgrade tracking-free even when the internal shape
changes between releases.
