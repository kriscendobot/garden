---
title: §the-named-error-message-lists-available-methods
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

Lines 113-120 — when method lookup fails, the error message LISTS available methods:

```js
const fn = recipient[methodName];
if (fn === undefined) {
  assert.fail(
    X`target has no method ${q(methodName)}, has ${q(getMethodNames(recipient))}`,
    TypeError,
  );
}
```

**§the-named-error-message-lists-available-methods** — first-explicit-observation as a tier-3 meta-pattern. When method lookup fails, the error message names WHAT IS available so the caller can diagnose the typo or misunderstanding. Compare to cycle 350's §the-named-error-message-discriminates-by-failure-cause; cycle 352's discipline is the COMPLEMENTARY diagnostic: when the cause is "method not found", show the AVAILABLE methods.

**§two-shapes-of-diagnostic-error-message** — first-explicit-observation as a tier-3 meta-pattern:
- **Discriminate by cause** (cycle 350): same predicate fails for different reasons; error names the reason
- **List available alternatives** (cycle 352): lookup fails; error lists what's available
