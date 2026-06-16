---
title: Synthesis-target
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

Slot machine library **§`@game/exo/src/exo-tools.js`** — method-defense substrate:

1. **Follow deprecation pointers in practice** — if the project deprecates a re-export, sibling code in the same family imports from the canonical location directly.
2. **Three-sentinel set** at module scope for protocol vocabulary (e.g., GameRawMethodGuard + GAME_REDACTED_ARG + GamePassableMethodGuard).
3. **Zero-copy-when-possible discipline** — check the cheap condition first; copy only when necessary.
4. **Redact before harden** — replace sensitive slots with sentinels *before* calling harden, so the original values stay unfrozen.
5. **Reflect destructure** at module load for tamper resistance; expand the destructure as the file's needs grow.
6. **Multi-categorical import from one package** — when a package's API has multiple functional categories, name them deliberately at import time.
7. **Substrate file has minimal local imports** — the bottom-most file imports almost nothing local; it depends only on language primitives and same-org packages.
8. **Canonical-path-vs-backward-compatibility-path distinction** — internal consumers use canonical paths; external consumers use the deprecated-but-still-working surface.
