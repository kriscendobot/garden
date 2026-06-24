---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `Using TypeError minimizes risk of exposing the feral Error constructor` | The *don't-import-Error* invariant; prefer narrowest applicable error subtype via captured-and-tamed binding. |
| `Make a good-enough console for eshost` | The *gracefully-degrade-for-constrained-environments* discipline; build minimal-compliant from whatever's available. |
| `Upgrade a log-only console` | The *fix-up-incomplete-API discipline*; add aliases for missing methods. |
| `process and window are spelled as globalThis properties to avoid the overweaning gaze of Parcel` | The *escape-bundler-scanner-via-lexical-form* discipline; semantically identical but textually invisible. |
| `unnecessary shim forces the whole bundle into sloppy mode, which in turn breaks SES's strict mode invariant` | The *bundle-mode-invariant* — SES requires strict mode globally. |
| `Disable the polymorphic check for the rest of this file. It's too noisy when dealing with platform APIs.` | The *opt-out-of-discipline-for-platform-API* — when calling external APIs, capability-flow comments would be overwhelming. |
| `failFast(message)` helper | The *short-circuit-failure* helper for terminal invariant violations. |
| `wrapLogger(logger, thisArg)` frozen-apply-binding | The *bind-and-freeze-at-construction* discipline. |
| `SES_UNCAUGHT_EXCEPTION:` / `SES_UNHANDLED_REJECTION:` prefixes | The *named-error-prefix + URL-to-doc* discipline. |
| `event.preventDefault()` in browser handlers | The *take-over-platform-reporting* discipline; suppress default to avoid double logging. |
| `globalWindow.location.href = 'about:blank'` for exit/abort | The *browser-equivalent-of-process.exit* — navigate away from broken page. |
| `consoleTaming === 'unsafe' ? originalConsole : makeCausalConsole(...)` | The *safe-default-with-unsafe-opt-out* configuration shape. |
| `errorTrapping` 5-mode enumeration | The *platform/exit/abort/report/none* trap-mode vocabulary. |
| `return { console: ourConsole }` single-property object | The *extensible-return-shape* discipline; record not bare value. |
