---
source: packages/{eventual-send,promise-kit,ses-ava}/* (shim + prepare-endo cluster)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages
source_path: packages/eventual-send/{shim,utils}.js, packages/eventual-send/src/postponed.js, packages/promise-kit/{shim,index}.js, packages/promise-kit/src/is-promise.js, packages/ses-ava/{index,prepare-endo,prepare-endo-config}.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - eventual-send
  - getting-started
  - testing
genre: §endo-source-comment-fragment §shim-and-prepare-cluster
cycle: 187
lane: chat
status: current
---

# The shim-and-prepare-endo cluster: two shim strategies side by side, default-export-masking for AVA config, and BestPipelinablePromise dispatch

> §Chat-lane after cycle 186's designs-lane. §The-twenty-first-
> consecutive designs/chat alternation cycle (166-187). §This-
> cycle-ingests the §shim-and-prepare-endo-cluster that
> cycle 183-init's §shim-assembly-order names load-bearing:
> "lockdown → base64 → promise-kit → eventual-send".

`packages/eventual-send/`, `packages/promise-kit/`, and
`packages/ses-ava/` together hold the §canonical-shim-pattern
that cycle 183-init's `pre.js` and `pre-remoting.js` assemble.
158 lines across 9 files:

| File | Lines | Role |
|------|-------|------|
| `eventual-send/shim.js`           |  6 | Conditional HandledPromise install |
| `eventual-send/utils.js`          |  2 | Barrel re-export |
| `eventual-send/src/postponed.js`  | 46 | Postponed handler with interlock promise |
| `promise-kit/shim.js`             |  4 | Unconditional Promise.race replacement |
| `promise-kit/index.js`            | 53 | makePromiseKit + BestPipelinablePromise |
| `promise-kit/src/is-promise.js`   | 12 | Canonical Promise-detection |
| `ses-ava/index.js`                |  1 | Barrel |
| `ses-ava/prepare-endo.js`         | 27 | Three-purpose prepare module |
| `ses-ava/prepare-endo-config.js`  |  7 | Default-export-masking for AVA config |

§The-single-most-structurally-interesting-move is §two-shim-
strategies-side-by-side. §Both-files-named-shim.js live in
sibling packages, sit at the same point in cycle 183's
§shim-assembly-order, but use §opposite-disciplines-on-
existing-globals:

- **`eventual-send/shim.js`** uses §conditional-install:
  "don't override existing HandledPromise installation."
- **`promise-kit/shim.js`** uses §unconditional-replacement:
  "Promise.race is broken; always replace."

§The-asymmetric-shim-discipline is named here for the first
time across the library. §Cycle-183-init named the §pre-
lockdown-shim-discipline; §this-cycle reveals that the shim-
discipline is itself asymmetric: §conditional-vs-unconditional-
depends-on-whether-the-target-is-correct.

## §The-two-shim-strategies (the spine)

### §Conditional-install (eventual-send/shim.js)

```js
/* global globalThis */
import { makeHandledPromise } from './src/handled-promise.js';

if (typeof globalThis.HandledPromise === 'undefined') {
  globalThis.HandledPromise = makeHandledPromise();
}
```

§Six-lines-and-a-conditional. §The-discipline: §respect-prior-
installation. §If-another-shim-or-an-earlier-import already
installed HandledPromise, this file is a no-op.

§Why-conditional: HandledPromise is the §extension-point that
@endo/eventual-send defines for §eventual-send-aware-Promise-
implementations. §A-Compartment-may-install-a-different-
HandledPromise (cycle 66's handler-protocol) that already
satisfies the contract. §Don't-override-something-that's-
already-correct.

§Compare-to-cycle-175-make-selector.js' §race-to-install-at-
well-known-slot. §Both-are-§singleton-install-disciplines, but
cycle 175 pins on first install (configurable: false); cycle
187 eventual-send/shim simply yields to any prior installer.

### §Unconditional-replacement (promise-kit/shim.js)

```js
import { memoRace } from './src/memo-race.js';

