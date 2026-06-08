---
title: "@endo/ses-ava — §registered-symbol-protocol + §feature-test-with-fallback + §virtualT-proxy + §logErrorFirst + §AVA-method-override-list + §pre-lockdown-freeze"
source-slug: endo--packages-ses-ava
section-id: registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava/src/{ses-ava-test.js, command.js, reexport-ava.js}
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
---

# @endo/ses-ava — wrap AVA `test` with SES-aware error logging

`@endo/ses-ava` wraps the AVA testing-library's `test` function so that test failures get §SES-aware-error-logging — §deep-stacks-of-prior-turns + §unredacted-stack-traces + §unredacted-error-messages. The load-bearing content is `src/ses-ava-test.js` (308 lines); there's also `src/command.js` (162 lines) as a multi-config CLI runner and `src/reexport-ava.js` (4 lines) as a passthrough.

## §The-load-bearing-purpose

From the README:

> SES-AVA wraps AVA `test` functions and initializes the SES-shim with options suitable for debugging tests. This includes logging errors to the console with
> - deep stacks of prior turns
> - unredacted stack traces
> - unredacted error messages

§Borrowable-pattern: §wrap-a-foreign-test-library-to-add-the-host's-debugging-capability. §The-AVA-test-library-doesn't-know-about-SES-errors; §this-package-bridges-the-two.

## §Registered-symbol-protocol-as-cross-module-coordination

```js
const MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA = Symbol.for(
  'MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA',
);

const optMakeCausalConsoleFromLoggerForSesAva =
  globalThis[MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA];
```

§Registered-symbol-on-globalThis as the cross-module coordination shape. The §protocol-is-named-explicitly-in-the-symbol-name (`_FOR_SES_AVA` suffix). §The-comment-is-honest-about-what-this-is:

> Thus, the SES console-shim.js makes `makeCausalConsoleFromLoggerForSesAva` available on `globalThis` which it *assumes* is the global of the start compartment and is therefore allowed to hold powers that should not be available in constructed compartments.

§Three-cycles-of-cross-module-coordination-protocols now in library:

| Cycle | Source | Mechanism |
| --- | --- | --- |
| 197 | @endo/panic | §registered-symbol-as-emulated-private-state |
| 217 | @endo/errors | §`__HIDE_`-prefix-protocol via name-prefix |
| 219 | @endo/ses-ava | §registered-symbol-on-globalThis as privileged-API |

§Three-different-shapes-for-cross-module-coordination. §The-pattern: §when-two-modules-must-coordinate-without-direct-import, §use-a-shared-string-or-symbol-as-the-protocol.

## §Privileged-global-on-start-compartment-only

§The-honest-comment names the security envelope:

> `makeCausalConsoleFromLoggerForSesAva` is privileged because it exposes unredacted error info onto the `Logger` provided by the caller. It should not be made available to non-privileged code.
>
> [...] it *assumes* is the global of the start compartment and is therefore allowed to hold powers that should not be available in constructed compartments.

§Borrowable-pattern: §privileged-API-on-globalThis-of-start-compartment-only + §rely-on-SES-Compartment-isolation-to-keep-it-out-of-guest-compartments. §The-start-compartment-is-the-only-place-with-this-capability; §guest-compartments-don't-see-it.

§Sibling-to:
- cycle 98 ses/error/assert.js: §loggedErrorHandler-as-narrow-gate-to-mutable-state.
- cycle 96 ses/error/console.js: §causal-console-renderer that this API exposes.
- cycle 217 @endo/errors: §two-channels-for-two-audiences (redacted-thrown + full-console).

§The-causal-console-substrate-is-fully-wired-now: cycle 90 (track-turns producer) + cycle 93 (V8 stack-attenuation) + cycle 96 (console renderer) + cycle 98 (loggedErrorHandler bridge) + cycle 100 (rejection tracking) + cycle 106 (top-level tameConsole integration) + cycle 217 (@endo/errors public API) + cycle 219 (@endo/ses-ava test-time consumer).

## §Experimental-API-flag-via-comment

```
Further, we consider this particular API choice to be experimental
and may change in the future. It is currently only intended for use by
`@endo/ses-ava`, with which it will be co-maintained.
```

§Borrowable-pattern: §experimental-API-flag-via-comment names §the-single-intended-consumer + §the-co-maintenance-relationship. §Two-packages-co-maintained — §the-API-may-change-but-only-in-coordination-with-the-consumer.

