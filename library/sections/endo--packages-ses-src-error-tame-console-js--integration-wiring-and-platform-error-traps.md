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
---

## Abstract

The §file opens (lines 1-13) with risk-minimizing imports from `commons.js` (the SES `TypeError`/`apply`/`defineProperty`/`freeze`/`globalThis` aliases) and the three SES-error-cluster siblings: `loggedErrorHandler` from `./assert.js` (cycle 98), `makeCausalConsole` from `./console.js` (cycle 96), `makeRejectionHandlers` from `./unhandled-rejection.js` (cycle 100). The §opening comment names the discipline: *Using TypeError minimizes risk of exposing the feral Error constructor* — the §don't-import-Error invariant. The §`failFast(message)` helper (lines 20-22) throws `TypeError(message)`; the §`wrapLogger(logger, thisArg)` helper (lines 24-25) returns a frozen `apply`-bound wrapper. The §`tameConsole(...)` factory (lines 38-197) is the *one entry point* SES's `lockdown.js` calls; it takes four parameters: `consoleTaming` (`'safe'` | `'unsafe'`), `errorTrapping` (`'platform'` | `'exit'` | `'abort'` | `'report'` | `'none'`), `unhandledRejectionTrapping` (`'report'` | `'none'`), and optional `optGetStackString`. The §five steps the factory performs: (1) pick `loggedErrorHandler` (default from `assert.js`, or spread-extended with custom `getStackString` if `optGetStackString` provided); (2) derive `originalConsole` — `globalThis.console` if present, else a five-method-log-stub built from `globalThis.print` for eshost SpiderMonkey, else `undefined`; (3) upgrade a log-only console — when `originalConsole.log` exists but `warn`/`error` don't, define them as aliases via `wrapLogger`; (4) compose `ourConsole` — `makeCausalConsole(originalConsole, loggedErrorHandler)` from cycle 96 unless `consoleTaming === 'unsafe'` (in which case the originalConsole passes through); (5) wire platform-API error traps for Node.js and Browser. The §platform-API access uses `globalThis.process` / `globalThis.window` (not bare `process` / `window`) to *avoid the overweaning gaze of Parcel* — Parcel would install a `process` shim that forces sloppy mode, which breaks SES's strict-mode invariant. The §Node.js wiring (lines 102-147) calls `process.on('uncaughtException')` + `process.on('unhandledRejection')` + `process.on('rejectionHandled')` + `process.on('exit')` with the four canonical handlers from `makeRejectionHandlers`. The §five-mode errorTrapping: `platform`/`exit` call `process.exit(exitCode || -1)`; `abort` calls `process.abort`; `report` just logs; `none` skips the trap entirely. The §Browser wiring (lines 149-193) calls `window.addEventListener('error')` + `addEventListener('unhandledrejection')` + `addEventListener('rejectionhandled')` + `addEventListener('beforeunload')`; the `exit`/`abort` modes redirect to `about:blank`. The §`SES_UNCAUGHT_EXCEPTION:` and `SES_UNHANDLED_REJECTION:` prefixes link to canonical docs in `packages/ses/error-codes/`. The §factory returns `{ console: ourConsole }` (lines 196).

## Body

### §The risk-minimizing-imports discipline

The §opening import block (lines 3-10):

```js
import {
  // Using TypeError minimizes risk of exposing the feral Error constructor
  TypeError,
  apply,
  defineProperty,
  freeze,
  globalThis,
} from '../commons.js';
```

The §comment names the §don't-import-Error invariant. SES's error-handling files use `TypeError(message)` instead of `Error(message)` for internal failures because:

- **`Error` is the most-general** — exposing it widens the surface area for *feral* code (un-tamed pre-lockdown) to access primordial behavior.
- **`TypeError` is narrower** — it carries the same shape (constructor + message + stack) but is a more-specific subtype.

