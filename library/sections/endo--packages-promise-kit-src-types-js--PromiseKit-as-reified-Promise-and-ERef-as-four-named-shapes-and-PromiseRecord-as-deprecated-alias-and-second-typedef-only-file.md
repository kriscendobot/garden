---
title: "@endo/promise-kit/src/types.js — PromiseKit as reified Promise + ERef as four named shapes + PromiseRecord as deprecated alias + second typedef-only file"
source-slug: endo--packages-promise-kit-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/types.js
total-lines: 25
ingest-cycle: 256
ingest-date: 2026-06-10
lane: chat
---

# PromiseKit as reified Promise + ERef as four named shapes + PromiseRecord as deprecated alias + second typedef-only file

[`@endo/promise-kit/src/types.js`](../sources/endo--packages-promise-kit-src-types-js.md) is a §25-line-typedef-only-file containing three named typedefs: `PromiseKit<T>` (a reified Promise), `PromiseRecord<T>` (deprecated alias for `PromiseKit<T>`), and `ERef<T>` (a reference of some kind for an object of type T). The file ends with `export {};` to mark it as a module.

## §`export {};` — second typedef-only file

```js
export {};
```

§The-second-typedef-only-file ingested in library (first was cycle 249's `@endo/captp/src/types.js`). §Two-cycles-with-`export {};`-typedef-only-file-pattern (249 + 256). §The-file-IS-the-protocol-contract-not-the-implementation — both files isolate their type vocabulary in a runtime-no-op module.

§Sibling-pattern-to-cycle-249's-captp-types-js — §two-different-domains-with-the-same-shape: §cycle-249-captp-typedef-only-file + §cycle-256-promise-kit-typedef-only-file. §When-a-package-needs-a-protocol-contract-but-no-runtime-code, §the-`export {};`-typedef-only-file-IS-the-correct-shape.

§Four-direct-ingests from `@endo/promise-kit/src/` now (memo-race-js + promise-executor-kit-js + is-promise.js cycle 252 + types.js cycle 256).

## §`PromiseKit<T>` — a reified Promise

```js
/**
 * @template T
 * @typedef {object} PromiseKit A reified Promise
 * @property {(value: ERef<T>) => void} resolve
 * @property {(reason: any) => void} reject
 * @property {Promise<T>} promise
 */
```

§A-Promise's-three-roles-(resolver + rejecter + the-future-value)-are-hidden-inside-the-Promise-constructor's-executor-callback. §A-PromiseKit-IS-the-Promise-with-those-three-roles-exposed-as-explicit-object-properties.

§Reified-Promise-as-named-pattern: §reify-means-to-make-the-implicit-explicit + §the-Promise-constructor's-executor-callback-IS-implicit-state + §the-PromiseKit-object-IS-the-explicit-projection. §First-explicit-observation in library of §PromiseKit-as-reified-Promise as named architectural pattern.

§Sibling-pattern-to-cycle-241's-postponed.js — §the-resolve-callback-is-captured-via-closure-in-Promise-executor (cycle 241's mechanism for one specific case) + §the-PromiseKit-IS-the-systematic-generalization-of-that-pattern (the entire triple is exposed, not just resolve). §When-the-resolve-and-reject-must-be-called-from-outside-the-Promise-constructor-executor, §use-the-PromiseKit + §don't-reach-into-the-Promise-via-closure-tricks.

§The-three-properties (resolve + reject + promise) are §the-canonical-three-roles-of-Promise-resolution. §Sibling-pattern-to-cycle-249's-`TrapCompletion`-as-discriminator-payload-tuple — §two-different-shapes-of-Promise-result-encoding: §cycle-249-tuple-for-sync-result + §cycle-256-record-for-async-resolver-triple.

## §`resolve: (value: ERef<T>) => void` — resolver accepts any ERef

§The-resolver-takes-`ERef<T>`-not-`T`. §This-IS-load-bearing: §a-PromiseKit's-resolve-can-be-called-with-a-bare-T + §or-with-a-Promise-of-T + §or-with-a-PromiseLike-of-T (thenable). §The-Promise-resolution-protocol-folds-any-of-these-shapes-into-the-final-resolved-value.

§First-explicit-observation in library of §resolve-takes-ERef-not-T-as-the-canonical-PromiseKit-resolver-shape. §When-a-resolver-must-accept-any-of-the-Promise-shapes, §the-resolver's-parameter-type-IS-ERef<T>-not-T.

§Sibling-pattern-to-cycle-252's-isPromise — §two-cycles-with-explicit-distinction-between-T-and-Promise-of-T-and-thenable-of-T. §Cycle-252's-isPromise-detects-genuine-Promise-vs-thenable; §cycle-256's-ERef-accepts-all-three-shapes-as-input-to-the-resolver.

## §`ERef<T> = T | PromiseLike<T>` — four named shapes

