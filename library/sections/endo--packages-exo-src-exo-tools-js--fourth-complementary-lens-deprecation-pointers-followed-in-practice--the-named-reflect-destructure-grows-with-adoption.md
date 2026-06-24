---
title: §the-named-Reflect-destructure-grows-with-adoption
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

Line 26: `const { apply, ownKeys } = Reflect;`

Compare to:
- Cycle 314 hex encode.js: `const { apply } = Reflect;` (one name)
- Cycle 318 hex decode.js: `const { apply } = Reflect;` (same one name)
- **Cycle 332 exo-tools.js**: `const { apply, ownKeys } = Reflect;` (two names)

**§three-cycles-with-named-Reflect-destructure-at-module-load** (314 + 318 + 332). The discipline grows with adoption: more files use it; some files destructure more names. **§the-named-Reflect-destructure-grows-with-adoption** — first-explicit-observation as a pivot-spanning discipline that scales by adoption rate.
