---
title: §the-named-isPrimitive-FOURTH-package-duplication
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

Lines 14-27 contain the SAME isPrimitive function as cycle 336 memo-race.js + cycle 338 make-hardener.js + cycle 350 passStyleOf.js:

```js
/**
 * TODO Consolidate with `isPrimitive` that's currently in `@endo/pass-style`.
 * Layering constraints make this tricky, which is why we haven't yet figured
 * out how to do this.
 */
const isPrimitive = val =>
  !val || (typeof val !== 'object' && typeof val !== 'function');
```

**§the-named-isPrimitive-FOURTH-package-duplication** — first-explicit-observation. The duplication now spans:

| Cycle | Package |
|---|---|
| 142 | passStyle-helpers.js (`@endo/pass-style`) |
| 336 | memo-race.js (`@endo/promise-kit`) |
| 338 | make-hardener.js (`@endo/harden`) |
| 350 | passStyleOf.js (uses `@endo/pass-style`'s; doesn't duplicate) — actually imports from passStyle-helpers |
| **352** | **local.js (`@endo/eventual-send`)** |

**§five-packages-with-named-isPrimitive-duplication** — first-explicit-observation as a tier-2 multi-cycle pattern. Counting actually distinct packages: @endo/pass-style + @endo/promise-kit + @endo/harden + ses (cycle 338 named ses) + @endo/eventual-send = **FIVE packages** with isPrimitive duplication.

**§five-cycles-with-named-isPrimitive-duplication-observation** (142 + 336 + 338 + 350 + 352) — extending cycle 338's four-cycles count.

**§the-named-layering-constraints-form-a-pentagon** — first-explicit-observation as a tier-3 meta-pattern. The five packages form a layering structure where each sits at a level that can't import isPrimitive from any of the others without creating a cycle. The duplication is enforced by the dependency-graph DAG.