```js
/**
 * @template T
 * @typedef {T | PromiseLike<T>} ERef
 * A reference of some kind for to an object of type T. It may be a direct
 * reference to a local T. It may be a local presence for a remote T. It may
 * be a promise for a local or remote T. Or it may even be a thenable
 * (a promise-like non-promise with a "then" method) for a T.
 */
```

§The-`ERef<T>`-typedef-is-`T | PromiseLike<T>`-at-the-TypeScript-level + §but-the-JSDoc-prose-names-four-distinct-shapes-the-type-accepts:

1. §A-direct-reference-to-a-local-T (`T` itself).
2. §A-local-presence-for-a-remote-T (the Far-ref or remote-presence shape).
3. §A-promise-for-a-local-or-remote-T (`Promise<T>` proper).
4. §A-thenable — *a promise-like non-promise with a "then" method* — for a T (`PromiseLike<T>` that isn't a Promise).

§Four-named-shapes-distinguished-in-prose-not-in-type-narrower-than-T | PromiseLike<T>. §The-TypeScript-type-collapses-the-distinction-but-the-JSDoc-preserves-it-in-prose.

§First-explicit-observation in library of §four-named-shapes-of-ERef as named reference-vocabulary.

§Sibling-pattern-to-cycle-252's-thenable-vs-genuine-Promise distinction — §cycle-252-distinguishes-thenable-vs-genuine-Promise + §cycle-256-distinguishes-local-T-vs-remote-presence-vs-genuine-Promise-vs-thenable. §The-distinction-IS-load-bearing-in-capability-systems-because-each-shape-has-different-trust-and-locality-properties.

§The-`promise-like non-promise with a "then" method` paraphrase IS the most precise definition of a thenable. §When-a-type-includes-thenables, §the-prose-must-define-thenable-explicitly + §don't-assume-the-reader-knows.

## §`PromiseRecord<T>` — deprecated alias

```js
/**
 * PromiseRecord is deprecated in favor of PromiseKit.
 *
 * @template T
 * @typedef {PromiseKit<T>} PromiseRecord
 */
```

§The-deprecated-alias-is-still-exported — §it-aliases-the-new-name + §the-JSDoc-explicitly-says-`is deprecated in favor of PromiseKit`. §When-a-type-is-renamed-but-the-old-name-must-keep-working, §define-the-old-name-as-an-alias-of-the-new-name + §the-JSDoc-IS-the-deprecation-record.

§Sibling-pattern-to-cycle-251's-MCP-Tasks-graduates-to-an-extension and cycle-251's-three-core-features-deprecated — §two-cycles-with-named-deprecation-with-named-replacement (251 MCP Roots/Sampling/Logging + 256 PromiseRecord). §Cycle-251-deprecation-is-protocol-level; §cycle-256-deprecation-is-type-name-level.

§First-explicit-observation in library of §deprecated-typedef-alias-with-named-replacement-in-JSDoc as named rename-discipline.

§The-alias-is-a-pure-type-alias (`typedef {PromiseKit<T>} PromiseRecord`) — §no-runtime-cost + §the-alias-is-erased-at-build-time + §the-deprecation-IS-the-only-evidence-of-the-rename-at-runtime.

## §`@template T` parameterization on all three typedefs

§All-three-typedefs-are-parameterized-by-T. §The-parameterization-IS-the-shared-axis: §the-PromiseKit-resolves-to-T + §the-PromiseRecord-aliases-PromiseKit-of-T + §the-ERef-accepts-any-shape-of-T.

§Sibling-pattern-to-cycle-237's-`@template T`-constraint + cycle-249's-`@template {Record<RemotableMethodName, CallableFunction>} M` — §three-cycles-with-`@template`-parameterization (237 + 249 + 256). §Different-shapes-of-template-use: §cycle-237 unconstrained-T + §cycle-249 T-with-Record-constraint + §cycle-256 unconstrained-T-across-three-related-typedefs.

## §"a promise-like non-promise with a 'then' method" — named thenable definition

§The-ERef-typedef's-prose explicitly defines a thenable as *a promise-like non-promise with a "then" method*. §The-definition-IS-the-distinguishing-property: §thenable-has-`.then` + §thenable-is-not-a-Promise. §First-explicit-observation in library of §thenable-defined-explicitly-as-promise-like-non-promise-with-then-method.

§Sibling-pattern-to-cycle-252's-isPromise — §two-cycles-with-explicit-treatment-of-the-thenable-vs-Promise-distinction. §Cycle-252 detects the difference; §cycle-256 defines the difference in the type prose.

§Two-cycles-with-named-defense-and-named-definition-of-thenable-vs-Promise (252 detection + 256 definition).

## §The file's three named typedefs form a stack

§Stack-of-named-typedefs: §`ERef<T>` is the input-shape-vocabulary + §`PromiseKit<T>` consumes ERef-resolved-to-T in its resolver + §`PromiseRecord<T>` is the deprecated-alias of PromiseKit. §The-three-typedefs-form-a-stack: §the-bottom-(ERef)-IS-the-most-general + §the-middle-(PromiseKit)-IS-the-canonical + §the-top-(PromiseRecord)-IS-the-deprecated-rename.

§First-explicit-observation in library of §stack-of-three-typedefs-in-one-file (general-input + canonical + deprecated-alias).

§Sibling-pattern-to-cycle-249's-five-named-typedefs-in-49-lines — §two-cycles-with-multiple-typedefs-in-one-file: §cycle-249 has-the-Trap-protocol's-six-typedefs + §cycle-256 has-the-Promise-kit's-three-typedefs. §Both-files-isolate-a-protocol-vocabulary in a typedef-only module.

## §Twenty-five lines as a complete Promise-and-ERef type vocabulary

§Twenty-five-lines + §three-typedefs + §one-runtime-export-marker (`export {};`). §The-file-IS-the-public-type-vocabulary for the package's Promise-related shapes.

§Forty-fourth-member of §small-files-with-large-knowledge-density family. §Seven-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252 + 256).

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §`export {};` typedef-only file pattern (second instance: 249 + 256).
- §PromiseKit as reified Promise — three properties (resolve + reject + promise) make the Promise constructor's implicit state explicit.
- §resolve takes ERef not T — the resolver accepts any of the four ERef shapes; the Promise resolution protocol folds them.
- §ERef as four named shapes — local T + local presence for remote T + promise for T + thenable for T.
- §Four-named-shapes distinguished in prose, not in type narrower than `T | PromiseLike<T>`.
- §Thenable defined explicitly as *promise-like non-promise with a "then" method*.
- §Deprecated typedef alias with named replacement in JSDoc — pure type-erased rename discipline.
- §Stack of three typedefs in one file — general-input + canonical + deprecated-alias.

