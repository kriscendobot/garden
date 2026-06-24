---
title: The single most structurally interesting move
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

**§the-named-pre-lockdown-modules-use-freeze-not-harden** — line 76-78:

```js
// The top level of the eventual send modules can be evaluated before
// ses creates `harden`, and so cannot rely on `harden` at top level.
freeze(getMethodNames);
```

The eventual-send module evaluates **BEFORE** SES creates harden. Therefore the top-level code uses `Object.freeze` instead of `harden`. The comment NAMES the constraint explicitly.

**§the-named-pre-lockdown-modules-use-freeze-not-harden** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: modules positioned BELOW the SES substrate (loaded earlier in initialization) cannot use SES-provided primitives at top level. They must fall back to platform primitives (Object.freeze).

**§the-named-cannot-rely-on-harden-at-top-level** — first-explicit-observation. The discipline applies to TOP-LEVEL code only; runtime functions (called after lockdown) can rely on harden being available.

**§the-named-layering-constraint-acknowledged-in-comment** — first-explicit-observation. The comment names BOTH the constraint (cannot rely on harden) AND the discipline (use freeze instead). Sibling to cycle 336/338's isPrimitive layering-constraint TODO and cycle 342's domainTaming-unsafe-always-injected discipline.