The §discipline: *prefer the narrowest applicable error subtype*. The constructor itself is captured at module-load (via `commons.js`'s `TypeError` re-export, which is *the tamed/whitelisted reference*); using it through the captured-and-tamed binding *prevents accidental reach for the feral global*.

The §rationale: SES's lockdown.js runs *before* the rest of the application. If an SES-internal file accidentally references `Error` (the feral global), it might capture *the feral version before lockdown completes*. Using the `commons.js`-routed `TypeError` ensures the captured binding is *the tamed version*.

### §The two helpers: `failFast` and `wrapLogger`

The §`failFast` (lines 20-22):

```js
const failFast = message => {
  throw TypeError(message);
};
```

The §two-line discipline: a *short-circuit failure* helper for places where the invariant check is *terminal* (no recovery possible). Used in the platform-API checks below (`typeof exit === 'function' || failFast('missing process.exit')`).

The §`wrapLogger` (lines 24-25):

```js
const wrapLogger = (logger, thisArg) =>
  freeze((...args) => apply(logger, thisArg, args));
```

The §frozen-apply-binding helper. Used in the §eshost SpiderMonkey case where `globalThis.print` is a function but doesn't have a defined `this`-context. The §wrapper:

- **Captures `logger` and `thisArg` at construction**.
- **Applies them on each call** via `apply(logger, thisArg, args)`.
- **Freezes the resulting closure** so it can't be mutated.

The §design intent: *bind `this` and the logger reference at construction time; freeze the result so the binding can't be tampered with*.

### §The `tameConsole` factory signature

The §factory (lines 38-43):

```js
export const tameConsole = (
  consoleTaming = 'safe',
  errorTrapping = 'platform',
  unhandledRejectionTrapping = 'report',
  optGetStackString = undefined,
) => { ... };
```

The §four-parameter shape:

- **`consoleTaming`** (default `'safe'`) — `'safe'` wraps the original console with `makeCausalConsole`; `'unsafe'` passes through the original unmodified.
- **`errorTrapping`** (default `'platform'`) — five modes: `'platform'` / `'exit'` / `'abort'` / `'report'` / `'none'`.
- **`unhandledRejectionTrapping`** (default `'report'`) — two modes: `'report'` / `'none'`.
- **`optGetStackString`** (default `undefined`) — optional override of the loggedErrorHandler's `getStackString`.

The §defaults: *safe console* + *platform error traps* + *report unhandled rejections* + *default stack-string*. This is the SES *production-default* configuration — wrap, trap, report.

### §The loggedErrorHandler selection

The §lines 44-52:

```js
let loggedErrorHandler;
if (optGetStackString === undefined) {
  loggedErrorHandler = defaultHandler;
} else {
  loggedErrorHandler = {
    ...defaultHandler,
    getStackString: optGetStackString,
  };
}
```

The §two-mode selection:

- **`optGetStackString === undefined`** → use the default handler (imported as `defaultHandler` from `assert.js`, the cycle 98 export).
- **`optGetStackString` provided** → spread-extend the default handler with the custom `getStackString` override.

The §design intent: the maintainer can override the stack-string capability without rebuilding the whole handler. This is the *narrow-customization* hook for embeddings that have their own stack-string source (e.g., a remote-debugger that gets stacks from a different channel).

### §The originalConsole derivation

The §lines 54-68:

```js
const originalConsole = (
  typeof globalThis.console !== 'undefined'
    ? globalThis.console
    : typeof globalThis.print === 'function'
      ? (p => freeze({ debug: p, log: p, info: p, warn: p, error: p }))(
          wrapLogger(globalThis.print),
        )
      : undefined
);
```

The §three-tier fallback:

1. **`globalThis.console` exists** → use it directly. Most environments (Node, browsers, deno).
2. **`globalThis.print` exists** → build a five-method console where every method aliases `print`. This handles eshost SpiderMonkey, which has `print` but no `console`. The §comment names this:

   > Make a good-enough console for eshost (including only functions that log at a specific level with no special argument interpretation). https://console.spec.whatwg.org/#logging

3. **Neither exists** → `undefined`. The subsequent code handles this case by skipping console-wrapping.

The §design intent: *gracefully degrade*. Some constrained environments (eshost test runners, embedded scripting hosts) lack a full console but have *some* logging primitive. The factory builds a minimal but compliant console from whatever is available.

The §five-method stub (`debug`/`log`/`info`/`warn`/`error`) matches the §Whatwg console spec's *severity-level methods*. Other methods (`assert`/`trace`/`group`/etc.) are *not* included in the stub — only the level methods, because *those are what causal-console rendering needs*.

### §The log-only-console upgrade

The §lines 70-79:

```js
if (originalConsole && originalConsole.log) {
  for (const methodName of ['warn', 'error']) {
    if (!originalConsole[methodName]) {
      defineProperty(originalConsole, methodName, {
        value: wrapLogger(originalConsole.log, originalConsole),
      });
    }
  }
}
```

The §upgrade path. Some environments (`eshost -h SpiderMonkey` per the comment) have only `console.log` but not `console.warn` or `console.error`. The §upgrade defines `warn` and `error` as aliases for `log` (via `wrapLogger`).

The §discipline: *don't fail on incomplete consoles; upgrade them*. The §`defineProperty` (not direct assignment) gives the upgraded methods the standard property-descriptor shape; this matches what `globalThis.console` looks like across environments.

The §rationale: the causal console downstream needs `warn` and `error` available (it dispatches errors to `console.error`). If only `log` exists, the upgrade ensures the downstream code can call `warn`/`error` without crashing.

### §The ourConsole composition

The §lines 81-85:

```js
const ourConsole = (
  consoleTaming === 'unsafe'
    ? originalConsole
    : makeCausalConsole(originalConsole, loggedErrorHandler)
);
```

The §two-mode composition:

- **`consoleTaming === 'unsafe'`** → use the original console directly. Errors render via `Error.prototype.toString()`; no causal-console rendering; no error-tag cross-referencing.
- **`consoleTaming === 'safe'`** (default) → wrap with `makeCausalConsole` (from cycle 96's `console.js`), passing the `loggedErrorHandler` (from cycle 98's `assert.js`). Errors render with full cause/errors/notes/sub-error structure.

The §design intent: *safe mode is the default*; unsafe mode is an opt-out for environments that need raw error output (e.g., test runners that parse console output and need IEEE-754-Error-like formatting).

### §The avoid-Parcel-gaze discipline

The §lines 91-96 (comment):

> In the following Node.js and web browser cases, `process` and `window` are spelled as `globalThis` properties to avoid the overweaning gaze of Parcel, which dutifully installs an unnecessary `process` shim if we ever utter that. That unnecessary shim forces the whole bundle into sloppy mode, which in turn breaks SES's strict mode invariant.

The §discipline: **`globalThis.process` not bare `process`**. Parcel (the bundler) scans for *bare references to `process`* and *installs a shim* if it sees one. The shim:

- **Forces the bundle into sloppy mode** — Parcel's shim is sloppy-mode JavaScript.
- **Breaks SES's strict-mode invariant** — SES requires strict mode across the whole loaded codebase.

The §workaround: *spell the reference via `globalThis`*. `globalThis.process` is *not pattern-matched* by Parcel's scanner, so the shim isn't injected. The runtime semantics are identical (both resolve to the same `process` object); the lexical form differs.

The §similar discipline for `window` — `globalThis.window` not bare `window` — preserves the same protection against future bundler-scanner additions.

The §`/* eslint-disable @endo/no-polymorphic-call */` (line 100) — the §`@endo/no-polymorphic-call` ESLint rule normally flags `obj.method(...)` calls for capability-discipline (preferring `methodForObj.call(obj, ...)` to make the capability-flow explicit). For the platform-API section, polymorphic calls are *unavoidable* (you can't call `process.on(...)` without doing a polymorphic call). The §disable comment opts out for this section only.

### §The Node.js error-trap wiring

The §lines 102-127:

```js
const globalProcess = globalThis.process || undefined;
if (
  errorTrapping !== 'none' &&
  typeof globalProcess === 'object' &&
  typeof globalProcess.on === 'function'
) {
  let terminate;
  if (errorTrapping === 'platform' || errorTrapping === 'exit') {
    const { exit } = globalProcess;
    typeof exit === 'function' || failFast('missing process.exit');
    terminate = () => exit(globalProcess.exitCode || -1);
  } else if (errorTrapping === 'abort') {
    terminate = globalProcess.abort;
    typeof terminate === 'function' || failFast('missing process.abort');
  }

  globalProcess.on('uncaughtException', error => {
    // See https://github.com/endojs/endo/blob/master/packages/ses/error-codes/SES_UNCAUGHT_EXCEPTION.md
    ourConsole.error('SES_UNCAUGHT_EXCEPTION:', error);
    if (terminate) {
      terminate();
    }
  });
}
```

The §two-step:

1. **Pick the terminate behavior** based on errorTrapping mode. `platform`/`exit` build a closure that calls `process.exit(exitCode || -1)`. `abort` uses `process.abort` directly. `report`/`none` leave `terminate` undefined (no termination).
2. **Register the `uncaughtException` handler** that logs via `ourConsole.error('SES_UNCAUGHT_EXCEPTION:', error)` and optionally calls `terminate()`.

The §`failFast('missing process.exit')` / `failFast('missing process.abort')` — *fail-loud-not-degrade* discipline. If the maintainer requested `'exit'` mode but `process.exit` doesn't exist, throw immediately. The §rationale: silent-ignore would leave the maintainer with *false security* — they think exit-on-error is wired up but it isn't.

The §`globalProcess.exitCode || -1` — preserve the exit code if set, otherwise use `-1`. The §discipline: *propagate the maintainer's intent through to the exit code*.

The §lines 129-147 wire up rejection handlers via `makeRejectionHandlers` from cycle 100:

```js
const h = makeRejectionHandlers(handleRejection);
if (h) {
  // Rejection handlers are supported.
  globalProcess.on('unhandledRejection', h.unhandledRejectionHandler);
  globalProcess.on('rejectionHandled', h.rejectionHandledHandler);
  globalProcess.on('exit', h.processTerminationHandler);
}
```

The §three-event registration matches `makeRejectionHandlers`'s three-handler shape (cycle 100's design): unhandled-entry + handled-after-the-fact + at-exit-flush. The §`if (h)` guard handles the case where `makeRejectionHandlers` returned `undefined` (no `FinalizationRegistry`).

### §The Browser error-trap wiring

The §lines 149-193 mirror the Node.js wiring for the browser:

```js
const globalWindow = globalThis.window || undefined;
if (
  errorTrapping !== 'none' &&
  typeof globalWindow === 'object' &&
  typeof globalWindow.addEventListener === 'function'
) {
  globalWindow.addEventListener('error', event => {
    event.preventDefault();
    ourConsole.error('SES_UNCAUGHT_EXCEPTION:', event.error);
    if (errorTrapping === 'exit' || errorTrapping === 'abort') {
      globalWindow.location.href = `about:blank`;
    }
  });
}
```

The §differences from Node:

- **`addEventListener` instead of `process.on`** — the browser DOM API.
- **`event.preventDefault()`** — suppresses the browser's *default* error reporting (since SES is taking over).
- **`about:blank` redirect for `exit`/`abort` modes** — the browser equivalent of `process.exit`. The §`window.location.href = 'about:blank'` navigates away from the broken page.

The §rejection-handler wiring (lines 166-193) similarly registers three events: `unhandledrejection` (browser case-sensitive!) + `rejectionhandled` + `beforeunload`. The §browser `beforeunload` corresponds to Node's `exit` — both fire when the page/process is about to terminate.

The §`event.preventDefault()` in each handler — without it, the browser would *also* log the rejection (causing double logging). With it, SES is the *sole reporter*.

### §The SES error-code prefixes

The §`SES_UNCAUGHT_EXCEPTION:` (lines 122, 158) and `SES_UNHANDLED_REJECTION:` (lines 135, 172) prefixes link to canonical docs:

```
// See https://github.com/endojs/endo/blob/master/packages/ses/error-codes/SES_UNCAUGHT_EXCEPTION.md
```

The §discipline: *every SES-internal-error-log prefix maps to a doc*. A maintainer or user seeing `SES_UNCAUGHT_EXCEPTION:` in logs can search the SES error-codes directory for the explanation. The §URL is *canonical and stable* — `packages/ses/error-codes/SES_UNCAUGHT_EXCEPTION.md` exists in the repo.

The §reusable pattern: *named-error-prefix + URL-to-doc*. The error-code namespace is `SES_<CAPS_WITH_UNDERSCORES>:`. The doc lives at `packages/ses/error-codes/<CODE>.md`.

### §The factory returns `{ console: ourConsole }`

The §return (line 196):

```js
return { console: ourConsole };
```

The §single-property-object return shape. The caller (SES's `lockdown.js`) destructures: `const { console } = tameConsole(...)` and replaces `globalThis.console` with the wrapped version.

The §design intent: *return a record, not the bare console*. The record shape is *extensible* — future versions could return additional fields (e.g., `{ console, errorHandlers, ... }`) without breaking callers who only destructure `console`.

## Connection to the wider library

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

## Translation block (comment idiom → contemporary practice)

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

## See also

- [[hardened-javascript]] (topic) — the SES substrate.
- [[errors]] (topic) — the SES error-handling system; this file is the *integration / top-level wiring* layer.
- `endo--packages-ses-src-error-assert-js--*` (cycle 98) — the SES assert substrate; `loggedErrorHandler` imported and composed here.
- `endo--packages-ses-src-error-console-js--*` (cycle 96) — the SES causal-console; `makeCausalConsole` imported and composed here.
- `endo--packages-ses-src-error-unhandled-rejection-js--*` (cycle 100) — the SES rejection-tracking; `makeRejectionHandlers` imported and wired to platform events here.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--*` (cycle 93) — the V8-attenuated getStackString; consumed via `loggedErrorHandler.getStackString` or via the `optGetStackString` parameter.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the causal-annotation producer; produces the annotations the causal-console renders.

## Common confusions

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
