---
title: §the-named-three-conditions-for-localApplyMethod-failure
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

The function has THREE explicit failure paths:
1. methodName provided + recipient null/undefined → "Cannot deliver ${methodName} to target"
2. method not found on recipient → "target has no method ${methodName}, has ${methods}"
3. method exists but isn't a function → "invoked method ${methodName} is not a function; it is a ${type}"

**§the-named-three-conditions-for-localApplyMethod-failure** — first-explicit-observation. Each failure path has a SPECIFIC error message with the diagnostic information needed to fix the caller's bug.