// Unconditionally replace with a non-leaking version
Promise.race = memoRace;
```

§Four-lines-and-a-comment. §The-comment-is-the-justification:
"Promise.race" is replaced *unconditionally*.

§Why-unconditional: the platform's `Promise.race` has a
well-known §memory-leak (the unresolved values in the race
input hold onto the result Promise even after another value
wins). §Cycle-152-promise-kit's-§memo-race named the fix: a
race that cleans up after itself.

§The-platform-Promise.race-is-not-correct; §don't-respect-
prior-installation; §replace-unconditionally.

§Compare-to-cycle-183-lockdown's §domainTaming-unsafe-always-
injected — that's §unconditional-merge-of-safety-override.
§Promise.race-replacement is §unconditional-replacement-of-
broken-builtin. §Both-are-§unconditional-disciplines but for
different categories of "broken."

## §The-design-rule: §conditional-vs-unconditional-depends-on-whether-the-target-is-correct

§Two-rules-implicit-in-the-two-shims:

1. **If-the-target-may-be-correctly-installed-by-another-shim**:
   conditional install (§respect-prior-correctness).
2. **If-the-target-is-known-broken**:
   unconditional replacement (§don't-pretend-the-platform-is-
   correct-just-because-it's-the-default).

§Compare-to-cycle-180-hex-package's §belt-and-suspenders-for-
input-but-not-for-output. §Both-are-§asymmetric-disciplines-
based-on-which-side-needs-defense.

§The-`/* global globalThis */` ESLint directive at the top of
eventual-send/shim.js is necessary because shim.js is loaded
pre-lockdown when globalThis is not yet a tamed reference.
§Pre-lockdown-shim-discipline (cycle 181 base64 + cycle 183
init) requires acknowledging the global.

## §BestPipelinablePromise (promise-kit/index.js)

```js
/** @type {PromiseConstructor} */
const BestPipelinablePromise = globalThis.HandledPromise || Promise;
```

§The-dispatch-pattern: §pick-the-better-Promise-at-module-load.
§If-HandledPromise-was-installed (cycle 187-eventual-send-shim
or @endo/init/pre-remoting): use it. §Else: fall back to the
platform's `Promise`.

§Why-this-matters: cycle 66's HandledPromise supports
§eventual-send-pipelining via `then`-chained method calls
(`E(x).method().anotherMethod()` builds a pipeline rather
than awaiting each step). §A-`makePromiseKit()`-promise built
on HandledPromise inherits this property; on plain Promise,
it doesn't.

§The-`makePromiseKit` factory:

```js
export function makePromiseKit() {
  const { resolve, reject, executor } = makeReleasingExecutorKit();

  const promise = new BestPipelinablePromise(executor);

  return harden({ promise, resolve, reject });
}
harden(makePromiseKit);
```

§Three-step: get executor kit (cycle 173 §releasing-executor-
kit with §reference-release-on-settle) → wrap in best Promise
constructor → harden the resulting trio.

§Compare-to-cycle-183-init's §two-phase-init pre→commit. §This-
is §two-phase-build-the-promise: §allocate-the-executor (cycle
173) then §wrap-with-the-best-constructor (cycle 66's
HandledPromise if available).

## §`racePromises` — the leak-free public API

```js
export function racePromises(values) {
  return harden(
    memoRace.call(BestPipelinablePromise, values),
  );
}
harden(racePromises);
```

§The-named-export `racePromises` (not `Promise.race`) gives
callers an explicit way to use the leak-free race. §The-shim
replaces `Promise.race` unconditionally, but §callers-who-want-
to-be-explicit can import `racePromises` directly.

§The-comment-above explains a §rejected-alternative:

```
// NB: Another implementation for Promise.race would be to use
// the releasing executor.  However while it would no longer
// leak the raced promise objects themselves, it would still
// leak reactions on the non-resolved promises contending for
// the race.
```

§This-is-§considered-and-rejected-discipline (sibling to
cycle 186's §"illusion of an option" pattern). §The-§releasing-
executor-approach would have a §similar-but-distinct-leak
(reactions instead of promise objects).

§Cycle-156-finalize.js's §weak-value-map + cycle-173-promise-
executor-kit's §reference-release-on-settle + cycle-152-memo-
race's §memo-race are the §three-leak-prevention-disciplines
that converge on this design.

## §`isPromise` — the canonical detection

```js
import harden from '@endo/harden';