§Sibling to cycle 218 familiar-chat-weblet-hosting's §two-design-documents-with-asymmetric-implementation-progress; both encode §cross-document-coupling-with-explicit-naming.

## §Feature-test-with-tolerate-absence-as-fallback

```js
const makeVirtualExecutionContext = originalT => {
  if (optMakeCausalConsoleFromLoggerForSesAva === undefined) {
    // Must tolerate absence as a failure of the feature test. In this
    // case, we fallback to `originalT` itself.
    return originalT;
  }
  // ... wrap originalT in a virtualT with SES-aware logger
};
```

§Feature-test-at-use-time (not at module-load). §If-the-substrate-isn't-there, §fall-back-to-the-original-AVA-execution-context. §The-test-still-runs; §it-just-doesn't-get-SES-aware-error-logging.

§Borrowable-pattern: §graceful-degradation-when-the-host-doesn't-provide-the-substrate. §Sibling to cycle 217 @endo/errors' §honest-fallback-policy and cycle 215 @endo/hex's §native-error-rerun-polyfill-for-better-diagnostic (both pay a §degraded-but-still-functional cost when the substrate is absent).

## §virtualT-proxy via §defineProperty-with-getter-setter-delegation

The §virtualT-proxy mirrors `originalT` but replaces `log` and `console` with the SES-aware variants:

```js
const virtualT = {
  log: causalConsole.error,
  console: causalConsole,
};
// Mirror properties from originalT and its prototype onto virtualT
const originalProto = getPrototypeOf(originalT);
const descs = {
  ...getOwnPropertyDescriptors(originalProto),
  ...getOwnPropertyDescriptors(originalT),
};
for (const [name, desc] of entries(descs)) {
  if (!(name in virtualT)) {
    if ('get' in desc) {
      defineProperty(virtualT, name, {
        ...desc,
        get() { return originalT[name]; },
        set(newVal) { originalT[name] = newVal; },
      });
    } else if (typeof desc.value === 'function') {
      defineProperty(virtualT, name, {
        ...desc,
        value(...args) { return originalT[name](...args); },
      });
    } else {
      defineProperty(virtualT, name, desc);
    }
  }
}
```

