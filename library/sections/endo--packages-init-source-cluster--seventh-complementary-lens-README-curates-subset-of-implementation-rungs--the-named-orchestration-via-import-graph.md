---
title: §the-named-orchestration-via-import-graph
source: endo--packages-init-source-cluster
url: https://github.com/endojs/endo/tree/master/packages/init
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/init/{index.js,debug.js,unsafe-fast.js,legacy.js,debug-async-hooks.js,pre.js,pre-remoting.js,pre-bundle-source.js}
total-lines: 66
ingest-cycle: 344
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-README-curates-subset-of-implementation-rungs
  - the-named-five-rungs-in-implementation-vs-three-in-README
  - the-named-two-shapes-of-tolerance-ladder-rung
  - the-named-re-export-from-variant-vs-direct-call-with-options
  - the-named-orchestration-via-import-graph
  - the-named-tiny-files-where-the-COMPOSITION-is-the-content
  - the-named-layered-shim-with-named-addition
  - the-named-pre-remoting-adds-eventual-send-to-pre
  - the-named-base64-and-promise-kit-as-canonical-pre-lockdown-shims
  - the-named-export-star-from-named-lockdown-variant
  - the-named-direct-import-and-call-when-custom-options
  - the-named-deprecated-with-named-replacement-in-source
  - the-named-async_hooks-patch-with-named-platform-limitation
  - the-named-doubled-underscores-as-internal-API-marker
  - the-named-complementary-lens-re-ingest
  - seven-cycles-with-named-complementary-lens-re-ingest
  - the-named-streak-resumes-with-twelfth-instance
  - thirty-five-cycles-with-named-pivot-domain-stay
  - one-hundred-five-citation-arc-closures-in-pivot-now
parent: endo--packages-init-source-cluster--seventh-complementary-lens-README-curates-subset-of-implementation-rungs
---

The 8 files form an IMPORT GRAPH:

```
unsafe-fast.js ──┐
                 ├──► pre-remoting.js ──► pre.js ──► @endo/lockdown
legacy.js ───────┤
index.js ────────┤                                  @endo/base64/shim
debug.js ────────┤                                  @endo/promise-kit/shim
debug-async-hooks.js ─┐
                      └──► (also imports ./src/node-async_hooks-patch.js)

pre-bundle-source.js (DEPRECATED) ──► pre.js
pre-remoting.js ──► @endo/eventual-send/shim
```

**§the-named-orchestration-via-import-graph** — first-explicit-observation as a tier-3 meta-pattern. The package's purpose is initialization-orchestration; the import graph IS the architecture. No file exceeds 12 lines because the graph carries the complexity.

**§the-named-tiny-files-where-the-COMPOSITION-is-the-content** — first-explicit-observation. Each file is tiny; the value is in HOW THEY COMPOSE. Compare to cycle 152's memo-race.js (170 lines; algorithmic complexity) vs cycle 344's init cluster (8 files × ~8 lines = composition-as-content).

**§two-shapes-of-substrate-package-implementation** — first-explicit-observation:

| Shape | Example | Complexity location |
|---|---|---|
| Single substantial file | cycle 338 make-hardener.js (471 lines) | Within one file |
| Tiny-files-orchestrated | cycle 344 init cluster (8 × ~8 lines) | In the import graph |
