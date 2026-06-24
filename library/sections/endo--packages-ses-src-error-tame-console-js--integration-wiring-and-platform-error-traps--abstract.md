---
title: Abstract
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

The §file opens (lines 1-13) with risk-minimizing imports from `commons.js` (the SES `TypeError`/`apply`/`defineProperty`/`freeze`/`globalThis` aliases) and the three SES-error-cluster siblings: `loggedErrorHandler` from `./assert.js` (cycle 98), `makeCausalConsole` from `./console.js` (cycle 96), `makeRejectionHandlers` from `./unhandled-rejection.js` (cycle 100). The §opening comment names the discipline: *Using TypeError minimizes risk of exposing the feral Error constructor* — the §don't-import-Error invariant. The §`failFast(message)` helper (lines 20-22) throws `TypeError(message)`; the §`wrapLogger(logger, thisArg)` helper (lines 24-25) returns a frozen `apply`-bound wrapper. The §`tameConsole(...)` factory (lines 38-197) is the *one entry point* SES's `lockdown.js` calls; it takes four parameters: `consoleTaming` (`'safe'` | `'unsafe'`), `errorTrapping` (`'platform'` | `'exit'` | `'abort'` | `'report'` | `'none'`), `unhandledRejectionTrapping` (`'report'` | `'none'`), and optional `optGetStackString`. The §five steps the factory performs: (1) pick `loggedErrorHandler` (default from `assert.js`, or spread-extended with custom `getStackString` if `optGetStackString` provided); (2) derive `originalConsole` — `globalThis.console` if present, else a five-method-log-stub built from `globalThis.print` for eshost SpiderMonkey, else `undefined`; (3) upgrade a log-only console — when `originalConsole.log` exists but `warn`/`error` don't, define them as aliases via `wrapLogger`; (4) compose `ourConsole` — `makeCausalConsole(originalConsole, loggedErrorHandler)` from cycle 96 unless `consoleTaming === 'unsafe'` (in which case the originalConsole passes through); (5) wire platform-API error traps for Node.js and Browser. The §platform-API access uses `globalThis.process` / `globalThis.window` (not bare `process` / `window`) to *avoid the overweaning gaze of Parcel* — Parcel would install a `process` shim that forces sloppy mode, which breaks SES's strict-mode invariant. The §Node.js wiring (lines 102-147) calls `process.on('uncaughtException')` + `process.on('unhandledRejection')` + `process.on('rejectionHandled')` + `process.on('exit')` with the four canonical handlers from `makeRejectionHandlers`. The §five-mode errorTrapping: `platform`/`exit` call `process.exit(exitCode || -1)`; `abort` calls `process.abort`; `report` just logs; `none` skips the trap entirely. The §Browser wiring (lines 149-193) calls `window.addEventListener('error')` + `addEventListener('unhandledrejection')` + `addEventListener('rejectionhandled')` + `addEventListener('beforeunload')`; the `exit`/`abort` modes redirect to `about:blank`. The §`SES_UNCAUGHT_EXCEPTION:` and `SES_UNHANDLED_REJECTION:` prefixes link to canonical docs in `packages/ses/error-codes/`. The §factory returns `{ console: ourConsole }` (lines 196).
