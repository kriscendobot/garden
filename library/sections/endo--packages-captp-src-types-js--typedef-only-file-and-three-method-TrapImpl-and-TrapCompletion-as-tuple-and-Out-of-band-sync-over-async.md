---
title: "@endo/captp/src/types.js — typedef-only file + three-method TrapImpl + TrapCompletion as discriminator-payload tuple + out-of-band sync-over-async"
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
---

# @endo/captp/src/types.js — typedef-only file + three-method TrapImpl + TrapCompletion as discriminator-payload tuple + out-of-band sync-over-async

[`@endo/captp/src/types.js`](../sources/endo--packages-captp-src-types-js.md) is a §49-line-typedef-only-file that defines the Trap mechanism's TypeScript contract: `CapTPSlot` + `TrapImpl` + `TrapCompletion` + `TrapRequest` + `TrapGuest` + `TrapHost`. §Fifth-direct-ingest from `@endo/captp/src/` (after atomics + finalize + loopback + trap).

## §`export {};` — typedef-only file pattern

```js
export {};
```

§The-`export {};`-statement makes the file a module without exports. §The-file's-purpose-is-the-JSDoc-typedefs-not-the-runtime-exports. §When-a-file-contains-only-TypeScript-typedefs-via-JSDoc, §use-`export {};`-to-mark-it-as-a-module-not-a-script.

§First-explicit-observation in library of §`export {};`-typedef-only-file-pattern. §Sibling-pattern-to-cycle-239's-get-interface.js (which is also typedef-shaped but exports the constant `GET_INTERFACE_GUARD`) — §two-different-shapes-of-typedef-heavy-file: §with-named-constant-export (239) + §without-runtime-export (249).

§The-file-IS-the-protocol-contract-not-the-implementation. §Sibling-pattern-to-cycle-239's-protocol-artifact-shape — §two-cycles-with-protocol-artifact-as-named-file-shape. §Cycle-239-is-a-protocol-artifact-with-implementation-elsewhere-AND-a-constant-export; §cycle-249-is-pure-protocol-artifact-with-implementation-in-trap.js.

## §The three-method TrapImpl interface

```js
/**
 * @typedef {object} TrapImpl
 * @property {(target: any, args: Array<any>) => any} applyFunction
 * @property {(target: any, method: string | symbol | number, args: Array<any>) => any} applyMethod
 * @property {(target: any, prop: string | symbol | number) => any} get
 */
```

§Three-method-TrapImpl: §applyFunction + §applyMethod + §get. §Distinct-from-cycle-241's-six-method-handler-protocol: §cycle-241-includes-send-only-versions (getSendOnly + applyFunctionSendOnly + applyMethodSendOnly) + §cycle-249-has-only-the-synchronous-three; §the-send-only-variants-don't-make-sense-for-Trap-because-Trap-is-sync-by-construction.

§Two-different-handler-protocols-in-the-same-family: §full-async-six-method (cycle 241 postponed.js) + §sync-only-three-method (cycle 249 captp/types). §The-axis-difference: §async-allows-send-only + §sync-doesn't-allow-send-only.

§First-explicit-observation in library of §the-three-method-vs-six-method-handler-protocol-distinction as a named-design-axis (sync-allows-three + async-allows-six).

## §`applyMethod` is atomic lookup-of-method-and-apply

```js
/**
 * @property {(target: any, method: string | symbol | number, args: Array<any>) => any} applyMethod
 *   method invocation, which is an atomic lookup of method and apply
 */
```

§The-JSDoc-explicitly-names §applyMethod-as-an-atomic-lookup-of-method-and-apply. §The-distinction: §`obj.method()`-decomposes-into-get-then-apply + §`applyMethod(obj, 'method', args)`-is-one-atomic-operation-not-two.

§When-the-protocol-distinguishes-get-then-apply-from-applyMethod, §the-atomicity-IS-the-distinction. §The-get-then-apply-shape-exposes-the-method-as-a-detached-function (which can leak); §the-applyMethod-shape-never-exposes-the-method-as-a-separate-value. §Security-by-construction: §the-protocol's-atomic-applyMethod-prevents-method-detach-attacks.