**Tier-2 (file-shape patterns):**

- §Twenty-five-lines-as-a-complete-Promise-and-ERef-type-vocabulary.
- §`@template T` parameterization on all three typedefs.
- §Three-typedefs-share-a-template-parameter.
- §The-file-IS-the-protocol-contract-not-the-implementation.

**Tier-3 (named comparisons):**

- §Two-cycles-with-`export {};`-typedef-only-file-pattern (249 + 256).
- §Two-cycles-with-explicit-treatment-of-the-thenable-vs-Promise-distinction (252 detection + 256 definition).
- §Two-cycles-with-named-defense-and-named-definition-of-thenable-vs-Promise (252 + 256).
- §Two-cycles-with-multiple-typedefs-in-one-file (249 + 256).
- §Two-cycles-with-named-deprecation-with-named-replacement (251 MCP + 256 PromiseRecord).
- §Three-cycles-with-`@template`-parameterization (237 + 249 + 256).

## §Synthesis target — slot machine library

For a slot machine library:

- §`export {};` typedef-only file for §game-state-type-vocabulary.
- §reified-game-state — three properties (commit + abort + future) make the game state's implicit transition explicit.
- §game-action-target-takes-ERef-not-T — the game-action's resolver accepts any game-token shape.
- §four-named-shapes-of-game-token-reference (local + remote-presence + promise + thenable) with prose distinction.
- §deprecated-game-rule-alias-with-named-replacement-in-JSDoc.
- §stack-of-three-typedefs-in-one-file for §game-rule-input-canonical-and-deprecated.
- §thenable-defined-explicitly for §game-token-promise-like-but-not-a-real-game-token.

## §Library meta-counters

- §Library-reaches-762-sections at cycle 256 (chat-lane @endo/promise-kit/src/types).
- §Eighty-ninth-consecutive designs-chat alternation cycle (cycles 166-250 + 252-256; cycle 251 was out-of-band papers).
- §Fourth-direct-ingest from `@endo/promise-kit/src/` (memo-race + promise-executor-kit + is-promise + types).
- §Forty-fourth-member of §small-files-with-large-knowledge-density family.
- §Seven-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252 + 256).
- §Two-cycles-with-`export {};`-typedef-only-file-pattern (249 + 256).
- §Two-cycles-with-explicit-treatment-of-the-thenable-vs-Promise-distinction (252 detection + 256 definition).
- §Two-cycles-with-named-defense-and-named-definition-of-thenable-vs-Promise (252 + 256).
- §Two-cycles-with-multiple-typedefs-in-one-file (249 + 256).
- §Two-cycles-with-named-deprecation-with-named-replacement (251 MCP Roots/Sampling/Logging + 256 PromiseRecord).
- §Three-cycles-with-`@template`-parameterization (237 + 249 + 256).
- §First-explicit-observation of seven patterns: §PromiseKit-as-reified-Promise + §resolve-takes-ERef-not-T-as-canonical-PromiseKit-resolver-shape + §four-named-shapes-of-ERef + §thenable-defined-explicitly-as-promise-like-non-promise-with-then-method + §deprecated-typedef-alias-with-named-replacement-in-JSDoc + §stack-of-three-typedefs-in-one-file + §four-named-shapes-distinguished-in-prose-not-in-narrower-type.

(Endo Project Contributors authored)
