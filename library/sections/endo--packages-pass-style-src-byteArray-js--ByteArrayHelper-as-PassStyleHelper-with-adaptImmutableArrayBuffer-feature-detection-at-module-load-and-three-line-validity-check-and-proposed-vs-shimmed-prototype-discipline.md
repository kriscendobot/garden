---
title: "@endo/pass-style/src/byteArray.js — ByteArrayHelper as PassStyleHelper with adaptImmutableArrayBuffer feature-detection at module load and three-line validity check and proposed-vs-shimmed prototype discipline"
source-slug: endo--packages-pass-style-src-byteArray-js
section-slug: ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/byteArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/byteArray.js
source-author: Endo project (collective)
total-lines: 68
ingest-cycle: 260
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/byteArray.js` — ByteArrayHelper concrete instance of the PassStyleHelper protocol

Full 68-line file in scope. Ingested as the next-after-cycle-259 chat-lane entry (continuing the designs-chat alternation since cycle 166). Sibling to the previously-ingested [pass-style PassStyleHelper cluster](endo--packages-pass-style-helpers-cluster--PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named.md) — that page documented the **uniform shape** of all `PassStyleHelper`s; this page documents one **concrete instance** of that shape (the `'byteArray'` pass-style), and surfaces what is unique to byteArray: the **feature detection** at module load, the **three-line validity check**, and the **proposed-vs-shimmed** prototype lookup discipline.

## §Module structure overview

The file has **three top-level concerns**, in order:

1. **Imports + local destructuring** (lines 1–9): `harden` from `@endo/harden`; `X` and `Fail` from `@endo/errors`; an `@import` typedef of `PassStyleHelper` from the sibling `./internal-types.js`; destructuring of `Object.{getPrototypeOf, getOwnPropertyDescriptor}` and `Reflect.{ownKeys, apply}` into local consts.
2. **`adaptImmutableArrayBuffer` factory** (lines 14–42) called immediately at module load (line 44) — feature-detects platform support for `sliceToImmutable()` on `ArrayBuffer`, returns either real `{immutableArrayBufferPrototype, immutableGetter}` or `{immutableArrayBufferPrototype: null, immutableGetter: () => false}`.
3. **`export const ByteArrayHelper`** (lines 50–68) — the hardened PassStyleHelper instance, exported by name.

§The-three-concerns-template (imports + adapter-factory + named-helper-export) is a recurring shape across the PassStyleHelpers; the byteArray case adds the adapter-factory step because byteArray is the only pass-style whose validity depends on a stage-3 ECMAScript proposal that may not be present on the platform.

## §Feature-detection at module load with two return shapes

`adaptImmutableArrayBuffer` is an **immediately-invoked closure** (defined at line 14, called at line 44, result destructured into module-scope `immutableArrayBufferPrototype` and `immutableGetter`). The closure makes a one-line probe:

```js
const anArrayBuffer = new ArrayBuffer(0);

if (anArrayBuffer.sliceToImmutable === undefined) {
  return {
    immutableArrayBufferPrototype: null,
    immutableGetter: () => false,
  };
}
```

§Two-shapes-with-same-keys is the function's contract: caller destructures by name and gets either real values or always-deny stand-ins; the call site does not branch on platform feature presence.

- §`immutableArrayBufferPrototype: null` is the **impossibility signal** — when the platform lacks the proposal, no `instanceof`-style check can ever succeed because the helper's `assertRestValid` compares with `===` against this prototype reference.
- §`immutableGetter: () => false` is the **always-deny getter stand-in** — when the platform lacks the proposal, every call to the `.immutable` getter via `apply(immutableGetter, candidate, [])` evaluates to false, which makes the helper's `Fail` branch fire.
- §The-call-site-need-not-know-which-branch-fired — `confirmCanBeValid` returns false in the absence-of-proposal case via `candidate instanceof ArrayBuffer && candidate.immutable` (a real ArrayBuffer cannot satisfy `.immutable` without the proposal).
- §The-feature-detection-runs-once-at-module-load — *not* on every `passStyleOf` call. The cost of the probe is paid once and amortized across the lifetime of the SES realm.
- §sliceToImmutable-as-the-canonical-detection-probe — §use-the-method-name-on-an-empty-buffer to detect the proposal's presence; §do-not-feature-detect-by-trying-and-catching; §do-not-feature-detect-by-checking-globalThis-properties.
- §First-explicit-observation in library: **§stage-3-proposal-feature-detection-at-module-load-with-null-prototype-as-impossibility-signal**.

§The-comment-block-on-the-detection (lines 11–13: *"Detects the presence of a immutable ArrayBuffer support in the underlying platform and provides either suitable values from that implementation or values that will consistently deny that immutable ArrayBuffers exist."*) is the canonical specification of the §two-shapes-with-same-keys contract; §the-doc-comment-IS-the-contract (sibling to cycle 257's design-doc-template recurrence and cycle 253's pattern of doc-comment-IS-the-spec).

## §The proposed-vs-shimmed prototype discipline

Lines 28–34 contain a doc comment whose precision is unusual:

```
/**
 * As proposed, this will be the same as `ArrayBuffer.prototype`. As shimmed,
 * this will be a hidden intrinsic that inherits from `ArrayBuffer.prototype`.
 * Either way, get this in a way that we can trust it after lockdown, and
 * require that all immutable ArrayBuffers directly inherit from it.
 */
