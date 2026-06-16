---
title: The *integration / top-level wiring* file that composes the SES causal-console substrate — `tameConsole(consoleTaming, errorTrapping, unhandledRejectionTrapping, optGetStackString)` is the one entry point SES's lockdown calls; the §risk-minimizing-imports opener (*Using TypeError minimizes risk of exposing the feral Error constructor*); the `failFast(message)` helper that just throws TypeError + the `wrapLogger(logger, thisArg)` frozen-apply-binding helper used for the eshost SpiderMonkey case; the §loggedErrorHandler selection — default from `assert.js` (cycle 98) or spread-extended with custom `getStackString`; the §originalConsole derivation — `globalThis.console` if present, else build a five-method-log-stub from `globalThis.print` for eshost, else undefined; the §log-only-console upgrade — when `originalConsole.log` exists but `warn`/`error` don't, define them as aliases via `wrapLogger`; the §ourConsole composition via `makeCausalConsole(originalConsole, loggedErrorHandler)` from cycle 96 unless `consoleTaming === 'unsafe'` (in which case the originalConsole passes through); the §platform-API access via `globalThis.process` / `globalThis.window` (not bare `process`/`window`) to *avoid the overweaning gaze of Parcel* (which would install a sloppy-mode-forcing `process` shim); the §`/* eslint-disable @endo/no-polymorphic-call */` for the platform-API section where polymorphic calls are unavoidable; the §Node.js error-trap wiring (`process.on('uncaughtException')` + `process.on('unhandledRejection')` + `process.on('rejectionHandled')` + `process.on('exit')`); the §Browser error-trap wiring (`window.addEventListener('error')` + `addEventListener('unhandledrejection')` + `addEventListener('rejectionhandled')` + `addEventListener('beforeunload')`); the §five-mode errorTrapping enumeration (`platform` / `exit` / `abort` / `report` / `none`) with `exit` calling `process.exit(exitCode || -1)` and `abort` calling `process.abort`; the §`SES_UNCAUGHT_EXCEPTION:` / `SES_UNHANDLED_REJECTION:` error-code prefixes that link to canonical docs in `packages/ses/error-codes/`; the §browser `about:blank` redirect for `exit`/`abort` modes
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps--abstract.md)
- [Body](endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps--see-also.md)
- [Common confusions](endo--packages-ses-src-error-tame-console-js--integration-wiring-and-platform-error-traps--common-confusions.md)