§Sibling-to-cycle-146's-E-this-receiver-check (which defends against `const m = E(x).method` detach) — §two-different-shapes-of-defense-against-method-detach: §cycle-146-via-this-receiver-check + §cycle-249-via-atomic-applyMethod. §Two-cycles-with-explicit-defense-against-method-detach-as-named-discipline.

§First-explicit-observation in library of §applyMethod-as-atomic-lookup-of-method-and-apply as named-security-property.

## §TrapCompletion as discriminator-payload tuple

```js
/**
 * @typedef {[boolean, import('@endo/marshal').CapData<CapTPSlot>]} TrapCompletion
 *   The head of the pair is the `isRejected` value indicating whether the sync call was an exception,
 *   and tail of the pair is the serialized fulfillment value or rejection reason.
 *   (The fulfillment value is a non-thenable. The rejection reason is normally an error.)
 */
```

§Two-tuple-with-discriminator-and-payload: §`[isRejected, CapData]`. §The-`isRejected`-boolean-IS-the-discriminator + §the-`CapData`-IS-the-serialized-payload. §When-a-sync-result-can-be-either-fulfillment-or-rejection, §encode-it-as-a-discriminated-tuple-not-a-throwing-function-call.

§Why-not-just-throw: §the-discriminator-tuple-can-be-serialized-and-passed-through-an-out-of-band-channel + §throws-can't-cross-the-out-of-band-boundary. §When-the-channel-is-not-a-call-stack, §encode-rejections-as-discriminator-tuples-not-thrown-exceptions.

§Two-named-explicit-constraints: §the-fulfillment-value-is-a-non-thenable + §the-rejection-reason-is-normally-an-error. §The-non-thenable-constraint-IS-the-sync-guarantee — §a-thenable-fulfillment-would-imply-async-resolution-which-Trap-doesn't-support.

§First-explicit-observation in library of §discriminator-payload-tuple as named-sync-result-encoding. §Sibling-pattern-to-cycle-238's-controller-client-cap-split — §two-different-shapes-of-pair-encoding: §two-tuple-of-`[discriminator, payload]` (cycle 249) + §two-tuple-of-`[controller, client]` (cycle 238 mint). §The-pair-shape-IS-the-API + §each-pair-has-a-different-semantic.

## §The non-thenable constraint as explicit sync guarantee

§The-fulfillment-value-is-a-non-thenable. §When-a-sync-protocol-supports-fulfillment-values, §exclude-thenables-from-the-fulfillment-shape + §the-exclusion-IS-the-sync-guarantee.

§Why: §a-thenable-fulfillment-would-need-to-be-awaited + §Trap-is-sync + §so-the-fulfillment-must-be-immediately-usable. §The-protocol-makes-this-an-invariant-not-a-runtime-check + §the-typedef-encodes-the-invariant.

§First-explicit-observation in library of §the-non-thenable-constraint-as-explicit-sync-guarantee.

## §`TrapRequest` with four named fields

```js
/**
 * @typedef TrapRequest the argument to TrapGuest
 * @property {keyof TrapImpl} trapMethod
 * @property {CapTPSlot} slot
 * @property {Array<any>} trapArgs
 * @property {() => Required<Iterator<void, void, any>>} startTrap
 */
```

§Four-named-fields: §trapMethod + §slot + §trapArgs + §startTrap. §The-`startTrap`-field-is-a-callback-not-a-value: §the-TrapGuest-calls-startTrap-to-begin-the-out-of-band-process.

§`keyof TrapImpl`-as-trapMethod-type: §the-trapMethod-IS-a-key-of-the-TrapImpl-interface (i.e., one of 'applyFunction' | 'applyMethod' | 'get'); §the-`keyof`-utility-type-encodes-the-dependency-between-TrapRequest-and-TrapImpl. §When-a-protocol-field-must-be-one-of-an-interface's-keys, §use-`keyof InterfaceName`-not-a-string-union.

§Defense-by-construction-via-`keyof`: §adding-a-method-to-TrapImpl-automatically-extends-the-allowed-trapMethod-values + §removing-a-method-from-TrapImpl-causes-a-type-error-everywhere-trapMethod-is-used-with-the-removed-name. §First-explicit-observation in library of §`keyof InterfaceName`-as-defense-by-construction-against-string-union-drift.

## §`Required<Iterator<void, void, any>>` typed iterator usage

```js
{() => Required<Iterator<void, void, any>>}
```

