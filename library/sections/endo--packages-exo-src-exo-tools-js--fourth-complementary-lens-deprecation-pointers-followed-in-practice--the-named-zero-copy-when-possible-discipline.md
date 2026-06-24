---
title: §the-named-zero-copy-when-possible-discipline
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

Lines 52-94 (`defendSyncArgs`) implement a **zero-copy-when-possible** discipline for the matchable-args construction:

```js
// Use syncArgs if possible, but copy it when necessary to implement redactions.
let matchableArgs = syncArgs;
if (restArgGuardIsRaw && syncArgs.length > declaredLen) {
  // copy + redact
  ...
} else if (redactedIndices.length > 0 && redactedIndices[0] < syncArgs.length) {
  // copy the array, avoiding hardening the redacted ones
  matchableArgs = [...syncArgs];
}
```

The function tries to **reuse the original syncArgs array** if no redaction is needed; only copies when redaction must happen. **§the-named-zero-copy-when-possible-discipline** — first-explicit-observation as a performance discipline. The cost of a copy is paid only when necessary.

**§the-named-avoiding-hardening-the-redacted-ones** (line 72-73 comment) — *"avoiding hardening the redacted ones (which are trivially matched using REDACTED_RAW_ARG as a sentinel value)"*. The redacted slot is replaced by the sentinel *before* `harden()` is called; this avoids freezing the original value through the wrapped array. **§the-named-redact-before-harden-discipline** — first-explicit-observation.
