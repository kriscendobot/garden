---
title: §the-named-symbol-vs-string-ordering-discipline
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

Lines 36-50 implement `compareStringified` that **prioritizes symbols as earlier than strings**:

```js
const compareStringified = (a, b) => {
  if (typeof a === typeof b) {
    const left = String(a);
    const right = String(b);
    return left < right ? -1 : left > right ? 1 : 0;
  }
  if (typeof a === 'symbol') {
    return -1;  // symbols first
  }
  return 1;
};
```

**§the-named-symbol-vs-string-ordering-discipline** — first-explicit-observation. When sorting heterogeneous keys (string + symbol), symbols come first. The discipline encodes a TOTAL ORDER over key types.

**§the-named-canonical-sort-order-for-heterogeneous-keys** — first-explicit-observation as a tier-3 meta-pattern. JavaScript objects can have both string and symbol keys; when listing them, a canonical sort order should be deterministic.