export function isPromise(maybePromise) {
  return Promise.resolve(maybePromise) === maybePromise;
}
harden(isPromise);
```

§Twelve-lines. §The-detection-rule: `Promise.resolve(x) === x`
returns true iff x is a §thenable-that-is-already-a-Promise.

§Why-not-`x instanceof Promise`: §realm-boundary-issue. A
Promise from another realm has a different `Promise.prototype`,
so `instanceof` returns false. §`Promise.resolve` is §realm-
agnostic — it returns its argument unchanged if it's already
a Promise from the same realm or a compatible thenable.

§Compare-to-cycle-152-pass-style/symbol.js' §Hilbert-Hotel-
encoding and cycle 87-ses-error/assert.js' §`assert`-as-realm-
agnostic-substrate. §All-three-are-§cross-realm-discipline
patterns.

## §The-postponedHandler (eventual-send/src/postponed.js)

```js
export const makePostponedHandler = HandledPromise => {
  let donePostponing;

  const interlockP = new Promise(resolve => {
    donePostponing = () => resolve(undefined);
  });

  const makePostponedOperation = postponedOperation => {
    return function postpone(x, ...args) {
      return new HandledPromise((resolve, reject) => {
        interlockP
          .then(_ => {
            resolve(HandledPromise[postponedOperation](x, ...args));
          })
          .catch(reject);
      });
    };
  };
  // ...
};
```

§The-postponedHandler-pattern: §six-handler-traps (get /
getSendOnly / applyFunction / applyFunctionSendOnly /
applyMethod / applyMethodSendOnly) all postpone via
`interlockP.then(...)`.

§The-interlockP-promise is resolved when `donePostponing()` is
called. §Until-then, every operation against the postponed
target waits in the `interlockP.then` chain.

§Why-this-matters: §async-bootstrap-discipline. When a guest
formula returns a promise to an object whose handler isn't
yet ready, the daemon installs a postponed handler so messages
queue rather than synchronously fail. §When-the-real-handler-
becomes-available, `donePostponing()` releases the queue.

§The-`@ts-expect-error 2454` on the `assert(donePostponing)`:

```js
// @ts-expect-error 2454
assert(donePostponing);
```

§TypeScript-can't-see that the Promise executor runs
synchronously, so it considers `donePostponing` possibly
undefined. §The-`@ts-expect-error` acknowledges that the
runtime invariant is correct even though the type system
can't see it.

§Compare-to-cycle-181-base64's `/** @type {any} */ (Uint8Array
.prototype).toBase64` cast for the §native-detection-pattern.
§Both-are-§ts-expect-error-where-runtime-knows-better.

## §The-three-purpose prepare-endo.js (ses-ava)

```js
/* global globalThis */

import '@endo/init/pre-remoting.js';
import '@endo/init/debug.js';
import { environmentOptionsListHas } from '@endo/env-options';

import rawTest from 'ava';
import { wrapTest } from './src/ses-ava-test.js';

const env = (globalThis.process || {}).env || {};
env.TRACK_TURNS = 'enabled';

if (!environmentOptionsListHas('DEBUG', 'track-turns')) {
  if ('DEBUG' in env) {
    env.DEBUG = `${env.DEBUG},track-turns`;
  } else {
    env.DEBUG = 'track-turns';
  }
}

const test = wrapTest(rawTest);

export { test as default };
```

§Twenty-seven-lines doing §three-things-at-once:

1. **§Install-HandledPromise-and-lockdown-with-debug-tamings**:
   `import '@endo/init/pre-remoting.js'` + `import '@endo/init/
   debug.js'` (the §tolerance-ladder rung from cycle 183).
