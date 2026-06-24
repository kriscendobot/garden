---
title: §AVA-method-override-list
source-slug: endo--packages-ses-ava
section-id: registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava/src/{ses-ava-test.js, command.js, reexport-ava.js}
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-ses-ava--registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
---

```js
const overrideList = [
  'after',
  'afterEach',
  'before',
  'beforeEach',
  'failing',
  'serial',
  'only',
];
```

§Seven-named-AVA-chainable-method-names that need recursive wrapping. The §wrapTest recursively wraps each of these:

```js
const wrapTest = avaTest => {
  const sesAvaTest = augmentLogging(avaTest);
  for (const methodName of overrideList) {
    if (hasOwn(avaTest, methodName)) {
      defineProperty(sesAvaTest, methodName, {
        value: wrapTest(avaTest[methodName]),
        // ...
      });
    }
  }
  harden(sesAvaTest);
  return sesAvaTest;
};
```

§Recursive-wrapping-for-chainable-methods. §Each-chained-method (`test.only.failing("...", ...)`) also gets the SES-aware logging.

§Borrowable-pattern: §allow-list-for-recursive-wrapping — §enumerate-the-known-chainable-methods + §wrap-each-one-recursively. §If-AVA-adds-a-new-chainable-method, the allow-list must be updated; §this-is-honest-fragility — §the-cost-of-being-explicit-about-which-methods-need-wrapping.

§Sibling to:
- cycle 154 @endo/captp trap.js: §narrowed-API-for-narrower-semantics (five-surface E.js → two-surface Trap; not all methods are surfaced).
- cycle 146 E.js: §callable-with-methods discipline (E is both a function and an object via `harden(assign(fn, methods))`).
- cycle 132 local.js: §getMethodNames-prototype-walk with §stop-at-Object-prototype.