§Iterator-with-three-type-params: §`<TYield, TReturn, TNext>`. §All-three-params-are-named:

- **`TYield = void`** — the iterator doesn't yield meaningful values.
- **`TReturn = void`** — the iterator's return value is void.
- **`TNext = any`** — the value passed to `.next()` is any.

§The-`void, void, any` shape encodes §the-iterator-as-a-pure-control-flow-coordination-mechanism-not-a-value-stream. §When-an-iterator-is-used-for-coordination-not-data, §all-three-type-parameters-are-named-explicitly + §`void`-for-yield-and-return-IS-the-no-value-encoding.

§The-`Required<>` wrapper forces every optional Iterator method to be present. §Sibling-pattern-to-cycle-241's-`Required<Handler<any>>` — §two-cycles-with-`Required<>`-wrapper-as-completeness-of-implementation discipline. §When-the-protocol-requires-the-full-Iterator-interface-not-just-the-mandatory-`next`-method, §use-`Required<Iterator<...>>`.

## §The TrapGuest / TrapHost callback pair

```js
/**
 * @callback TrapGuest Use out-of-band communications to synchronously return a TrapCompletion
 * @param {TrapRequest} req
 * @returns {TrapCompletion}
 */

/**
 * @callback TrapHost start the process of transferring the Trap request's results
 * @param {TrapCompletion} completion
 * @returns {AsyncIterator<void, void, any> | undefined}
 */
```

§Two-named-callbacks: §TrapGuest (sync return) + §TrapHost (async-iterator return). §The-asymmetry-encodes-the-sync-over-async-mechanism: §the-guest-blocks-waiting-for-the-sync-result + §the-host-streams-the-result-back-via-the-async-iterator + §the-out-of-band-channel-bridges-the-async-host-side-to-the-sync-guest-side.

§First-explicit-observation in library of §out-of-band-communications-as-named-sync-over-async-mechanism. §The-typedef-explicitly-says-`Use out-of-band communications`-IS-the-named-mechanism.

§Two-different-return-types-encode-the-asymmetry: §sync-return-from-TrapGuest + §async-iterator-return-from-TrapHost. §When-a-sync-result-must-be-delivered-from-an-async-source, §encode-the-async-side-as-an-AsyncIterator + §encode-the-sync-side-as-a-synchronous-callback + §the-out-of-band-channel-IS-the-bridge.

§Sibling-pattern-to-cycle-241's-postponed-handler-pattern — §two-different-shapes-of-deferred-resolution: §cycle-241-defers-async-until-a-callback (no-out-of-band) + §cycle-249-makes-an-async-target-look-sync-via-out-of-band (sync-over-async). §Two-cycles-with-deferred-or-sync-bridge-patterns.

## §`AsyncIterator<void, void, any> | undefined` — optional return

§The-`TrapHost`-can-return-an-AsyncIterator-or-undefined. §The-undefined-case-IS-the-no-iterator-needed-signal — §when-the-transfer-completes-synchronously-no-iterator-is-needed.

§Sibling-pattern-to-cycle-239's-`InterfaceGuard<...> | undefined` (the get-interface-guard meta-method can return undefined) — §two-cycles-with-explicit-undefined-as-no-value-or-no-feature signal. §When-a-protocol-method-can-return-no-value-meaningfully, §encode-the-no-value-case-as-`| undefined`-not-as-null-or-throw.

§Two-different-meanings-of-the-undefined-return: §cycle-239 undefined-means-no-interface-guard-is-defined + §cycle-249 undefined-means-no-iterator-needed-for-this-transfer. §Two-different-no-value-semantics-encoded-by-the-same-type.

## §The semicolon and the `CapTPSlot = string`

```js
/** @typedef {string} CapTPSlot */
```

§The-`CapTPSlot` type is just `string`. §Branded-string-IS-a-named-string-with-a-distinct-type-name. §When-a-string-has-a-domain-specific-meaning, §brand-it-as-a-named-typedef-not-just-use-`string`-directly.

§The-typedef-IS-the-documentation — §the-name-tells-the-reader-this-is-a-CapTP-slot-identifier-not-an-arbitrary-string. §When-a-protocol-uses-strings-for-multiple-purposes, §each-purpose-gets-its-own-branded-typedef-so-the-reader-doesn't-have-to-track-which-string-is-which.

