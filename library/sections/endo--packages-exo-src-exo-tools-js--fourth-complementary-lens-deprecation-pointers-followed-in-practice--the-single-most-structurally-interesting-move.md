---
title: The single most structurally interesting move
source: endo--packages-exo-src-exo-tools-js
url: https://github.com/endojs/endo/blob/master/packages/exo/src/exo-tools.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/exo/src/exo-tools.js
total-lines: 513
ingest-cycle: 332
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-deprecation-pointers-followed-in-practice
  - the-named-deprecation-as-soft-contract-with-followed-pointer
  - the-named-import-graph-from-exo-tools-IS-named-cross-package-substrate
  - the-named-fan-out-import-graph-recurs
  - the-named-listDifference-and-objectMap-from-common-not-patterns
  - the-named-RawMethodGuard-and-PassableMethodGuard-default-guards
  - the-named-REDACTED_RAW_ARG-as-sentinel-string
  - the-named-three-sentinel-set-discipline
  - the-named-raw-vs-passable-distinction-with-two-default-guards
  - the-named-zero-copy-when-possible-discipline
  - the-named-Reflect-destructure-grows-with-adoption
  - the-named-complementary-lens-re-ingest
  - twenty-three-cycles-with-named-pivot-domain-stay
  - four-cycles-with-named-complementary-lens-re-ingest
  - five-cycles-with-named-one-cycle-README-source-arc
  - forty-one-citation-arc-closures-in-pivot-now
  - three-cycles-with-named-Reflect-destructure-at-module-load
parent: endo--packages-exo-src-exo-tools-js--fourth-complementary-lens-deprecation-pointers-followed-in-practice
---

**§the-named-deprecation-pointers-followed-in-practice** — line 14-15 of exo-tools.js:

```js
import { listDifference } from '@endo/common/list-difference.js';
import { objectMap } from '@endo/common/object-map.js';
```

Cycle 326's @endo/patterns/index.js had these *exact* exports marked **@deprecated** with canonical pointers (line 82-98 of cycle 326's source):

```js
export {
  /**
   * @deprecated
   * Import directly from `@endo/common/list-difference.js` instead.
   */
  listDifference,
} from '@endo/common/list-difference.js';
```

Cycle 332's exo-tools.js **follows the deprecation pointer in practice** — it imports from `@endo/common/list-difference.js` directly, NOT from `@endo/patterns`. The deprecation tag isn't aspirational; sibling code in the same family follows it.

**§the-named-deprecation-as-soft-contract-with-followed-pointer** — first-explicit-observation. The deprecation discipline from cycle 326 wasn't just documentation; it was a *soft contract* that the rest of the family honored. The @deprecated re-export remains in patterns/index.js for *external* consumers; *internal* consumers in @endo/* follow the pointer. **§the-named-internal-consumers-follow-deprecation-pointers** — first-explicit-observation.

This is the *implementation-side closure* of cycle 326's deprecation discipline. Cycle 326 (designs-lane) said *"Import directly from @endo/common"*; cycle 332 (chat-lane) does exactly that, six cycles later. **§the-named-citation-arc-from-cycle-326-takes-6-cycles-to-close** as a deprecation-followed-in-practice arc.
