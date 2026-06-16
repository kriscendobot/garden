---
title: §the-named-getMethodNames-walks-prototype-chain
source: endo--packages-eventual-send-src-local-js
url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/local.js
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/eventual-send/src/local.js
total-lines: 139
ingest-cycle: 352
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-pre-lockdown-modules-use-freeze-not-harden
  - the-named-cannot-rely-on-harden-at-top-level
  - the-named-isPrimitive-FOURTH-package-duplication
  - five-packages-with-named-isPrimitive-duplication
  - the-named-symbol-vs-string-ordering-discipline
  - the-named-error-message-lists-available-methods
  - the-named-base-case-via-null-methodName
  - the-named-getMethodNames-walks-prototype-chain
  - the-named-three-conditions-for-localApplyMethod-failure
  - the-named-complementary-lens-re-ingest
  - ten-cycles-with-named-complementary-lens-re-ingest
  - forty-three-cycles-with-named-pivot-domain-stay
  - one-hundred-fifty-four-citation-arc-closures-in-pivot-now
parent: endo--packages-eventual-send-src-local-js--tenth-complementary-lens-pre-lockdown-modules-use-freeze-not-harden-and-isPrimitive-fourth-package-duplication
---

Lines 56-75 — `getMethodNames` walks the prototype chain to collect function-typed properties:

```js
export const getMethodNames = val => {
  let layer = val;
  const names = new Set();
  while (layer !== null && layer !== Object.prototype) {
    const descs = getOwnPropertyDescriptors(layer);
    for (const name of ownKeys(descs)) {
      if (typeof val[name] === 'function') {
        names.add(name);
      }
    }
    if (isPrimitive(val)) {
      break;
    }
    layer = getPrototypeOf(layer);
  }
  return harden([...names].sort(compareStringified));
};
```

**§the-named-getMethodNames-walks-prototype-chain** — first-explicit-observation. The function:
1. Walks UPWARD through the prototype chain (using `getPrototypeOf`)
2. Stops at Object.prototype or null
3. Tests via `val[name]` (not `layer[name]`) so methods overridden by non-methods are skipped
4. Uses Set for dedup
5. Returns hardened sorted array

**§the-named-test-via-val-not-layer-discipline** — first-explicit-observation. The comment names WHY: *"In case a method is overridden by a non-method, test `val[name]` rather than `layer[name]`"*. The discipline ensures the result reflects what's ACTUALLY accessible on the input object, not what's defined on its prototype chain.