§Sibling-pattern-to-cycle-237's-`@template T`-constraint — §two-cycles-with-named-type-aliases-for-domain-specific-string-meanings.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §`export {};`-typedef-only-file-pattern as named module-without-runtime-exports.
- §Three-method-TrapImpl distinct from six-method-handler-protocol (sync vs async axis).
- §`applyMethod`-as-atomic-lookup-of-method-and-apply — security-by-construction against method-detach.
- §TrapCompletion-as-discriminator-payload-tuple — encode-rejections-as-tuples-not-throws-when-crossing-out-of-band-boundaries.
- §The-non-thenable-constraint-as-explicit-sync-guarantee — typedef encodes the invariant.
- §`keyof InterfaceName`-as-defense-by-construction-against-string-union-drift.
- §Out-of-band-communications-as-named-sync-over-async-mechanism.
- §AsyncIterator-as-async-side-of-sync-over-async-bridge.

**Tier-2 (TypeScript discipline patterns):**

- §`Required<Iterator<void, void, any>>` — completeness-of-implementation + all-three-iterator-type-params-named.
- §Iterator-with-`void, void, any` as pure-control-flow-coordination encoding.
- §`AsyncIterator<...> | undefined`-as-optional-return-encoding.
- §Branded-string-typedef-for-domain-specific-meaning (CapTPSlot).

**Tier-3 (file-shape patterns):**

- §Forty-nine-lines-as-a-complete-protocol-contract-via-typedefs.
- §Five-named-typedefs in 49 lines (CapTPSlot + TrapImpl + TrapCompletion + TrapRequest + TrapGuest + TrapHost).

## §Synthesis target — slot machine library

For a slot machine library:

- §`export {};`-typedef-only-file-pattern for §game-protocol-contract-without-runtime-exports.
- §Three-method-game-action-protocol (action × send-mode is async; sync game actions have three methods).
- §atomic-applyAction-not-get-then-apply for §game-rule-cannot-detach-actions-from-their-target.
- §game-action-completion-tuple `[isRejected, gameData]` for §game-result-encoded-as-discriminator-payload.
- §the-non-thenable-constraint for §sync-game-action-fulfillment.
- §`keyof InterfaceName`-as-defense-by-construction for §game-action-name-must-be-key-of-game-action-impl.
- §out-of-band-communications for §sync-over-async-game-action-bridge.
- §AsyncIterator-as-async-side-of-sync-over-async-bridge for §game-engine-streaming-results-back-to-sync-callsite.
- §branded-string-typedef for §game-id-vs-player-id-vs-action-id-distinguished-by-name.

## §Library meta-counters

- §Library-reaches-755-sections at cycle 249 (chat-lane @endo/captp/src/types).
- §Eighty-third-consecutive designs-chat alternation cycle (cycles 166-249).
- §Fifth-direct-ingest from `@endo/captp/src/` (after atomics + finalize + loopback + trap + types).
- §Forty-first-member of §small-files-with-large-knowledge-density family.
- §Five-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249).
- §Two-cycles-with-protocol-artifact-as-named-file-shape (239 + 249) — §two-different-shapes: §with-named-constant-export (239) + §without-runtime-export (249).
- §Two-cycles-with-`Required<>`-wrapper-as-completeness-of-implementation discipline (241 + 249).
- §Two-cycles-with-explicit-undefined-as-no-value-or-no-feature signal (239 + 249).
- §Two-cycles-with-deferred-or-sync-bridge-patterns (241 postponed-handler + 249 sync-over-async).
- §Two-cycles-with-explicit-defense-against-method-detach-as-named-discipline (146 this-receiver-check + 249 atomic-applyMethod).
- §First-explicit-observation of §`export {};`-typedef-only-file-pattern.
- §First-explicit-observation of §applyMethod-as-atomic-lookup-of-method-and-apply as named-security-property.
- §First-explicit-observation of §discriminator-payload-tuple-as-named-sync-result-encoding.
- §First-explicit-observation of §the-non-thenable-constraint-as-explicit-sync-guarantee.
- §First-explicit-observation of §`keyof InterfaceName`-as-defense-by-construction.
- §First-explicit-observation of §out-of-band-communications-as-named-sync-over-async-mechanism.
- §First-explicit-observation of §the-three-method-vs-six-method-handler-protocol-distinction.

(Endo Project Contributors authored)
