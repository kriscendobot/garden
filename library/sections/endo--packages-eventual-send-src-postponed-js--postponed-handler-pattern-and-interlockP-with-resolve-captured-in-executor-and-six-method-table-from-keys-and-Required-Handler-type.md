---
title: "@endo/eventual-send/src/postponed.js — Postponed handler pattern + interlockP with resolve captured in executor + six-method table from keys + Required<Handler> type"
source-slug: endo--packages-eventual-send-src-postponed-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/postponed.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/postponed.js
total-lines: 46
ingest-cycle: 241
ingest-date: 2026-06-08
lane: chat
---

# Postponed handler pattern + interlockP with resolve captured in executor + six-method table from keys + Required<Handler> type

[`@endo/eventual-send/src/postponed.js`](../sources/endo--packages-eventual-send-src-postponed-js.md) is a §46-line-file that implements a §postponed-handler — a HandledPromise handler that defers every operation until a `donePostponing()` callback is invoked. The function returns a §two-tuple of `[postponedHandler, donePostponing]`. §Sixth-direct-ingest from `@endo/eventual-send/src/` (after E.js + handled-promise.js + local.js + message-breakpoints.js + track-turns.js).

## §The postponed-handler pattern

§The-postponed-handler-IS-the-not-yet-ready-state-of-a-future-handler. §When-a-HandledPromise-is-constructed-but-its-handler-is-not-yet-known, §the-postponed-handler-stands-in-and-defers-every-operation-until-the-handler-resolves. §The-`donePostponing()`-callback-signals-that-the-real-handler-is-now-available + §forwards-all-postponed-operations.

§Sibling-pattern-to-cycle-238's-pet-name-handle-that-survives-across-CLI-invocations — both designs name §the-stable-handle-on-something-whose-shape-isn't-yet-fully-determined. §Two-different-shapes-of-deferred-resolution-in-library: §cycle-238 (controller's pet name binds before policy is finalized) + §cycle-241 (handler's identity binds before backing handler is determined).

## §interlockP with resolve captured in executor

```js
let donePostponing;

const interlockP = new Promise(resolve => {
  donePostponing = () => resolve(undefined);
});
```

§The-resolve-callback-is-captured-via-closure-in-Promise-executor. §The-Promise-constructor-runs-its-executor-synchronously, so `donePostponing` is assigned before `new Promise(...)` returns. §Closure-captures-on-Promise-executor-synchronous-assignment — §a-standard-pattern-for-exposing-the-resolve-and-reject-callbacks-outside-the-Promise.

§The-interlockP-name — *interlock* names the synchronization point: nothing past the interlock fires until the lock is released by `donePostponing()`. §When-a-value-is-pending-and-a-callback-must-trigger-its-resolution, §name-the-pending-promise-after-the-synchronization-shape-not-after-the-value-it-carries (the value is just `undefined`; the *interlock* is the meaning).

§`assert(donePostponing)`-with-`@ts-expect-error 2454`: the assertion is for TypeScript's benefit (TS error 2454 is "Variable used before being assigned"). §The-`@ts-expect-error`-cites-the-specific-error-code. §The-`@ts-expect-error`-IS-the-acknowledgment-that-TS-can't-see-the-Promise-executor's-synchronous-run + §the-runtime-assert-IS-the-belt-and-suspenders-check. §Sibling-pattern-to-cycle-146's `@ts-expect-error` for `microsoft/TypeScript#50319` (cycle 146 cited a TypeScript GitHub issue; cycle 241 cites a TypeScript error code number); §two-cycles-with-`@ts-expect-error`-citing-a-specific-TS-issue-or-error-code (cycles 146 + 241).

## §Six-method table from keys

```js
const postponedHandler = {
  get: makePostponedOperation('get'),
  getSendOnly: makePostponedOperation('getSendOnly'),
  applyFunction: makePostponedOperation('applyFunction'),
  applyFunctionSendOnly: makePostponedOperation('applyFunctionSendOnly'),
  applyMethod: makePostponedOperation('applyMethod'),
  applyMethodSendOnly: makePostponedOperation('applyMethodSendOnly'),
};
```

§The-six-method-handler-protocol enumerated in order:

1. **get** — read a property on the target.
2. **getSendOnly** — read a property with no return value (fire-and-forget).
3. **applyFunction** — call the target as a function with args.
4. **applyFunctionSendOnly** — same, fire-and-forget.
5. **applyMethod** — call a method on the target with method name + args.
6. **applyMethodSendOnly** — same, fire-and-forget.