const immutableArrayBufferPrototype = getPrototypeOf(anImmutableArrayBuffer);
```

§The-proposed-vs-shimmed-discipline names two possible runtime topologies that the code must accept without branching:

- §**The-proposed-shape**: `immutableArrayBufferPrototype === ArrayBuffer.prototype` (the stage-3 proposal adds `.immutable` as a getter on `ArrayBuffer.prototype` itself). Immutable and mutable ArrayBuffers share a prototype; the difference is internal slot state.
- §**The-shimmed-shape**: `immutableArrayBufferPrototype` is a **hidden intrinsic** that inherits from `ArrayBuffer.prototype`. Immutable ArrayBuffers have a one-level-deeper prototype chain; the hidden intrinsic carries the `.immutable` getter.

§The-getPrototypeOf-of-an-instance-yields-the-correct-prototype-in-either-topology — the code obtains the prototype dynamically rather than naming `ArrayBuffer.prototype` or any shim-specific intrinsic. §the-runtime-tells-us-the-shape rather than the source code presuming.

§"get this in a way that we can trust it after lockdown" — the read happens at module load (pre-lockdown), so the captured `immutableArrayBufferPrototype` and `immutableGetter` are §captured-before-lockdown-and-remain-trustworthy-after. Sibling pattern to cycle 245's `@endo/panic`'s pre-lockdown native-capture and cycle 246's pre-lockdown-capture-and-shim-replacement discipline.

§"require that all immutable ArrayBuffers directly inherit from it" — this is the **policy** the helper enforces via `getPrototypeOf(candidate) === immutableArrayBufferPrototype` (strict equality, not `instanceof`). §direct-prototype-equality-not-instanceof — §when-the-canonical-prototype-is-captured-at-module-load, §use-strict-equality-against-the-capture-rather-than-instanceof-or-isPrototypeOf; §instanceof-walks-the-prototype-chain-and-can-accept-subclasses + §isPrototypeOf-also-walks-the-chain + §strict-equality-rejects-anything-with-an-extra-prototype-link-between-the-candidate-and-the-canonical-prototype.

§First-explicit-observation in library: **§the-proposed-vs-shimmed-discipline-named-as-two-runtime-topologies-the-code-accepts-without-branching**.

## §Three-line validity check as the assertRestValid body

Lines 57–67 define the helper's `assertRestValid` field (called by the `passStyleOf` core after `confirmCanBeValid` has returned true):

```js
assertRestValid: (candidate, _passStyleOfRecur) => {
  getPrototypeOf(candidate) === immutableArrayBufferPrototype ||
    assert.fail(X`Malformed ByteArray ${candidate}`, TypeError);
  apply(immutableGetter, candidate, []) ||
    Fail`Must be an immutable ArrayBuffer: ${candidate}`;
  ownKeys(candidate).length === 0 ||
    assert.fail(
      X`ByteArrays must not have own properties: ${candidate}`,
      TypeError,
    );
},
```

§Three-line-check-with-three-orthogonal-rejection-criteria:

1. **§Prototype-identity check** — `getPrototypeOf(candidate) === immutableArrayBufferPrototype` rejects anything that doesn't directly inherit from the canonical prototype. *Why direct identity, not `instanceof`?* — §a-malicious-subclass-of-ImmutableArrayBuffer-would-pass-instanceof-but-fail-strict-equality; §a-malicious-host-could-substitute-an-evil-toString-via-prototype-pollution-on-a-deeper-chain-link.
2. **§Immutability check** — `apply(immutableGetter, candidate, [])` calls the captured `.immutable` getter with `candidate` as `this`. *Why `Reflect.apply` not `candidate.immutable`?* — §defensive-binding-against-property-shadowing; §a-malicious-object-could-shadow-`.immutable`-with-its-own-true-getter; §reading-the-property-via-a-pre-captured-getter-function-bypasses-the-instance's-own-prototype-chain. Sibling pattern to cycle 235's base64 Reflect.apply defensive binding and cycle 245's panic Reflect-defensive-getter-call.
3. **§Own-keys check** — `ownKeys(candidate).length === 0` rejects ArrayBuffers with own properties. *Why?* — §ByteArrays-must-be-canonical-bag-of-bytes-with-no-attached-metadata; §a-host-could-attach-a-hidden-credential-as-an-own-property-and-have-it-flow-through-a-marshal-channel-as-a-side-channel; §strip-the-side-channel-by-rejecting-any-own-property.

§Each-line-uses-the-`predicate-OR-fail`-idiom — §short-circuit-evaluation-as-conditional-assert; §when-predicate-true-the-or-is-not-evaluated + §when-predicate-false-the-or-fires-the-fail; §the-idiom-is-tighter-than-an-if-statement.

§Two-error-API-styles-in-one-helper: §`assert.fail(X\`...\`, TypeError)` is used for the structural rejections (prototype mismatch, own keys present); §`Fail\`...\`` is used for the semantic rejection (immutable check). §**Why the asymmetry?** — §assert.fail-takes-a-constructor-argument-so-you-can-choose-the-error-class (TypeError signals "wrong shape"); §Fail-always-throws-a-plain-Error-but-is-more-ergonomic. §the-style-asymmetry-encodes-the-distinction (TypeError = structural; Error = semantic).

§First-explicit-observation in library: **§three-line-validity-check-with-three-orthogonal-rejection-criteria-each-with-the-predicate-OR-fail-idiom**.

## §The `confirmCanBeValid` minimal check vs the `assertRestValid` thorough check

Lines 53–55:
```js
confirmCanBeValid: (candidate, reject) =>
  (candidate instanceof ArrayBuffer && candidate.immutable) ||
  (reject && reject`Immutable ArrayBuffer expected: ${candidate}`),
```

§The-PassStyleHelper-protocol's-two-phase-validation (per the cycle 249 sibling page on the helpers cluster):

- §**Phase-1 `confirmCanBeValid`** — *minimal* check: just enough to decide whether THIS helper is the right one for the candidate. The candidate is an `ArrayBuffer` and has `.immutable === true`. §the-minimal-check-uses-instanceof-not-strict-prototype-equality — because at this phase we're answering *"is this an ArrayBuffer at all, of any subclass?"* not *"does it satisfy our canonical-prototype rule?"*. §the-thorough-check-tightens-the-criteria-in-phase-2.
- §**Phase-2 `assertRestValid`** — *thorough* check: now that we've committed to this helper, validate the canonical-prototype rule, the immutability via captured getter, and the no-own-properties rule.

§Two-phase-progressive-tightening — §phase-1-uses-instanceof-as-a-loose-shape-question + §phase-2-uses-strict-equality-as-a-tight-canonical-question; §the-two-questions-have-different-purposes-so-different-strictness; §sibling pattern to the PassStyleHelper cluster's broader two-phase shape.

§The-`reject &&` short-circuit on line 55 — when `reject` is not passed (the helper is being asked "are you the right one?" without diagnostic ambition), the helper just returns true-or-false; when `reject` IS passed (the helper is being asked "and if not, tell us why"), it formats the rejection. §the-reject-callback-pattern-from-the-helpers-cluster.

## §Direct-prototype-equality as the side-channel defense

The §direct-prototype-equality-not-instanceof discipline (§prototype-identity check above) functions as a §side-channel-defense:

- §an-instanceof-check-walks-the-prototype-chain — a malicious actor could construct a subclass of ImmutableArrayBuffer with extra methods or shadowed properties; `instanceof ImmutableArrayBuffer` would return true, and the marshal layer would accept it as a canonical ByteArray.
- §strict-prototype-equality-rejects-anything-with-extra-chain-links — the canonical prototype is the only acceptable direct parent; any extra chain link signals tampering.
- §the-canonical-shape-IS-a-side-channel-defense — §when-the-marshal-protocol-promises-byte-array-passable-leaves-have-no-attached-data, §the-helper-must-enforce-it-structurally + §a-permissive-instanceof-would-violate-the-protocol-promise.

§This is the §sibling-pattern-to-cycle-244's-only-the-canonical-prototype-passes — the [TickResponse one-shot exo](endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed.md) used the same shape-only-one-canonical-prototype discipline.

§Two-cycles-with-canonical-prototype-as-side-channel-defense: cycle 244 (one-shot exo) + cycle 260 (PassStyleHelper byteArray).

## §The captured-getter pattern as defense against property shadowing

Line 60: `apply(immutableGetter, candidate, [])` is functionally equivalent to `candidate.immutable` *if and only if* `candidate` has not shadowed `.immutable`. The byteArray helper assumes shadowing IS possible (because the candidate may be an attacker-controlled object that has crossed a marshal boundary):

- §a-naive-`candidate.immutable`-read goes through the candidate's own property lookup → its own prototype's lookup → ArrayBuffer.prototype's lookup; any of those can shadow.
- §`apply(immutableGetter, candidate, [])` invokes the §captured-getter-function with the candidate bound as `this`; no property lookup happens on the candidate.
- §the-getter-function-is-captured-at-module-load (line 36–39) from the canonical `immutableArrayBufferPrototype`; it cannot be swapped by post-lockdown attacker code because the binding is held in module-scope `const`.

§the-canonical-pattern (sibling to cycle 245's panic-cluster): §capture-the-native-getter-at-module-load + §call-it-via-Reflect.apply-with-the-candidate-as-this + §never-trust-the-candidate's-own-property-lookup.

§Three-cycles-with-pre-lockdown-getter-capture-plus-Reflect-apply-defensive-call (cycle 235 base64 + cycle 245 panic + cycle 260 byteArray) — §this is now a §reified-discipline across the library.

§First-explicit-observation as named cluster: **§three-cycles-with-pre-lockdown-getter-capture-plus-Reflect-apply-defensive-call**.

## §The styleName field and the PassStyleHelper export discipline

Line 51: `styleName: 'byteArray'` — the helper declares the pass-style it implements. Per the cycle 249 helpers-cluster page, the `passStyleOf` core iterates the helpers in order and asks each one `confirmCanBeValid`; the matching helper's `styleName` becomes the result. §the-styleName-IS-the-protocol-tag-the-marshal-layer-emits-on-the-wire.

Lines 50, 68: `export const ByteArrayHelper = harden({ ... });` — §the-helper-is-named-exported and §harden-wrapped-at-construction. §three-disciplines-in-one-line:
- §the-export-is-`const`-not-`let` (no rebinding allowed).
- §the-value-is-`harden`-wrapped (no mutation possible).
- §the-binding-name-is-`<StyleName>Helper`-PascalCase (consistent with sibling helpers).

§the-binding-name-convention (PascalCase-with-`Helper`-suffix) is one half of the §two-phase-name-convention across the helpers cluster (the other half: §`styleName`-field-is-lowercase-camelCase-noun matching the on-the-wire tag).

## §Sibling pattern roundup

§Cycle 260 reinforces or extends the following library patterns:

- §the-PassStyleHelper-uniform-shape (cycle 249 sibling) — cycle 260 is a concrete instance.
- §the-three-concerns-template (imports + adapter-factory + named-helper-export) — cycle 260 instantiates with adapter-factory because byteArray depends on a stage-3 proposal.
- §pre-lockdown-getter-capture-plus-Reflect-apply-defensive-call (cycles 235 + 245 + 260; **three-cycles** now → §the-discipline-is-now-canonical).
- §direct-prototype-equality-as-side-channel-defense (cycles 244 + 260; **two cycles** → §emergent-pattern).
- §the-doc-comment-IS-the-contract (cycles 253 + 257 + 260; **three cycles** now).
- §captured-before-lockdown-and-remain-trustworthy-after (cycles 245 + 246 + 260; **three cycles** now).
- §named-import-isolation-via-destructuring (cycles 242 + 254 + 258 + 260; **four cycles** now → §discipline-now-canonical).
- §predicate-OR-fail-idiom (recurring across the @endo/errors-consuming files; cycle 260 surfaces the variation **two error-API styles in one helper**).

## §Three first-explicit-observations from cycle 260

1. **§stage-3-proposal-feature-detection-at-module-load-with-null-prototype-as-impossibility-signal** — `adaptImmutableArrayBuffer` is the canonical embodiment.
2. **§the-proposed-vs-shimmed-discipline-named-as-two-runtime-topologies-the-code-accepts-without-branching** — the lines 28–34 doc comment is the canonical specification.
3. **§three-line-validity-check-with-three-orthogonal-rejection-criteria-each-with-the-predicate-OR-fail-idiom** — `assertRestValid` is the canonical embodiment, with the §two-error-API-styles-encoding-the-distinction-between-structural-and-semantic-rejection.

## §Tier-1 borrowing for downstream synthesis

For the slot machine library §game-engine-protocol-helpers cluster:

- §game-helper-uniform-shape (sibling to PassStyleHelper) — every game-type-helper exports a `styleName` + `confirmCanBeValid` + `assertRestValid` triple.
- §game-helper-feature-detection-at-load — if a game-engine depends on a stage-3 platform feature (e.g., immutable-RNG-seed), §feature-detect-once-at-module-load + §null-prototype-as-game-disabled-signal + §always-deny-getter-when-game-feature-not-present.
- §game-helper-canonical-prototype-as-side-channel-defense — §a-game-token-validator-must-use-strict-prototype-equality, not instanceof, because §a-malicious-subclass-of-GameToken-could-carry-attached-credentials-out-of-the-capability-graph.
- §game-helper-three-line-validity-check — §prototype-identity + §immutability + §no-own-properties.
- §game-helper-captured-getter-pattern — §capture-the-canonical-game-state-getter-at-module-load + §call-it-via-Reflect.apply + §never-trust-the-candidate's-own-property-lookup. (a §game-cheat-could-shadow-.immutable-on-a-game-token-to-bypass-server-side-validation; the captured-getter defends against this.)

## §Tier-2 borrowing

- §the-two-shapes-with-same-keys contract (real values OR always-deny stand-ins) — §when-a-module-depends-on-a-platform-feature-that-may-be-absent, §return-two-shapes-with-the-same-keys-so-the-caller-need-not-branch.
- §the-styleName-IS-the-protocol-tag — §the-helper's-field-IS-the-on-the-wire-byte.
- §the-binding-name-convention (PascalCase + `Helper` suffix) — §consistent-naming-across-a-cluster-of-helpers + §makes-grep-trivially-find-all-helpers.

## §Tier-3 borrowing

- §three-cycles-with-pre-lockdown-getter-capture-plus-Reflect-apply-defensive-call (cycles 235 + 245 + 260).
- §two-cycles-with-canonical-prototype-as-side-channel-defense (cycles 244 + 260).
- §three-cycles-with-doc-comment-IS-the-contract (cycles 253 + 257 + 260).
- §three-cycles-with-pre-lockdown-capture-and-shim-replacement-discipline (cycles 245 + 246 + 260).
- §four-cycles-with-named-import-isolation-via-destructuring (cycles 242 + 254 + 258 + 260).
- §the-library-reaches-766-sections at cycle 260 (chat-lane @endo/pass-style/src/byteArray.js).
- §ninety-third consecutive designs-chat alternation cycles 166-250 + 252-260 (251 was out-of-band papers-lane).

§Synthesis-target sketch — a §game-engine-protocol-helpers-cluster modeled on the PassStyleHelpers, with one helper per pass-style of game value (game-token + game-bet + game-payout + game-event); each helper carries §styleName + §confirmCanBeValid (lightweight) + §assertRestValid (thorough); the §game-engine's-marshal-layer iterates helpers in order to discover the pass-style of each value crossing the §game-rule / §game-spectator boundary; §the-PassStyleHelpers-shape-IS-the-canonical-shape-for-protocol-marshal-helpers across the @endo ecosystem and is the right shape to borrow.

## Pattern summary (tag-prefixed)

§the-three-concerns-template (imports + adapter-factory + named-helper-export); §two-shapes-with-same-keys contract; §stage-3-proposal-feature-detection-at-module-load; §null-prototype-as-impossibility-signal; §always-deny-getter-when-platform-feature-not-present; §sliceToImmutable-as-the-canonical-detection-probe; §the-feature-detection-runs-once-at-module-load; §the-proposed-vs-shimmed-discipline-named-as-two-runtime-topologies; §the-runtime-tells-us-the-shape; §captured-before-lockdown-and-remain-trustworthy-after; §direct-prototype-equality-not-instanceof; §three-line-validity-check-with-three-orthogonal-rejection-criteria; §predicate-OR-fail-idiom; §two-error-API-styles-encoding-distinction-between-structural-and-semantic-rejection; §captured-getter-pattern-as-defense-against-property-shadowing; §three-cycles-with-pre-lockdown-getter-capture-plus-Reflect-apply-defensive-call; §two-cycles-with-canonical-prototype-as-side-channel-defense; §the-doc-comment-IS-the-contract; §three-cycles-with-doc-comment-IS-the-contract; §the-styleName-IS-the-protocol-tag; §three-disciplines-in-one-export-line (const + harden + PascalCase-Helper-suffix); §the-binding-name-convention; §four-cycles-with-named-import-isolation-via-destructuring.
