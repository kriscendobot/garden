---
title: "`@endo/exo src/exo-tools.js` — fourth complementary-lens re-ingest; deprecation pointers followed in practice"
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

The 513-line exo-tools.js. Cycle 332 is **chat-lane after cycle 331's designs-lane @endo/exo README**. **Twenty-third consecutive non-garden source after the pivot** (cycles 310-332). **§twenty-three-cycles-with-named-pivot-domain-stay**.

**Note on prior ingest**: This file was first ingested in **cycle 118** by a scholar dispatch (comment-fragment, 19th ingest, paired with cycle 108 exo-makers.js). The cycle 118 sections (2 sections; lines 1-346 + lines 348-513) took the *method-defense + prototype-building* lens with focus on TOCTTOU-aware context lookup, chained .catch, raw-guard redaction, buildMatchConfig, defendSyncMethod with concise-method-syntax, desync transformer, callKind dispatch, bindMethod, constructor-filter, symmetric listDifference, thisful-vs-shifted, GET_INTERFACE_GUARD auto-installation, defendPrototypeKit single-facet rejection.

Cycle 332 is a **§the-named-complementary-lens-re-ingest** (librarian discipline first-explicit-observed in cycle 322 for exo-makers.js, applied to atomics.js in cycle 324, then smallcaps.js in cycle 330). **§four-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332) — the discipline now spans **four applications**. The cycle 332 lens emphasizes:

1. **Cross-package import-graph closures** (six citation arcs to cycles in the pivot)
2. **Cycle 326 deprecation-pointers-followed-in-practice** — exo-tools.js demonstrates the *correct* import path that cycle 326's patterns/index.js @deprecated tags pointed to
3. **Three-sentinel-set** at module scope (RawMethodGuard + PassableMethodGuard + REDACTED_RAW_ARG)
4. **Zero-copy-when-possible** performance discipline in defendSyncArgs
5. **Reflect destructure grows with adoption** — cycle 332 expands the pattern from cycle 314/318's single-name to two-name
