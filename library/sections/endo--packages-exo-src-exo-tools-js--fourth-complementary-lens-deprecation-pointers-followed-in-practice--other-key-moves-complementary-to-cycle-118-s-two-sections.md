---
title: Other key moves (complementary to cycle 118's two sections)
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

- **§the-named-PassableMethodGuard-IS-named-implied-by-all-non-raw-guards** (line 40-43 comment) — *"This is the least possible non-raw enforcement for a method guard, and is implied by all other non-raw method guards."* PassableMethodGuard is the **bottom** of the non-raw enforcement lattice. First-explicit-observation.

- **§the-named-import-from-common-not-patterns-IS-named-canonical-after-deprecation** — exo-tools.js demonstrates the canonical post-deprecation import path; cycle 326's @deprecated re-exports remain for backward compatibility but the canonical path is the direct import. §the-named-canonical-path-vs-backward-compatibility-path-distinction.

- **§the-named-eight-named-imports-from-patterns** — exo-tools.js imports eight names from @endo/patterns (mustMatch + M + isAwaitArgGuard + isRawGuard + getAwaitArgGuardPayload + getMethodGuardPayload + getInterfaceGuardPayload + getCopyMapEntries). The eight names span four different categorical groups: assertion (mustMatch) + builder (M) + predicates (isAwait/isRaw) + extractors (getAwait/getMethod/getInterface/getCopyMap). **§the-named-multi-categorical-import-from-one-package** — first-explicit-observation.

- **§the-named-three-names-from-pass-style** (line 3) — `getRemotableMethodNames`, `toThrowable`, `Far` — three orthogonal names from pass-style: introspection + error-handling + remotable-creation. First-explicit-observation as a *narrow-import-vs-broad-import* example (cycle 325 pass-style README named `Far` + `passStyleOf` + `passableSymbolForName` as the canonical surface; exo-tools uses three but not all).

- **§the-named-only-one-local-import** — `import { GET_INTERFACE_GUARD } from './get-interface.js';` is the *only* local import (line 17). Compare to cycle 322 exo-makers.js which had one local import (defendPrototype + defendPrototypeKit from exo-tools.js). exo-tools is the *bottom* of the exo internal layer; it doesn't import from other exo files except get-interface.js (a tiny 28-line constant file from cycle 239). **§the-named-substrate-file-has-minimal-local-imports** — first-explicit-observation.