2. **§Force-track-turns-debug-output**: sets
   `env.TRACK_TURNS='enabled'` + adds 'track-turns' to DEBUG
   list (cycle 90 track-turns.js's diagnostic mechanism).
3. **§Wrap-ava-test-with-ses-ava-test**: replaces `rawTest`
   with the SES-aware wrapper.

§The-default-export-is-the-wrapped-test. §A-consumer-imports:

```js
import test from '@endo/ses-ava/prepare-endo.js';
test('my SES-aware test', t => { ... });
```

§Side-effects + §functional-export-in-one-module. §Compare-to-
cycle-183-init's-§two-phase-init: prepare-endo.js is the
§canonical-AVA-integration-of-Endo.

## §`@endo/ses-ava/prepare-endo-config.js` — the default-export-masking trick

```js
// This module is a variation on "@ses-ava/prepare-endo.js" that
// is suitable for use in an AVA config's "require" array.
// AVA config modules are expected to either *not* export a `default`,
// or to export a test if they do.
// The default export of "@ses-ava/prepare-endo" is the `test` function, so
// this indirection exists solely to mask out the default export.
import './prepare-endo.js';
```

§Seven-lines-including-comment-block. §The-implementation-is-
one-line. §The-comment-block-is-the-value.

§Why-this-file-exists: AVA's config `require` array expects
modules that either §do-not-export-a-default or §export-a-test
as default. §`@endo/ses-ava/prepare-endo.js` exports `test` as
default. §If-AVA-config-required-prepare-endo-directly, the
default export would be interpreted as a test and ava would
try to run it.

§The-solution: §a-thin-re-import that §does-not-re-export-the-
default. §`import './prepare-endo.js'` runs the side effects
(lockdown + env setup + ava install) but exposes no exports.

§Compare-to-cycle-167-where/index.js' §named-TODO and cycle
183-init's §DEPRECATED-with-redirect-comment. §All-three-are-
§tiny-files-where-the-comment-is-the-real-content. §The-code-
is-just-the-implementation-of-what-the-comment-explains.

§Tier-1-borrowing: §indirection-as-default-export-masking
pattern. §If-a-module's-default-export-conflicts-with-a-
consumer's-expectation, write a one-line re-import that
strips the default.

## §The-`@ts-expect-error 2454` pattern (revisited)

```js
// @ts-expect-error 2454
assert(donePostponing);
```

§TypeScript-error-2454 is "Variable 'X' is used before being
assigned." §The-Promise-executor binds `donePostponing` at
new Promise time, before `assert(donePostponing)` runs at
line 43. §But-TypeScript-doesn't-know-the-executor-runs-
synchronously.

§The-`@ts-expect-error 2454` discipline:

- §Names-the-specific-error-code (2454) rather than a bare
  `@ts-ignore`.
- §`@ts-expect-error` (not `@ts-ignore`) — TypeScript reports
  if the error stops occurring (e.g., after a future TS
  version improves flow analysis).
- §The-comment-acknowledges-the-runtime-invariant rather than
  silently working around the type system.

§Compare-to-cycle-181-base64's `/** @type {any} */ (Uint8Array)
.fromBase64` and cycle 146-E.js' `@ts-expect-error` for
microsoft/TypeScript#50319. §All-three-are-§ts-expect-error-
with-named-issue-number. §The-pattern: §don't-suppress-the-
error-blindly; §name-what-it-is-and-why-it's-acceptable.

## §`utils.js` — the canonical thin barrel

```js
export { getMethodNames } from './src/local.js';
export { makeMessageBreakpointTester } from './src/message-breakpoints.js';
```

§Two-lines. §The-pattern: §re-export-two-named-utilities from
deeper modules so that consumers don't reach into `src/`.

§Compare-to-cycle-183-init/index.js (6 lines) + lockdown/
commit.js (3 lines) + cycle-181-base64/index.js (14 lines).
§All-are-§thin-barrels that present a §public-API-surface
distinct from the internal `src/` layout.

§Why-barrels: §callers-import-from-the-package-name (`@endo/
eventual-send/utils.js`), not from `src/local.js`. §The-
barrel-can-rearrange-internal-files without breaking callers.
§Hex-package-design-Decision-2 (cycle 180) named the §barrel-
pattern; here it appears as the implementation.

## §Cohesion notes

- §Two-shim-strategies-side-by-side: eventual-send conditional;
  promise-kit unconditional. §The-design-rule: §conditional-if-
  the-target-may-be-correct; §unconditional-if-the-target-is-
  known-broken.
- §BestPipelinablePromise = `globalThis.HandledPromise ||
  Promise` at module load. §Pick-the-better-Promise gives
  `makePromiseKit` automatic pipelining when HandledPromise is
  available, plain Promise behavior otherwise.
- §racePromises as §explicit-API-paired-with-Promise.race-
  replacement. §The-platform-builtin-is-replaced-for-callers-
  who-don't-know; §the-named-export-exists-for-callers-who-do.
- §`isPromise` via `Promise.resolve(x) === x` is §realm-
  agnostic. §Cross-realm-detection-discipline.
- §postponedHandler with §interlockP-as-shared-await-point.
  Six handler traps all postpone through the same promise.
- §`@ts-expect-error 2454` with §named-issue-number is the
  §don't-suppress-blindly discipline.
- §prepare-endo.js is the §canonical-AVA-integration-of-Endo:
  one-import side-effects + default-export-of-wrapped-test.
- §prepare-endo-config.js is the §default-export-masking-via-
  thin-re-import pattern. §Comment-block-is-the-value.
- §The-§twelfth-member-of-§small-files-with-large-knowledge-
  density family (cycles 165/167/169/171/173/175/177/179/181/
  183/185/187).

## §Tier-1 borrowing

- §two-shim-strategies-side-by-side (§conditional-if-target-
  may-be-correct vs §unconditional-if-target-is-known-broken)
- §BestPipelinablePromise dispatch (`globalThis.HandledPromise
  || Promise`)
- §realm-agnostic-Promise-detection-via-`Promise.resolve(x) === x`
- §racePromises as explicit-API-paired-with-builtin-replacement
- §considered-and-rejected discipline (the releasing-executor
  alternative would have a different leak)
- §postponedHandler with §interlockP-as-shared-await-point
  (six traps converge on one promise)
- §`@ts-expect-error N` with named issue number (don't suppress
  blindly; name the runtime invariant)
- §default-export-masking-via-thin-re-import (when a consumer
  can't tolerate the default export)
- §comment-block-is-the-value (a one-line file whose
  documentation explains the indirection)
- §three-purpose-prepare-module (one import that does lockdown
  + env + ava-wrap in 27 lines)
- §`/* global globalThis */` for pre-lockdown shim modules
- §canonical-thin-barrel as public-API-surface

## §Synthesis-target

The §slot-machine-library's shim pattern (if it has one) can
§borrow-the-two-shim-strategies discipline: §conditional-vs-
unconditional based on §is-the-target-correct. §The-§default-
export-masking pattern is borrowable wherever §a-consumer-
expects-a-module-with-no-default-export.

§The-§BestPipelinablePromise-dispatch is borrowable for any
§extension-point-binding where a globalThis-installed
implementation should preempt the platform default.
