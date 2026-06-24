---
title: Common confusions
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

- **"`TypeError` is just another `Error` subclass — why care?"** The §discipline cares because of *what reference is being captured*. The `commons.js`-routed `TypeError` is the *tamed* version; a bare `Error` reference (from before SES lockdown) would capture the *feral* version. Using the narrowest applicable subtype routed through `commons.js` is *both* about subtype-specificity *and* about taming.
- **"`globalThis.process` is the same as `process` at runtime."** It is — *at runtime*. The difference is *lexical*. Bundlers like Parcel scan source code for the bare `process` token; the `globalThis.process` form is *not pattern-matched*. The §discipline is about *bundler-time invariance*, not *runtime semantics*.
- **"`failFast` is just a helper — why not inline `throw TypeError(...)`?"** The helper is *one place to control failure shape*. If SES ever needed to log the failure or do something pre-throw, only the helper would change. Inlined throws would require code-wide updates.
- **"`originalConsole` derivation is over-engineered — most environments have `globalThis.console`."** Most do — *and the fallback handles the rest*. The §`eshost` fallback handles the SpiderMonkey test runner; the `undefined` fallback handles deeply-constrained embedded environments. SES is designed to work *across* the JavaScript-environment landscape; the fallback is not over-engineering, it's *coverage*.
- **"Polymorphic calls disabled for the file is a cap-discipline violation."** It is *necessary*. The platform APIs (`process.on`, `window.addEventListener`) cannot be called non-polymorphically — there's no way to extract the method as a value first. The §opt-out is scoped to the platform-API section; the rest of SES enforces the no-polymorphic-call rule.
- **"`event.preventDefault()` in the browser handler suppresses error display — that's surprising."** It's *intentional*. Without it, the browser would *also* log the error to console (in addition to SES's `ourConsole.error('SES_UNCAUGHT_EXCEPTION:', ...)`), producing double output. The §discipline: SES is the *sole reporter* once active.
- **"`about:blank` redirect is browser-specific magic."** It is — and *documented* as the browser-equivalent of `process.exit`. The §discipline: *redirect to a blank page* is the closest the browser comes to *exit-the-process* semantics. The page is gone; the user sees a blank tab.
- **"The factory returns `{ console: ourConsole }` not just `ourConsole` — that's awkward."** The §record-return shape is *extensible*. Future versions of `tameConsole` could return additional fields (e.g., `{ console, errorHandlers, lifecycle }`) without breaking destructuring-callers. Returning a bare console would lock the API.
- **"`SES_UNCAUGHT_EXCEPTION:` prefix is just a string."** It is *part of a discipline*. The prefix is structured (`SES_<CAPS_UNDERSCORES>:`), and every prefix maps to a doc at `packages/ses/error-codes/<CODE>.md`. Users seeing the prefix can search the docs directory; it's a *named-vocabulary* for SES-emitted error logs.
- **"`makeRejectionHandlers` returns undefined sometimes — that's a partial-feature situation."** It is — and the `if (h)` guard handles it. The §discipline: *graceful-degradation when FinalizationRegistry is absent*. The factory still returns a working console; just without the GC-driven rejection detection. The platform-event rejection handlers from `unhandledRejection`/`rejectionHandled` still work; only the GC-finalization path is skipped.
