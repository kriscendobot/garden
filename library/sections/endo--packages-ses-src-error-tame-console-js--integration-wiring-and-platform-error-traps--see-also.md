---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate.
- [[errors]] (topic) — the SES error-handling system; this file is the *integration / top-level wiring* layer.
- `endo--packages-ses-src-error-assert-js--*` (cycle 98) — the SES assert substrate; `loggedErrorHandler` imported and composed here.
- `endo--packages-ses-src-error-console-js--*` (cycle 96) — the SES causal-console; `makeCausalConsole` imported and composed here.
- `endo--packages-ses-src-error-unhandled-rejection-js--*` (cycle 100) — the SES rejection-tracking; `makeRejectionHandlers` imported and wired to platform events here.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--*` (cycle 93) — the V8-attenuated getStackString; consumed via `loggedErrorHandler.getStackString` or via the `optGetStackString` parameter.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the causal-annotation producer; produces the annotations the causal-console renders.