§Three-kinds-of-property-handling:
1. §Accessor-property (has `get`): forward both getter (read) and setter (write) to originalT.
2. §Function-value-property: forward the call to originalT (preserves §`this`-binding-via-forward-call).
3. §Data-property: copy descriptor directly (data properties don't need forwarding).

§Borrowable-pattern: §proxy-via-defineProperty-not-via-Proxy when §the-shape-of-the-original-is-known + §the-substitution-is-only-on-named-properties. §Cheaper-than-a-real-Proxy; §preserves-the-shape-of-the-original-with-named-substitutions.

§Spread-prototype-descriptors-first-so-own-properties-override is the §getOwnPropertyDescriptors(originalProto) before getOwnPropertyDescriptors(originalT) sequence in the `descs` construction. §Borrowable-pattern: §the-order-of-spread-determines-precedence (`{...A, ...B}` means B wins on collision).

§Skip-if-already-defined (`if (!(name in virtualT))`) preserves the §replaced-log-and-console.

## §logErrorFirst — the §log-then-rethrow discipline

```js
const logErrorFirst = (func, virtualT, args, source) => {
  let result;
  try {
    result = apply(func, undefined, [virtualT, ...args]);
  } catch (err) {
    virtualT.log(`THROWN from ${source}:`, err);
    throw err;
  }
  if (isPromise(result)) {
    return result.then(
      v => v,
      reason => {
        virtualT.log(`REJECTED from ${source}:`, reason);
        return result;
      },
    );
  } else {
    return result;
  }
};
```

§Three-cases-of-test-outcome:
1. §Sync-throw: log to `virtualT.log` with `THROWN from <source>:` prefix, then re-throw.
2. §Promise-rejection: log to `virtualT.log` with `REJECTED from <source>:` prefix, then return the original promise (which AVA will see as rejected).
3. §Success (sync or async): silent return.

§Two-distinct-log-prefixes (`THROWN` vs `REJECTED`) to distinguish sync-throw from async-rejection. §Sibling to cycle 90 track-turns.js's §THROWN-vs-REJECTED log distinction — same two-prefix discipline at a different layer.

§The-promise-rejection-handler-returns-the-original-promise (`return result`), not the reason. AVA sees the rejection; ses-ava just got to log first. §Borrowable-pattern: §intercept-without-changing-the-outcome — §the-logger-is-a-side-effect, §not-a-transformation.

The JSDoc names the §observable-difference-from-direct-call:

> The delayed rejection of the returned promise is an observable difference from directly calling `func(...)` but will be equivalent enough for most testing purposes.

§Honest-disclosure-of-the-tiny-semantic-drift. §Borrowable-pattern: §name-the-observable-difference + §argue-it's-equivalent-enough-for-the-use-case.

## §AVA-method-override-list

```js
const overrideList = [
  'after',
  'afterEach',
  'before',
  'beforeEach',
  'failing',
  'serial',
  'only',
];
```

§Seven-named-AVA-chainable-method-names that need recursive wrapping. The §wrapTest recursively wraps each of these:

```js
const wrapTest = avaTest => {
  const sesAvaTest = augmentLogging(avaTest);
  for (const methodName of overrideList) {
    if (hasOwn(avaTest, methodName)) {
      defineProperty(sesAvaTest, methodName, {
        value: wrapTest(avaTest[methodName]),
        // ...
      });
    }
  }
  harden(sesAvaTest);
  return sesAvaTest;
};
```

§Recursive-wrapping-for-chainable-methods. §Each-chained-method (`test.only.failing("...", ...)`) also gets the SES-aware logging.

§Borrowable-pattern: §allow-list-for-recursive-wrapping — §enumerate-the-known-chainable-methods + §wrap-each-one-recursively. §If-AVA-adds-a-new-chainable-method, the allow-list must be updated; §this-is-honest-fragility — §the-cost-of-being-explicit-about-which-methods-need-wrapping.

§Sibling to:
- cycle 154 @endo/captp trap.js: §narrowed-API-for-narrower-semantics (five-surface E.js → two-surface Trap; not all methods are surfaced).
- cycle 146 E.js: §callable-with-methods discipline (E is both a function and an object via `harden(assign(fn, methods))`).
- cycle 132 local.js: §getMethodNames-prototype-walk with §stop-at-Object-prototype.

## §Pre-lockdown-freeze-as-replacement-for-harden

```js
// Successful instantiation of this module must be possible before `lockdown`
// allows `harden(wrapTest)` to function, but `freeze` is a suitable replacement
// because all objects reachable from the result are intrinsics hardened by
// lockdown.
freeze(wrapTest);
```

§The-package-must-load-before-SES-lockdown; §harden-isn't-functional-yet at instantiation; §freeze-is-a-substitute because §all-reachable-objects-are-intrinsics-already-hardened-by-lockdown.

§The-comment-makes-the-load-bearing-invariant-explicit: §why-freeze-is-OK-here — not just "we couldn't harden so we settled" but §a-correctness-argument-about-reachability.

§Borrowable-pattern: §when-instantiation-must-precede-lockdown, §use-`freeze`-with-an-explicit-correctness-argument. §The-correctness-argument-names-which-objects-are-reachable + §why-they-don't-need-additional-hardening (because they'll be hardened by lockdown when lockdown runs).

§Five-cycles-now-using-freeze-not-harden-with-named-correctness-argument:
| Cycle | Source | Reason |
| --- | --- | --- |
| 132 | local.js | eventual-send evaluates before SES lockdown completes |
| 146 | E.js | `freeze` but not `harden` the proxy target so it remains trapping (stabilize-discipline) |
| 154 | trap.js | same as E.js (verbatim-comment-shared-across-derived-files) |
| 199 | trampoline | classic-uncurry-this with pre-lockdown capture |
| 219 | ses-ava | instantiation must precede lockdown; reachable objects are intrinsics |

§Five-different-reasons-for-the-same-mechanism: the §freeze-not-harden-discipline is honored across the library, but the §why differs each time. §This-is-the-honest-shape-of-load-order-constraints — §the-name-of-the-discipline-is-shared, §the-specific-reason-is-source-dependent.

## §command.js (multi-config CLI runner)

162-line CLI wrapping `node:child_process.spawn` to launch AVA-via-spawn for each named configuration in `package.json` under `sesAvaConfigs`. §Two-named-pass-through-categories:
- `passThroughFlags`: boolean flags like `-v`, `--verbose`, `--timeout`.
- `passThroughArgOptions`: options with values like `-m <pattern>`, `--match <pattern>`.

