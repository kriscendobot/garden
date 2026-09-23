---
title: Connection to the wider library
source: packages/ses/src/error/tame-console.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
source_lines: "1-197 (full file)"
topics: [hardened-javascript, errors]
status: current
notes: |
  Fifteenth comment-fragment ingest. **The integration file that
  wires the SES causal-console substrate together** — imports from
  cycle 96 (`makeCausalConsole`), cycle 98 (`loggedErrorHandler`),
  and cycle 100 (`makeRejectionHandlers`); composes them into the
  single `tameConsole(...)` factory that SES's lockdown.js calls.
  Mark S. Miller-authored. Four structurally interesting moves:
  (1) the *risk-minimizing-imports* discipline at the top of the
  file — *Using TypeError minimizes risk of exposing the feral
  Error constructor* — surfaces the *don't-import-Error* invariant
  that pervades SES error-handling files; (2) the *originalConsole
  derivation* that gracefully degrades from `globalThis.console`
  to a `globalThis.print`-built five-method-log-stub for eshost
  SpiderMonkey to `undefined`; (3) the *avoid Parcel overweaning
  gaze* discipline — `globalThis.process` / `globalThis.window`
  instead of bare `process` / `window` because Parcel would
  install a `process` shim forcing sloppy-mode and breaking
  SES's strict-mode invariant; (4) the *canonical error-code
  prefix-with-link* discipline — `SES_UNCAUGHT_EXCEPTION:` and
  `SES_UNHANDLED_REJECTION:` prefixes link to canonical docs in
  `packages/ses/error-codes/`. Single-section cohesion-honest
  ingest. Pairs structurally with the earlier SES error-handling
  cycles to complete the full *SES error-observation surface*:
  assert.js (state + user surface) → track-turns.js (annotations)
  → tame-v8 (stack-string) → console.js (rendering) →
  unhandled-rejection.js (GC-driven rejection detection) →
  tame-console.js (this ingest; *integration / wiring*).
parent: endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps
---

This section is the **canonical *integration-file-that-wires-a-substrate* worked example**. Four threads:

1. **The risk-minimizing-imports discipline** (using `TypeError` not `Error` from `commons.js`) is reusable for any SES-internal file that needs error-construction. The §don't-import-Error invariant prevents accidentally capturing the feral global.

2. **The originalConsole gracefully-degrading fallback** (`globalThis.console` → `globalThis.print` stub → undefined) is reusable for any *environment-detection-with-fallback* shape. Three tiers; each fallback is more limited; the code handles each gracefully.

3. **The avoid-Parcel-gaze discipline** (`globalThis.process` / `globalThis.window` not bare `process` / `window`) is reusable for any code that needs to *escape bundler scanners* while preserving semantics. The §lexical-form-matters observation is structurally significant.

4. **The SES_<CODE>:-prefix-with-URL pattern** is the canonical *named-error-prefix + doc-link* discipline. Every SES-internal error log carries an enumerated code that maps to a documented explanation.

The §SES causal-console architecture (cycles 90 + 93 + 96 + 98 + 100 + 106) is now *fully described in the library*:

- **Cycle 90** `track-turns.js` — annotations producer.
- **Cycle 93** `tame-v8-error-constructor.js` — getStackString capability.
- **Cycle 96** `console.js` — causal-console rendering.
- **Cycle 98** `assert.js` — state + loggedErrorHandler bridge.
- **Cycle 100** `unhandled-rejection.js` — GC-driven rejection detection.
- **Cycle 106** `tame-console.js` (this ingest) — *integration / wiring*.

This cycle completes the substrate. `tame-console.js` is the file SES's `lockdown.js` calls; it composes everything together.
