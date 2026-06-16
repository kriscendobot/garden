---
title: §the-named-base-case-via-null-methodName
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

Line 100-104:

```js
export const localApplyMethod = (recipient, methodName, args) => {
  if (methodName === undefined || methodName === null) {
    // Base case; bottom out to apply functions.
    return localApplyFunction(recipient, args);
  }
  // ...
};
```

**§the-named-base-case-via-null-methodName** — first-explicit-observation. The same dispatch function handles BOTH method calls (with methodName) and function calls (without). The null/undefined methodName is the BASE CASE that bottoms out to function application.

**§the-named-polymorphic-dispatch-with-named-base-case** — first-explicit-observation as a tier-3 meta-pattern. When a dispatcher handles multiple forms, use a NULL/UNDEFINED parameter to mark the base case + delegate to a sibling dispatcher.