§Two-named-filtering-flags: `--only <name>` (or `-o`) and `--exclude <name>` (or `-x`).

§Borrowable-pattern: §multi-config-CLI-as-a-package.json-driven-runner with §filter-by-name + §pass-through-known-flags + §default-run-everything.

## §reexport-ava.js (4 lines)

§Tiny-passthrough that re-exports AVA's `test` for §convenient-import-shape. §The-shape-of-the-package: §src/ses-ava-test.js does the wrapping; §src/reexport-ava.js is the bridge; §src/command.js is the runner. §Three-files-with-three-distinct-concerns.

## §README discipline: §devDependencies-not-dependencies

The README explicitly directs users to install `@endo/ses-ava` as a `devDependency`:

> @endo/ses-ava itself depends on AVA as a regular dependency, so it you include @endo/ses-ava as a regular dependency, bundlers might bundle your code with all of AVA.

§Borrowable-pattern: §when-a-test-library-has-AVA-as-a-regular-dependency, §the-consuming-application-must-treat-the-test-library-as-a-devDependency-to-avoid-bundle-bloat. §The-package-maintainer-cannot-control-the-consumer's-bundling-choice; §the-best-they-can-do-is-document-the-correct-discipline.

§Sibling to cycle 200 worker-rust-xs's §named-bundling-implication and cycle 218 familiar-chat-weblet-hosting's §`@host`-explicitly-labeled-development/trusted-only.

## §The-replace-line-discipline

The README's §usage-instruction:

```
Replace:
  import 'ses'; // or however you initialize the SES-shim
  import test from 'ava';

With:
  import test from '@endo/ses-ava/prepare-endo.js';
```

§A-single-import-replaces-two. §The-prepare-endo.js-module-initializes-the-SES-shim-with-debug-options + §wraps-and-exports-the-test-function. §One-line-of-user-code-changes; §the-library-does-the-rest.

§Borrowable-pattern: §single-import-replaces-multiple-imports + §the-library-handles-the-coordination-internally.

## Related material in the library

- **cycle 90 ses/error/track-turns.js**: §causal-console-annotation-producer; §THROWN-vs-REJECTED log distinction sibling.
- **cycle 93 ses/error/tame-v8-error-constructor.js**: §stack-trace-taming; §unredacted-stack-traces depend on this.
- **cycle 96 ses/error/console.js**: §causal-console-renderer; §the-API exposed via the registered-symbol-on-globalThis.
- **cycle 98 ses/error/assert.js**: §loggedErrorHandler-as-narrow-gate-to-mutable-state.
- **cycle 100 ses/error/unhandled-rejection.js**: §GC-driven-rejection-tracking sibling.
- **cycle 106 ses/error/tame-console.js**: §top-level-tameConsole-integration; this package is one of its downstream consumers.
- **cycle 197 @endo/panic**: §registered-symbol-as-cross-module-coordination sibling (first instance of the pattern).
- **cycle 215 @endo/hex**: §graceful-degradation-when-substrate-absent sibling; §pre-lockdown-capture sibling.
- **cycle 217 @endo/errors**: §`__HIDE_`-prefix-protocol sibling (second instance of cross-module-coordination); §two-channels-for-two-audiences exposed here at test time.
- **cycle 218 familiar-chat-weblet-hosting**: §experimental-API-flag-via-comment + §two-document-coordination siblings.
- **cycles 132 + 146 + 154 + 199**: §freeze-not-harden-with-named-correctness-argument family; cycle 219 is the fifth member.

## §Library-reaches-725-sections at cycle 219 (chat-lane @endo/ses-ava).

## §Three-different-shapes-for-cross-module-coordination-protocols family

| Cycle | Source | Mechanism |
| --- | --- | --- |
| 197 | @endo/panic | §registered-symbol-as-emulated-private-state |
| 217 | @endo/errors | §`__HIDE_`-prefix-protocol via name-prefix |
| 219 | @endo/ses-ava | §registered-symbol-on-globalThis as privileged-API |

§A-new-meta-cluster joins §three-different-ponyfill-shapes / §three-canonical-uncurry-shapes / §three-utility-cluster-shapes / §four-different-runtime-version-or-environment-compat-hacks.

## §Fifty-third consecutive designs-chat alternation cycles 166-219.
