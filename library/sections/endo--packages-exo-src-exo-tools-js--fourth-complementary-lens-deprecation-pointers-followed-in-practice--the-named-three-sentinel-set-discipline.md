---
title: §the-named-three-sentinel-set-discipline
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

Lines 29-44 define **three module-scope sentinels** for the method-defense protocol:

```js
const RawMethodGuard = M.call().rest(M.raw()).returns(M.raw());
const REDACTED_RAW_ARG = '<redacted raw arg>';
const PassableMethodGuard = M.call().rest(M.any()).returns(M.any());
```

| Sentinel | Type | Role |
|---|---|---|
| `RawMethodGuard` | MethodGuard | No enforcement; "anything goes" escape hatch |
| `REDACTED_RAW_ARG` | string | Redaction marker for raw-arg pattern-matching |
| `PassableMethodGuard` | MethodGuard | Least non-raw enforcement (passable-only) |

**§the-named-raw-vs-passable-distinction-with-two-default-guards** — RawMethodGuard accepts *anything* (including non-passable); PassableMethodGuard requires *passable* but accepts any shape. The two represent the *minimum-enforcement* end of the enforcement spectrum.

**§the-named-string-sentinel-for-pattern-match-redaction** — REDACTED_RAW_ARG is a *human-readable* sentinel string used as a placeholder when raw arguments are excluded from pattern matching. First-explicit-observation. The string's content (`'<redacted raw arg>'`) makes it *obvious in stack traces or debug output* that the value is a redaction marker, not real data. Compare to cycle 322 exo-makers' use of WeakMap-membership-as-type-predicate (a different sentinel pattern — *absence* from a map, not *presence* of a string value).

**§the-named-three-sentinel-set-discipline** — three orthogonal sentinels at module scope, each serving a distinct role in the method-defense protocol. First-explicit-observation as a recurring pattern for protocol vocabulary.
