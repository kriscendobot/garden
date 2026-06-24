---
title: Tier-3 borrowing (meta-patterns)
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

- **§the-named-deprecation-as-soft-contract-with-followed-pointer** — when a deprecation tag points to a canonical location, sibling code SHOULD use that location; the deprecation tag is a soft contract honored by internal consumers
- **§the-named-canonical-path-vs-backward-compatibility-path-distinction** — the deprecated re-export remains for external consumers; the canonical direct-import is for internal consumers; the two paths coexist
- **§the-named-three-sentinel-set-discipline** — three orthogonal sentinels at module scope for protocol vocabulary
- **§the-named-zero-copy-when-possible-discipline** — pay copy cost only when necessary; check the cheap condition first
- **§the-named-Reflect-destructure-grows-with-adoption** — substrate disciplines scale by *how many files adopt them* and *how aggressively each file uses them*
- **§the-named-substrate-file-has-minimal-local-imports** — the bottom-most file in a module's local dependency graph imports almost nothing locally
