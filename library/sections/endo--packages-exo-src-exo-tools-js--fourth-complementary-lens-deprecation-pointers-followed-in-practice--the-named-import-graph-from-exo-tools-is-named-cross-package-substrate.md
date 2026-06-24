---
title: §the-named-import-graph-from-exo-tools-IS-named-cross-package-substrate
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

Lines 1-17 of exo-tools.js import from **six @endo packages plus one local file**:

| Import source | Names | Closes arc with |
|---|---|---|
| `@endo/harden` | `harden` | (substrate) |
| `@endo/eventual-send` | `E` | cycle 321 (11 cycles) |
| `@endo/pass-style` | `getRemotableMethodNames`, `toThrowable`, `Far` | cycle 325 (7 cycles) |
| `@endo/patterns` | `mustMatch`, `M`, `isAwaitArgGuard`, `isRawGuard`, `getAwaitArgGuardPayload`, `getMethodGuardPayload`, `getInterfaceGuardPayload`, `getCopyMapEntries` | cycle 327 (5 cycles) |
| `@endo/common/list-difference.js` | `listDifference` | cycle 326 (6 cycles; deprecation-pointer-followed) |
| `@endo/common/object-map.js` | `objectMap` | cycle 326 (6 cycles; deprecation-pointer-followed) |
| `@endo/errors` | `q`, `Fail` | (substrate) |
| `./get-interface.js` | `GET_INTERFACE_GUARD` | cycle 239 (93 cycles) |

**§the-named-fan-out-import-graph-recurs** — cycle 322's exo-makers.js had **§the-named-import-graph-from-exo-IS-named-fan-out** (five external imports + one local); cycle 332's exo-tools.js has *seven* import sources (six external + one local). §two-cycles-with-named-fan-out-import-graph-from-exo (322 + 332). First-explicit-observation as a recurring discipline.

**§six-citation-arc-closures-in-cycle-332** (matching cycles 325 + 328 + 331 records): cycle 118 self via complementary-lens = 214 cycles + cycle 321 eventual-send = 11 + cycle 325 pass-style = 7 + cycle 326 patterns deprecation = 6 (deprecation-followed) + cycle 327 patterns README = 5 + cycle 331 exo README = 1 (fifth one-cycle README↔source arc closure). **§five-cycles-with-named-one-cycle-README-source-arc** (323→324 + 325→326 + 326→327 + 328→329 + 331→332). **§forty-one-citation-arc-closures-in-pivot-now** (35 + 6).