§The-protocol's-six-methods-form-a-2x3-axis-table: §three-operations (get + applyFunction + applyMethod) × §two-send-modes (regular + send-only). §The-handler-protocol-IS-the-call-shape × §the-send-mode. §When-a-handler-protocol-has-orthogonal-axes, §enumerate-them-in-table-order-not-grouped-by-shape (the file lists them in `get` / `getSendOnly` pairs, then `applyFunction` / `applyFunctionSendOnly` pairs — the **axis pair** is the inner loop).

§postponedOperation-as-method-name-string-used-as-key-on-HandledPromise — §the-operation-name-is-both-the-method-on-postponedHandler-AND-the-method-on-HandledPromise. §When-the-handler-method-and-the-HandledPromise-method-have-the-same-name, §the-string-IS-the-uniform-protocol-key. §Sibling-pattern-to-cycle-239's-named-protocol-constant — both designs use a §single-string-as-the-protocol-key.

§makePostponedOperation-as-method-factory:

```js
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
```

§Each-handler-method-is-generated-from-a-single-shape-with-the-operation-name. §DRY-via-method-factory — the six methods on `postponedHandler` differ only in the string passed to `makePostponedOperation`. §When-N-methods-differ-only-in-the-string-name-of-the-operation-they-defer, §the-factory-takes-the-string-and-returns-the-deferring-function.

§The-returned-function-has-a-debug-name (`postpone`) — §when-a-factory-returns-an-anonymous-function-that-will-appear-in-stack-traces, §give-it-a-debug-name-via-`function`-keyword-syntax-not-arrow. §Sibling-pattern-to-cycle-129's `function method()` body inside a computed-property-key trick (cycle 129 used `{ [propertyKey](...) {} }[propertyKey]` to preserve the name; cycle 241 uses the `function postpone(...)` syntax directly).

## §`new HandledPromise((resolve, reject) =>`-as-defer-mechanism

```js
return new HandledPromise((resolve, reject) => {
  interlockP
    .then(_ => {
      resolve(HandledPromise[postponedOperation](x, ...args));
    })
    .catch(reject);
});
```

§The-deferred-call-is-a-new-HandledPromise-whose-resolution-is-the-real-operation's-result. §When-the-interlock-resolves, §the-real-operation-fires + §its-result-resolves-the-outer-HandledPromise. §The-`.catch(reject)` propagates failure — §if-the-real-operation-throws-or-rejects, §the-outer-HandledPromise-rejects-with-the-same-reason.

§`.then(_ =>`-ignored-resolve-value-with-underscore-prefix — §the-interlockP-resolves-with-undefined-and-the-resolve-value-isn't-used + §the-`_`-name-signals-deliberate-ignoring. §When-a-promise's-resolve-value-is-not-load-bearing, §name-the-parameter-`_`-to-document-the-ignoring.

## §Required<Handler<any>>-return-type

§The-typedef-`[Required<Handler<any>>, () => void]` — §the-tuple-type-encodes-the-two-tuple-shape; §the-`Required<>`-wrapper-forces-every-optional-field-of-Handler-to-be-present-in-the-postponed-handler. §When-a-handler-protocol-has-optional-methods-but-a-particular-implementation-must-supply-all-of-them, §use-`Required<>`-to-encode-that-completeness-requirement-at-the-type-level. §Defense-by-construction-via-`Required<>`-wrapper — §the-TypeScript-checker-flags-a-missing-method + §the-implementation-cannot-silently-omit-a-method-the-protocol-allows-to-be-optional-elsewhere.

§The-`<any>`-parameter — §the-postponed-handler-doesn't-know-the-shape-of-the-target + §`any`-is-the-honest-type-when-the-target-is-genuinely-unknown.

## §The commented-out console.log as named debugging affordance

```js
// console.log(`forwarding ${postponedOperation} ${args[0]}`);
```

§The-commented-out-console.log-left-in-the-source — §a-debugging-affordance-that-can-be-uncommented-to-trace-postponement. §When-a-file-is-load-bearing-for-debugging-async-flows, §leave-the-trace-statement-commented-out-not-deleted + §the-comment-IS-the-debugging-affordance + §the-next-debugger-doesn't-have-to-reconstruct-the-trace-statement.

§Sibling-to-cycle-237's-`Beware`-prefix-marks-actionable-warning-not-passive-note — §two-different-comment-shapes-with-named-roles: §`Beware`-prefix-marks-actionable-warning (cycle 237) + §commented-out-console.log-as-debugging-affordance (cycle 241).

## §Forty-six-lines as a complete handler-protocol-postponement

§Forty-six-lines-implements-deferred-handler-resolution + §exposes-it-as-a-two-tuple-from-a-single-factory-function. §The-implementation-is-self-contained — §no-extra-state-beyond-the-interlockP-promise + §no-extra-classes-or-exo-machinery. §When-a-protocol-feature-can-be-implemented-as-a-thin-wrapper-around-a-Promise, §implement-it-thin + §don't-build-class-machinery-for-it.

§Twenty-third-cycle-with-`Just-wait-until-the-handler-is-resolved`-as-named-design-shape-or-similar-deferred-handler-pattern: this is the §first-explicit-ingest of the postponed-handler shape itself.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §The-postponed-handler-pattern — a handler that defers every operation until a callback signals readiness.
- §The-interlockP — name a pending promise after the synchronization shape, not after the value it carries.
- §The-resolve-callback-is-captured-via-closure-in-Promise-executor — `let cb; new Promise(r => { cb = r; })` exposes resolve outside.
- §`assert(callback)`-with-`@ts-expect-error 2454` — runtime check + TypeScript-error suppression to acknowledge the executor's synchronous run.
- §Six-method handler protocol as 2×3 axis table (three operations × two send-modes).
- §postponedOperation-as-method-name-string-used-as-key-on-HandledPromise — uniform protocol key.
- §makePostponedOperation-as-method-factory — DRY for the protocol's repeated shape.
- §The-returned-function-has-a-debug-name (`function postpone(...)`).
- §`.then(_ =>`-ignored-resolve-value-with-underscore-prefix.
- §The-commented-out-console.log-left-in-the-source as named debugging affordance.

**Tier-2 (TypeScript shape patterns):**

- §`Required<Handler<any>>` to encode completeness-of-implementation at the type level.
- §The-`<any>`-parameter as the honest type when the target is genuinely unknown.
- §Defense-by-construction-via-`Required<>`-wrapper.
- §The-tuple-type-encodes-the-two-tuple-shape (`[handler, callback]`).

**Tier-3 (small-file patterns):**

- §Forty-six-lines-as-a-complete-handler-protocol-postponement — thin wrapper around a Promise, no class machinery.

## §Synthesis target — slot machine library

For a slot machine library:

- §game-postponed-handler for §game-state-deferred-resolution before §the-real-game-rule-is-resolved.
- §game-interlockP for §game-action-waits-until-game-engine-ready-callback.
- §the-resolve-callback-is-captured-via-closure for §game-engine-startup-callback exposed outside Promise constructor.
- §`assert(donePostponing)`-with-`@ts-expect-error 2454` for §game-engine-startup-callback-defense-in-depth.
- §game-handler-protocol-as-axis-table (action × mode) for §game-action-protocol-shape.
- §makePostponedOperation-as-method-factory for §game-action-factory-by-name.
- §the-returned-function-has-a-debug-name for §game-action-stack-trace-readability.
- §`Required<Handler<any>>` for §game-engine-implementations-must-supply-all-actions.
- §forty-six-lines-as-a-complete-handler-protocol-postponement for §game-deferred-action-thin-wrapper-no-class-machinery.

## §Library meta-counters

- §Library-reaches-747-sections at cycle 241 (chat-lane @endo/eventual-send/src/postponed-js).
- §Seventy-fifth consecutive designs-chat alternation cycle (cycles 166-241).
- §Sixth-direct-ingest from `@endo/eventual-send/src/` (after E.js + handled-promise.js + local.js + message-breakpoints.js + track-turns.js + postponed.js).
- §Thirty-eighth-member of §small-files-with-large-knowledge-density family.
- §Two-cycles-with-`@ts-expect-error`-citing-a-specific-TS-issue-or-error-code (cycles 146 + 241).
- §Two-different-comment-shapes-with-named-roles (cycle 237 `Beware`-prefix + cycle 241 commented-out-console.log-as-debugging-affordance).
- §Two-different-shapes-of-deferred-resolution (cycle 238 controller-pet-name-handle + cycle 241 postponed-handler).
- §Sibling-pattern-to-cycle-239's-named-protocol-constant — §two-uses-of-string-as-protocol-key (cycle 239 GET_INTERFACE_GUARD + cycle 241 postponedOperation).
- §First-explicit-observation of §postponed-handler-pattern as borrowable pattern in library.
- §First-explicit-observation of §interlockP-name as named-synchronization-shape.
- §First-explicit-observation of §`Required<>`-wrapper as completeness-of-implementation type discipline.
- §First-explicit-observation of §commented-out-console.log-as-debugging-affordance.

(Endo Project Contributors authored)
