---
title: "@endo/harden make-hardener.js — canonical harden implementation; three-phase traversal with commit-after-all-frozen; V8 stack-accessor repair (70-line); FERAL-prefix discipline; substrate-of-substrates with zero @endo imports"
source: endo--packages-harden-make-hardener-js
url: https://github.com/endojs/endo/blob/master/packages/harden/make-hardener.js
authors: [Kris Kowal, Mark S. Miller, Google Caja contributors, Agoric contributors]
repo: endojs/endo
path: packages/harden/make-hardener.js
total-lines: 471
ingest-cycle: 338
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-canonical-harden-implementation
  - the-named-three-phase-traversal-with-named-commit-after-all-frozen
  - the-named-enqueue-dequeue-commit-algorithm
  - the-named-mark-hardened-only-after-all-frozen-discipline
  - the-named-transactional-harden-discipline
  - the-named-multi-generation-derivation-chain-named-in-the-header
  - the-named-four-stage-attribution-chain
  - the-named-FERAL-prefix-naming-convention
  - the-named-feral-error-with-named-reason
  - the-named-V8-error-own-stack-accessor-repair
  - the-named-platform-specific-repair-with-named-error-code
  - the-named-platform-detection-at-factory-time-not-per-call
  - the-named-platform-conditional-fast-path-vs-slow-path
  - the-named-acknowledged-and-bounded-hazard
  - the-named-triple-duplication-with-named-layering-constraint
  - the-named-bulk-destructure-of-globalThis
  - the-named-Safari-bug-workaround-with-named-tracking-URL
  - the-named-error-code-as-stable-URL-anchor
  - the-named-link-rot-acknowledgment-with-archive-URL
  - the-named-fallback-URL-when-canonical-dies
  - the-named-uncurry-this-canonical-idiom
  - the-named-hasOwn-shim-with-named-issue-link
  - the-named-substrate-of-substrates-zero-endo-imports
  - the-named-freezeTypedArray-with-tc39-spec-citation
  - the-named-freeze-before-traversal-defends-against-reactive-objects
  - the-named-getOwnPropertyDescriptors-defends-against-Object.prototype-poisoning
  - the-named-traversePrototypes-as-named-option
  - the-named-canonical-Endo-idiom-named-function-via-object-destructure
  - the-named-streak-resumes-with-ninth-instance
  - twenty-nine-cycles-with-named-pivot-domain-stay
  - sixty-two-citation-arc-closures-in-pivot-now
---

# `@endo/harden make-hardener.js` — canonical harden implementation; three-phase traversal with commit-after-all-frozen

The 471-line canonical implementation of `harden()` — the function that makes Hardened JavaScript hardened. Cycle 338 is **chat-lane after cycle 337's designs-lane @endo/harden README** (adjacent forward pair; same package). **Ninth INSTANCE** of one-cycle README↔source pattern; **§the-named-streak-resumes-with-ninth-instance** — the streak was at 1 after cycle 336 → 337 cross-package interruption; cycle 337 → 338 same-package resumes it. Streak count: 1.

**Twenty-ninth consecutive non-garden source after the pivot** (cycles 310-338). **§twenty-nine-cycles-with-named-pivot-domain-stay**. **§fourteen-named-packages-in-the-pivot-cluster** continues (harden's source after its README).

The file is the **canonical harden implementation**: 471 lines spanning a multi-generation derivation chain, bulk-destructure of globalThis intrinsics, FERAL_ERROR / FERAL_STACK_GETTER / FERAL_STACK_SETTER capture with platform-specific repair, three-phase traversal (enqueue + dequeue + commit), TypedArray special-case handling, and exported `makeHardener` factory.

## The single most structurally interesting move

**§the-named-three-phase-traversal-with-named-commit-after-all-frozen** — the `harden(root)` function (lines 339-467) has THREE separable phases:

```js
harden(root) {
  const toFreeze = new Set();

  function enqueue(val) { ... }
  const baseFreezeAndTraverse = obj => { ... };
  const freezeAndTraverse = ...;

  const dequeue = () => {
    setForEach(toFreeze, freezeAndTraverse);
  };

  const markHardened = value => {
    weaksetAdd(hardened, value);
  };

  const commit = () => {
    setForEach(toFreeze, markHardened);
  };

  enqueue(root);    // Phase 1: walk and enqueue everything reachable
  dequeue();        // Phase 2: freeze every enqueued value
  commit();         // Phase 3: mark every frozen value as hardened

  return root;
}
```

**§the-named-three-phase-traversal-with-named-commit-after-all-frozen** — first-explicit-observation as a tier-3 meta-pattern. The discipline:

| Phase | Operation | Failure semantics |
|---|---|---|
| **Enqueue** | Walk reachable graph; add unfrozen objects to `toFreeze` Set | Throws on non-object/non-function types |
| **Dequeue** | `setForEach(toFreeze, freezeAndTraverse)` — freeze each | May throw (proxy traps, accessor calls) |
| **Commit** | `setForEach(toFreeze, markHardened)` — mark each as hardened | Pure WeakSet adds; cannot throw |

**§the-named-mark-hardened-only-after-all-frozen-discipline** — first-explicit-observation. The COMMIT phase comes AFTER the DEQUEUE phase completes. If freezing fails mid-flight (e.g., a proxy trap throws, or a stack accessor misbehaves), the partially-frozen objects are NOT marked as hardened. This means:

1. **Re-attempting harden** on the same root re-walks the unfrozen-but-already-frozen objects (they pass `freeze()` as no-ops because frozen objects are idempotent under freeze)
2. **No partial-credit hardening** — `hardened` WeakSet membership is a CONFIRMED-COMPLETE state, not an IN-PROGRESS state
3. **Transactional discipline** — the all-or-nothing commit phase is the atomic transition

**§the-named-transactional-harden-discipline** — first-explicit-observation as a tier-3 meta-pattern. Compare to:
- Cycle 152 memo-race.js's §markSettled atomic-transition (read-then-assign-then-freeze-then-return; atomic state transition for a SINGLE record)
- Cycle 322 exo-makers.js's §seal-not-freeze-for-state (state seal is the boundary)
- Cycle 336 memo-race.js's §the-named-assign-then-freeze-transition (two-step terminal lock)
- **Cycle 338 make-hardener.js's §three-phase-traversal-with-named-commit-after-all-frozen** (three-phase transaction over a GRAPH)

**§four-shapes-of-atomic-transition-discipline** (152 single-record + 322 state-seal + 336 assign-then-freeze + 338 three-phase-over-graph) — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-enqueue-then-dequeue-then-commit-algorithm** — the discipline of separating WALK + ACT + RECORD phases. Tier-3 meta-pattern: when an operation needs to be atomic over a graph, split it into three phases where the third phase is pure book-keeping that cannot fail.

## §the-named-multi-generation-derivation-chain-named-in-the-header

Lines 1-21:

```
// Adapted from SES/Caja - Copyright (C) 2011 Google Inc.
// Copyright (C) 2018 Agoric

// Licensed under the Apache License, Version 2.0 (the "License");
// ...

// based upon:
// https://github.com/google/caja/blob/master/src/com/google/caja/ses/startSES.js
// https://github.com/google/caja/blob/master/src/com/google/caja/ses/repairES5.js
// then copied from proposal-frozen-realms deep-freeze.js
// then copied from SES/src/bundle/deepFreeze.js
```

**§the-named-multi-generation-derivation-chain-named-in-the-header** — first-explicit-observation as a tier-3 meta-pattern. The header NAMES the four-stage derivation chain:

1. **Stage 1**: Google Caja's `startSES.js` (2011)
2. **Stage 2**: Google Caja's `repairES5.js`
3. **Stage 3**: TC39's `proposal-frozen-realms` `deep-freeze.js`
4. **Stage 4**: SES's `src/bundle/deepFreeze.js`
5. **Stage 5 (current)**: @endo/harden's `make-hardener.js`

**§the-named-four-stage-attribution-chain** — first-explicit-observation. The attribution is not just *"based on prior work"* but enumerates each generation with a clickable URL. Each generation preserved enough of the prior to be cite-able.

**§the-named-attribution-as-historical-record** — first-explicit-observation as a tier-3 meta-pattern. Compare to:
- Cycle 336 memo-race.js's §the-named-public-domain-license-header-preserved-verbatim (Brian Kim 2017 nodejs/node#17469 dedication preserved)
- Cycle 338 make-hardener.js's four-stage attribution chain (Google 2011 → TC39 → SES → @endo)

**§two-shapes-of-attribution-discipline** — verbatim-preserved-dedication (cycle 336) + multi-generation-chain-named-in-header (cycle 338). First-explicit-observation as a tier-3 meta-pattern.

## §the-named-FERAL-prefix-naming-convention

The file declares THREE FERAL_-prefixed names:

| Name | Source | Reason |
|---|---|---|
| `FERAL_ERROR` (line 43) | `Error` constructor from globalThis | *"safe for internal use, but must not be revealed to post-lockdown code in any compartment since in V8 at least it bears stack inspection capabilities"* |
| `FERAL_STACK_GETTER` (line 231) | The stack accessor's `get` | *"shared getter of all those accessors"* on V8 |
| `FERAL_STACK_SETTER` (line 242) | The stack accessor's `set` | *"shared setter"* on V8 |

**§the-named-FERAL-prefix-naming-convention** — first-explicit-observation as a tier-3 meta-pattern. The `FERAL_` prefix marks values that have **excess authority** and must be **carefully hidden from client code**. The naming convention SIGNALS to reviewers that the value is dangerous. Tier-3 meta-pattern: when capturing a primitive that has authority beyond what should be exposed, prefix the binding with `FERAL_` so readers immediately understand the capability concern.

**§the-named-feral-error-with-named-reason** — first-explicit-observation. The comment at lines 40-43 explains:

> The feral Error constructor is safe for internal use, but must not be revealed to post-lockdown code in any compartment including the start compartment since in V8 at least it bears stack inspection capabilities.

The reasoning names BOTH the safe use (internal) AND the unsafe exposure (post-lockdown code) AND the platform (V8) AND the capability (stack inspection). **§the-named-FERAL-binding-with-four-part-justification** — first-explicit-observation.

Sibling to **cycle 87 pass-style/error.js**'s §V8-stack-accessor-channel observation. **§three-cycles-with-named-V8-stack-accessor-discipline** (87 + 336 + 338).

## §the-named-V8-error-own-stack-accessor-repair

Lines 171-242 implement a 70-line platform-specific repair of V8's problematic Error.prototype.stack accessor. The repair:

1. Captures the stack accessor's `get` + `set` for both `TypeError` and `Error`
2. Verifies same-realm equality (both errors should share the same getter and setter on V8)
3. If they match: capture as `FERAL_STACK_GETTER` + `FERAL_STACK_SETTER` and freeze them
4. If they don't match: **throw with named SES error code** `SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR`

```js
} else {
  // See https://github.com/endojs/endo/blob/master/packages/ses/error-codes/SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR.md
  throw TypeError(
    'Unexpected Error own stack accessor functions (SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR)',
  );
}
```

**§the-named-platform-specific-repair-with-named-error-code** — first-explicit-observation. The error code is a **stable URL anchor**: `SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR.md` lives in the ses package's error-codes directory. When code throws this error, the message contains the error code, which is grep-able. The Markdown file at the URL documents the failure mode.

**§the-named-error-code-as-stable-URL-anchor** — first-explicit-observation as a tier-3 meta-pattern. Compare to cycle 326's @deprecated tags (canonical pointer); cycle 336's TODO-with-named-obstacle (issue tracker reference); cycle 338's named-error-code (Markdown doc URL). **§three-shapes-of-stable-pointer-discipline** (deprecation-pointer + issue-link + error-code-Markdown). First-explicit-observation as a tier-3 meta-pattern.

**§the-named-platforms-without-the-bug-named-explicitly** — lines 194-198:

> Note that FF/SpiderMonkey, Moddable/XS, and the error stack proposal all inherit a stack accessor property from Error.prototype, which is great. That case needs no heroics to secure.

The comment names BOTH the platforms with the bug (V8) AND the platforms without it (FF/SpiderMonkey + Moddable/XS + error stack proposal). **§the-named-platforms-with-AND-without-bug-named-explicitly** — first-explicit-observation. Compare to cycle 337's §the-named-test-and-UI-framework-acknowledgment (parallel ecosystem named); cycle 338 names the platforms that DON'T need the repair.

## §the-named-platform-detection-at-factory-time-not-per-call

Lines 414-445 — `freezeAndTraverse` is defined as ONE OF TWO closures at factory time, NOT a branch evaluated per-call:

```js
const freezeAndTraverse =
  FERAL_STACK_GETTER === undefined && FERAL_STACK_SETTER === undefined
    ? // On platforms without v8's error own stack accessor problem,
      // don't pay for any extra overhead.
      baseFreezeAndTraverse
    : obj => {
        if (isError(obj)) {
          // ... stack-accessor repair logic ...
        }
        return baseFreezeAndTraverse(obj);
      };
```

**§the-named-platform-detection-at-factory-time-not-per-call** — first-explicit-observation as a tier-3 meta-pattern. The runtime branch is replaced by a per-instance choice. Platforms without the V8 bug get `baseFreezeAndTraverse` directly; V8 platforms get the wrapper that checks `isError(obj)` before adding stack repair.

The comment names the rationale: *"On platforms without v8's error own stack accessor problem, don't pay for any extra overhead."* **§the-named-platform-conditional-fast-path-vs-slow-path** — first-explicit-observation. Compare to:
- Cycle 332 exo-tools.js's §the-named-zero-copy-when-possible-discipline (copy only when needed)
- Cycle 334 common/object-map.js's §the-named-harden-cast-vs-harden-function-distinction (no extra harden on intrinsics)
- **Cycle 338 make-hardener.js's §the-named-platform-detection-at-factory-time-not-per-call** (no per-call branch on platforms without the bug)

**§three-cycles-with-named-pay-only-when-necessary-discipline** (332 + 334 + 338) — first-explicit-observation as a tier-3 meta-pattern.

## §the-named-acknowledged-and-bounded-hazard

Lines 433-441:

```js
defineProperty(obj, 'stack', {
  // NOTE: Calls getter during harden, which seems dangerous.
  // But we're only calling the problematic getter whose
  // hazards we think we understand.
  // @ts-expect-error TS should know FERAL_STACK_GETTER
  // cannot be `undefined` here.
  // See https://github.com/endojs/endo/pull/2232#discussion_r1575179471
  value: apply(FERAL_STACK_GETTER, obj, []),
});
```

**§the-named-acknowledged-and-bounded-hazard** — first-explicit-observation as a tier-3 meta-pattern. The comment NAMES:
1. The hazard (*"Calls getter during harden, which seems dangerous"*)
2. The bounded reason for accepting it (*"we're only calling the problematic getter whose hazards we think we understand"*)
3. The TypeScript suppression with named cause (`@ts-expect-error` + named reason)
4. The PR discussion link where the decision was discussed

**§the-named-four-part-hazard-acknowledgment** — first-explicit-observation. Compare to cycle 156 finalize.js's §gc-as-side-channel warning (the dangerous mode named); cycle 322 exo-makers.js's §warning-comment-repeated-thrice (state-sealed-not-frozen reminder); cycle 338's four-part acknowledgment is the most structured form. **§three-shapes-of-hazard-acknowledgment** (156 named-warning + 322 repeated-warning + 338 four-part-acknowledgment).

## §the-named-triple-duplication-with-named-layering-constraint

Lines 141-156 contain the SAME `isPrimitive` function as cycle 336 memo-race.js + cycle 142 passStyle-helpers.js. The TODO at line 142-145 names THREE packages:

```js
/**
 * TODO Consolidate with `isPrimitive` that's currently in `@endo/pass-style`
 * and also `ses`.
 * Layering constraints make this tricky, which is why we haven't yet figured
 * out how to do this.
 */
```

**§the-named-triple-duplication-with-named-layering-constraint** — first-explicit-observation. Cycle 336's note said the duplication was between @endo/promise-kit and @endo/pass-style (TWO packages). Cycle 338's TODO reveals the duplication is across THREE packages: @endo/harden, @endo/pass-style, and ses. The layering constraint forms a triangle: each package sits BELOW the others in some sense (harden is THE substrate; pass-style imports harden; ses underpins everything).

**§the-named-three-package-duplication-discipline** — first-explicit-observation. Tier-3 meta-pattern: when a primitive helper is needed at the bottom of multiple layered packages, duplicate rather than introduce circular imports. The TODO acknowledges the obstacle (layering); the practical decision is to duplicate.

**§the-named-honest-TODO-with-named-obstacle-applies-to-triple-duplication** — extending cycle 336's TODO-with-named-obstacle observation. **§four-cycles-with-named-isPrimitive-duplication-observation** (142 passStyle-helpers.js + 336 memo-race.js + 338 make-hardener.js + the implicit fourth in ses; not yet ingested).

## §the-named-substrate-of-substrates-zero-endo-imports

Looking at make-hardener.js's imports: there are **ZERO** imports of any @endo package. The file depends only on:
- `globalThis` (line 24 + 26-37 bulk destructure)
- Implicit Apache-2.0 license header (lines 1-21)

**§the-named-substrate-of-substrates-zero-endo-imports** — first-explicit-observation. Cycle 337 README named @endo/harden as the *"third tier"* of the HardenedJS defense (after HardenedJS primordials and LavaMoat). Cycle 338 reveals: **the third tier itself depends on NO other @endo package**. This is the substrate-of-substrates property — @endo/harden sits BELOW every other @endo package in the dependency graph.

**§the-named-zero-endo-imports-as-substrate-marker** — first-explicit-observation as a tier-3 meta-pattern. The dependency-graph position of a substrate package is **detectable by counting @endo imports**. A package with zero @endo imports cannot be a consumer; it can only be a provider.

Compare to:
- Cycle 332 exo-tools.js: seven @endo imports (substrate consumer)
- Cycle 334 common/object-map.js: one @endo import (`@endo/harden`)
- Cycle 336 memo-race.js: one @endo import (`@endo/harden`)
- **Cycle 338 make-hardener.js: ZERO @endo imports** (substrate provider)

**§the-named-dependency-import-count-tracks-package-tier** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: more @endo imports = higher in the stack; zero @endo imports = at the bottom.

## §the-named-bulk-destructure-of-globalThis

Lines 26-37 destructure TEN names from globalThis in one block:

```js
const {
  Array,
  JSON,
  Number,
  Object,
  Reflect,
  Set,
  String,
  Symbol,
  Uint8Array,
  WeakSet,
} = globalThis;
```

**§the-named-bulk-destructure-of-globalThis** — first-explicit-observation as a refinement of cycle 314/318's Reflect-only destructure and cycle 332's Reflect.apply+ownKeys destructure. Cycle 338 expands to ten intrinsics at module load.

**§five-cycles-with-named-pre-lockdown-intrinsic-capture** (314 + 318 + 332 + 334 + 338) — the discipline grows with file scope: hex needed Reflect; common needed Function.prototype.call.bind; make-hardener needs ten intrinsics because it touches Array iteration + JSON stringification + Number checks + Object descriptors + Reflect.apply + Set + WeakSet + Symbol + String + Uint8Array.

**§the-named-bulk-destructure-tracks-file-scope** — first-explicit-observation as a tier-3 meta-pattern. The number of destructured intrinsics is a proxy for how many language primitives the file uses; bigger files need more.

## §the-named-Safari-bug-workaround-with-named-tracking-URL

Lines 65-84 — a `defineProperty` wrapper that throws if the underlying `defineProperty` returns a non-self value:

```js
const defineProperty = (object, prop, descriptor) => {
  // We used to do the following, until we had to reopen Safari bug
  // https://bugs.webkit.org/show_bug.cgi?id=222538#c17
  // Once this is fixed, we may restore it.
  // // Object.defineProperty is allowed to fail silently so we use
  // // Object.defineProperties instead.
  // return defineProperties(object, { [prop]: descriptor });

  // Instead, to workaround the Safari bug
  const result = originalDefineProperty(object, prop, descriptor);
  if (result !== object) {
    // See https://github.com/endojs/endo/blob/master/packages/ses/error-codes/SES_DEFINE_PROPERTY_FAILED_SILENTLY.md
    throw TypeError(
      `Please report that the original defineProperty silently failed to set ${stringifyJson(
        String(prop),
      )}. (SES_DEFINE_PROPERTY_FAILED_SILENTLY)`,
    );
  }
  return result;
};
```

**§the-named-Safari-bug-workaround-with-named-tracking-URL** — first-explicit-observation. The comment block names:
1. The previous code (commented-out)
2. The bug URL (`webkit.org/show_bug.cgi?id=222538#c17`)
3. The conditional restoration (*"Once this is fixed, we may restore it"*)
4. The replacement code with explicit failure detection
5. The SES error code Markdown URL for the failure case

**§the-named-platform-bug-workaround-with-named-tracking-URL** — first-explicit-observation as a tier-3 meta-pattern. Compare to cycle 326's @deprecated-with-redirect (forward-pointer to canonical); cycle 338's bug-workaround-with-tracking-URL is the inverse — a *backward* pointer to the obstacle that justifies the workaround. **§the-named-forward-vs-backward-pointer-discipline** — first-explicit-observation.

**§the-named-Please-report-language** — line 78: *"Please report that the original defineProperty silently failed"*. The error message ASKS the caller to report the bug. **§the-named-error-message-as-bug-report-request** — first-explicit-observation as a tier-3 meta-pattern.

## §the-named-uncurry-this-canonical-idiom

Lines 95-108 — the canonical uncurryThis idiom:

```js
const { bind } = functionPrototype;
const uncurryThis = bind.bind(bind.call); // eslint-disable-line @endo/no-polymorphic-call
```

The comment block (98-108) cites BOTH the canonical wiki URL AND the web.archive.org URL:

> http://wiki.ecmascript.org/doku.php?id=conventions:safe_meta_programming
> which only lives at
> http://web.archive.org/web/20160805225710/...

**§the-named-link-rot-acknowledgment-with-archive-URL** — first-explicit-observation. The README ACKNOWLEDGES that the canonical URL is dead and provides the archive URL. **§the-named-fallback-URL-when-canonical-dies** — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-uncurry-this-canonical-idiom** — `bind.bind(bind.call)` — the canonical pre-lockdown method-extraction technique. Sibling to cycle 334's §the-named-Function.prototype.call.bind-as-method-extraction; cycle 338's `bind.bind(bind.call)` is a third shape of uncurry-this. **§three-canonical-uncurry-shapes-now-observed** (cycle 199 + cycle 207 + cycle 211 + cycle 334 + cycle 338) — the family grows.

**§the-named-eslint-disable-no-polymorphic-call** — `// eslint-disable-line @endo/no-polymorphic-call` — the uncurry-this idiom is so canonical that there's a SPECIFIC lint rule for it (which this line deliberately disables). **§the-named-named-lint-rule-with-canonical-exception** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: when a project standardizes on a canonical idiom AND a lint rule that prevents it elsewhere, the rule + disable-comment becomes a discipline-marker.

## §the-named-hasOwn-shim-with-named-issue-link

Lines 110-130 — feature detection + shim for `Object.hasOwn`:

```js
// See https://github.com/endojs/endo/issues/2930
if (!('hasOwn' in Object)) {
  const ObjectPrototypeHasOwnProperty = objectPrototype.hasOwnProperty;
  const hasOwnShim = (obj, key) => {
    if (obj === undefined || obj === null) {
      // We need to add this extra test because of differences in
      // the order in which `hasOwn` vs `hasOwnProperty` validates
      // arguments.
      throw TypeError('Cannot convert undefined or null to object');
    }
    return apply(ObjectPrototypeHasOwnProperty, obj, [key]);
  };
  defineProperty(Object, 'hasOwn', { value: hasOwnShim, writable: true, enumerable: false, configurable: true });
}
```

**§the-named-hasOwn-shim-with-named-issue-link** — first-explicit-observation. The comment cites endo/endo#2930. The shim:
1. Feature-detects `hasOwn` in Object
2. Captures `Object.prototype.hasOwnProperty` for use as the shim's underlying primitive
3. Adds an extra null/undefined check because *"differences in the order in which `hasOwn` vs `hasOwnProperty` validates arguments"*
4. Installs via `defineProperty` (which is the bug-workaround wrapper from above)

**§the-named-feature-detect-then-install-shim-pattern** — first-explicit-observation. The pattern: check; if absent, install. Compare to cycle 187's §two-shim-strategies (conditional + unconditional); cycle 338's shim is conditional (only installs when absent).

**§the-named-extra-test-because-of-validation-order-differences** — first-explicit-observation. The shim explicitly names the divergence from the spec's `hasOwn`. **§the-named-shim-explicitly-names-spec-divergence** — first-explicit-observation as a tier-3 meta-pattern. Sibling to cycle 336's §the-named-deviation-named-in-the-source-too — that was a deliberate divergence; cycle 338 is a *necessary* divergence for shim correctness.

## §the-named-freezeTypedArray-with-tc39-spec-citation

Lines 289-320 — `freezeTypedArray` handles TypedArrays specially:

```js
arrayForEach(ownKeys(array), name => {
  const desc = getOwnPropertyDescriptor(array, name);
  assert(desc);
  // TypedArrays are integer-indexed exotic objects, which define special
  // treatment for property names in canonical numeric form:
  // integers in range are permanently writable and non-configurable.
  // https://tc39.es/ecma262/#sec-integer-indexed-exotic-objects
  //
  // This is analogous to the data of a hardened Map or Set,
  // so we carve out this exceptional behavior but make all other
  // properties non-configurable.
  if (!isCanonicalIntegerIndexString(name)) {
    defineProperty(array, name, { ...desc, writable: false, configurable: false });
  }
});
```

**§the-named-freezeTypedArray-with-tc39-spec-citation** — first-explicit-observation. The comment cites the TC39 spec URL (`tc39.es/ecma262/#sec-integer-indexed-exotic-objects`) as the JUSTIFICATION for the special handling. **§the-named-tc39-spec-citation-as-rationale** — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-analogous-to-hardened-Map-or-Set** — the comment compares TypedArray integer-indexed data to *"the data of a hardened Map or Set"* — that is, the data slots are conceptually exempt from freeze because they're part of the object's identity, like Set/Map's internal slots. **§the-named-conceptual-analogy-to-justify-exception** — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-fail-safe-when-encountering-named-platform-bug** — lines 297-300:

> We get each descriptor individually rather than using getOwnPropertyDescriptors in order to fail safe when encountering an obscure GraalJS issue where getOwnPropertyDescriptor returns undefined for a property that does exist.

The comment names BOTH:
1. The platform (GraalJS)
2. The bug (getOwnPropertyDescriptor returns undefined for existing property)
3. The defense (per-property check rather than bulk-fetch)

**§the-named-platform-bug-defended-against-with-per-item-fallback** — first-explicit-observation. **§three-cycles-with-named-platform-specific-defense** (cycle 87 V8-stack + cycle 156 GC-as-side-channel + cycle 338 GraalJS + V8 + Safari combined). The defense pattern: when a bulk operation has platform-specific bugs, fall back to per-item operations.

## §the-named-canonical-Endo-idiom-named-function-via-object-destructure

Lines 333-339:

```js
const { harden } = {
  /**
   * @template T
   * @param {T} root
   * @returns {T}
   */
  harden(root) {
    // ...
  },
};
```

The SAME idiom as cycle 152 memo-race.js + cycle 336 memo-race.js: method-syntax + object-destructure + named-binding. **§the-named-canonical-Endo-idiom-named-function-via-object-destructure** — first-explicit-observation as a tier-3 meta-pattern. Three cycles now observe this idiom in @endo source code:

| Cycle | File | Function | Purpose |
|---|---|---|---|
| 152 | memo-race.js | `race` (renamed to `memoRace`) | Memory-safe Promise.race |
| 336 | memo-race.js (complementary lens) | same | reaffirmed |
| 338 | make-hardener.js | `harden` | The canonical hardener |

**§three-cycles-with-named-named-function-via-object-destructure** (152 + 336 + 338). The idiom is **canonical across @endo** for declaring named non-constructable functions.

## §the-named-traversePrototypes-as-named-option

Line 327:

```js
export const makeHardener = ({ traversePrototypes = false } = {}) => { ... };
```

The factory accepts a single named option: `traversePrototypes` (default `false`). When true, the harden walk follows prototype chains; when false, it stops at own properties.

**§the-named-traversePrototypes-as-named-option** — first-explicit-observation. The option NAMES the trade-off:
- `false` (default): faster, less safe (degraded mode per cycle 337 README's *"Without HardenedJS"*)
- `true`: slower, more safe (HardenedJS mode per cycle 337's *"With HardenedJS"*)

**§the-named-named-option-vs-positional-arg-discipline** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a function takes a boolean configuration, expose it as a named option, not a positional argument. This:
- Allows future expansion (more options without breaking call sites)
- Makes call sites self-documenting (`makeHardener({ traversePrototypes: true })` reads better than `makeHardener(true)`)
- Provides a place for JSDoc to document each option

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 337 (harden README) | 1 cycle | Adjacent forward pair; same-package README→source |
| Cycle 87 (pass-style error.js V8 stack accessor) | 251 cycles | §the-named-V8-error-own-stack-accessor-repair sibling; **second-longest pivot arc** |
| Cycle 152 (memo-race.js comment-fragment; isPrimitive TODO) | 186 cycles | §the-named-canonical-Endo-idiom-named-function-via-object-destructure sibling |
| Cycle 142 (passStyle-helpers.js isPrimitive) | 196 cycles | §the-named-triple-duplication-with-named-layering-constraint |
| Cycle 175 (make-selector.js sibling) | 163 cycles | Sibling file in same package |
| Cycle 211 (@endo/common harden in dependency-ceiling) | 127 cycles | Documentation-side closure of @endo/common's harden dependency |
| Cycle 156 (finalize.js named-warning) | 182 cycles | §three-shapes-of-hazard-acknowledgment |
| Cycle 322 (exo-makers complementary-lens) | 16 cycles | Cross-package canonical-idiom |
| Cycle 336 (memo-race.js complementary-lens; isPrimitive TODO observation) | 2 cycles | Now extending observation to THREE packages |

**§nine-citation-arc-closures-in-cycle-338**. **§sixty-two-citation-arc-closures-in-pivot-now** (56 + 6 net new).

## Patterns the cycle extends

- §twenty-nine-cycles-with-named-pivot-domain-stay (310-338)
- §fourteen-named-packages-in-the-pivot-cluster (harden's source after its README)
- §sixty-two-citation-arc-closures-in-pivot-now (56 + 6 net new)
- §three-cycles-with-named-V8-stack-accessor-discipline (87 + 336 + 338)
- §three-cycles-with-named-named-function-via-object-destructure (152 + 336 + 338)
- §three-cycles-with-named-pay-only-when-necessary-discipline (332 + 334 + 338)
- §three-shapes-of-hazard-acknowledgment (156 + 322 + 338)
- §three-shapes-of-stable-pointer-discipline (deprecation-pointer 326 + issue-link 336 + error-code-Markdown 338)
- §four-shapes-of-atomic-transition-discipline (152 + 322 + 336 + 338)
- §five-cycles-with-named-pre-lockdown-intrinsic-capture (314 + 318 + 332 + 334 + 338)
- §the-named-streak-resumes-with-ninth-instance (cycle 337 → 338 same-package; cycle 336 → 337 was cross-package; streak count is 1)

## Tier-1 borrowing (thirty-plus first-explicit-observations)

- **§the-named-three-phase-traversal-with-named-commit-after-all-frozen** — enqueue + dequeue + commit; transactional discipline
- **§the-named-mark-hardened-only-after-all-frozen-discipline** — book-keeping only after all-or-nothing freezes complete
- **§the-named-transactional-harden-discipline**
- **§the-named-multi-generation-derivation-chain-named-in-the-header** — four-stage attribution chain
- **§the-named-four-stage-attribution-chain**
- **§the-named-attribution-as-historical-record**
- **§the-named-FERAL-prefix-naming-convention** — marker for values with excess authority
- **§the-named-feral-error-with-named-reason**
- **§the-named-FERAL-binding-with-four-part-justification** — what's safe + what's unsafe + which platform + which capability
- **§the-named-V8-error-own-stack-accessor-repair**
- **§the-named-platform-specific-repair-with-named-error-code**
- **§the-named-error-code-as-stable-URL-anchor** — SES_ codes are grep-able stable identifiers
- **§the-named-platforms-with-AND-without-bug-named-explicitly**
- **§the-named-platform-detection-at-factory-time-not-per-call**
- **§the-named-platform-conditional-fast-path-vs-slow-path**
- **§the-named-acknowledged-and-bounded-hazard** — name the hazard AND the bounded reason for accepting it
- **§the-named-four-part-hazard-acknowledgment** — hazard + bounded reason + suppression + PR discussion
- **§the-named-triple-duplication-with-named-layering-constraint** — three-package isPrimitive
- **§the-named-three-package-duplication-discipline**
- **§the-named-bulk-destructure-of-globalThis** — ten intrinsics at module load
- **§the-named-bulk-destructure-tracks-file-scope**
- **§the-named-Safari-bug-workaround-with-named-tracking-URL**
- **§the-named-platform-bug-workaround-with-named-tracking-URL**
- **§the-named-forward-vs-backward-pointer-discipline** — deprecation forward; bug-workaround backward
- **§the-named-Please-report-language** — error message as bug-report request
- **§the-named-error-message-as-bug-report-request**
- **§the-named-link-rot-acknowledgment-with-archive-URL**
- **§the-named-fallback-URL-when-canonical-dies**
- **§the-named-named-lint-rule-with-canonical-exception** — eslint rule + disable-comment as discipline-marker
- **§the-named-hasOwn-shim-with-named-issue-link**
- **§the-named-extra-test-because-of-validation-order-differences**
- **§the-named-shim-explicitly-names-spec-divergence**
- **§the-named-freezeTypedArray-with-tc39-spec-citation**
- **§the-named-tc39-spec-citation-as-rationale**
- **§the-named-conceptual-analogy-to-justify-exception** — TypedArray data analogous to Map/Set data
- **§the-named-platform-bug-defended-against-with-per-item-fallback**
- **§the-named-substrate-of-substrates-zero-endo-imports**
- **§the-named-zero-endo-imports-as-substrate-marker**
- **§the-named-dependency-import-count-tracks-package-tier**
- **§the-named-traversePrototypes-as-named-option**
- **§the-named-named-option-vs-positional-arg-discipline**
- **§the-named-canonical-Endo-idiom-named-function-via-object-destructure**

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-nine-cycles-with-named-pivot-domain-stay
- §fourteen-named-packages-in-the-pivot-cluster
- §sixty-two-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-V8-stack-accessor-discipline (87 + 336 + 338)
- §three-cycles-with-named-named-function-via-object-destructure (152 + 336 + 338)
- §three-cycles-with-named-pay-only-when-necessary-discipline (332 + 334 + 338)
- §three-shapes-of-hazard-acknowledgment (156 + 322 + 338)
- §three-shapes-of-stable-pointer-discipline (326 + 336 + 338)
- §four-shapes-of-atomic-transition-discipline (152 + 322 + 336 + 338)
- §five-cycles-with-named-pre-lockdown-intrinsic-capture (314 + 318 + 332 + 334 + 338)
- §the-named-streak-resumes-with-ninth-instance

## Tier-3 borrowing (meta-patterns)

- **§the-named-three-phase-traversal-with-named-commit-after-all-frozen** — when an operation needs to be atomic over a graph, split it into walk + act + record phases where the third phase cannot fail
- **§the-named-transactional-harden-discipline** — mark hardened only after all frozen; all-or-nothing
- **§four-shapes-of-atomic-transition-discipline** — single-record (152) + state-seal (322) + assign-then-freeze (336) + three-phase-over-graph (338)
- **§the-named-multi-generation-derivation-chain-named-in-the-header** — name each generation with clickable URL
- **§two-shapes-of-attribution-discipline** — verbatim-dedication (336) + multi-generation-chain (338)
- **§the-named-FERAL-prefix-naming-convention** — marker for values with excess authority
- **§the-named-error-code-as-stable-URL-anchor** — SES_ codes are stable grep-able identifiers
- **§three-shapes-of-stable-pointer-discipline** — deprecation-pointer (326) + issue-link (336) + error-code-Markdown (338)
- **§the-named-platform-detection-at-factory-time-not-per-call** — bake choice into closure, don't branch per-call
- **§the-named-acknowledged-and-bounded-hazard** — name hazard + bounded reason for accepting
- **§three-cycles-with-named-pay-only-when-necessary-discipline** — copy only when redaction needed (332) + harden-cast distinction (334) + platform-conditional fast-path (338)
- **§the-named-forward-vs-backward-pointer-discipline** — deprecation forward; bug-workaround backward
- **§the-named-link-rot-acknowledgment-with-archive-URL**
- **§the-named-named-lint-rule-with-canonical-exception** — rule + disable-comment as discipline-marker
- **§the-named-tc39-spec-citation-as-rationale** — spec URL as justification
- **§the-named-conceptual-analogy-to-justify-exception** — analogous-to-X structure
- **§the-named-dependency-import-count-tracks-package-tier** — zero @endo imports = substrate
- **§the-named-named-option-vs-positional-arg-discipline**
- **§the-named-canonical-Endo-idiom-named-function-via-object-destructure** — three-cycle confirmed idiom

## Synthesis-target

Slot machine library **§`@game/harden/make-hardener.js`** — canonical harden implementation:

1. **Three-phase traversal with commit-after-all-frozen** — enqueue + dequeue + commit; partial-credit-prohibited
2. **Multi-generation derivation chain in the header** — name each generation with clickable URL
3. **FERAL_-prefix naming convention** — marker for values with excess authority
4. **Platform-specific repair with named error code** — bug detection + repair + stable URL anchor
5. **Platform detection at factory time, not per-call** — bake the choice into the closure
6. **Acknowledged and bounded hazard** — name the hazard AND the bounded reason for accepting it
7. **Honest TODO with named layering-constraint** — when duplication can't be eliminated, name the obstacle
8. **Bulk destructure of globalThis** at module load — capture all needed intrinsics in one block
9. **Safari/V8/GraalJS/JSC bug-workaround pattern** — feature-detect + workaround + tracking URL
10. **Error message as bug-report request** — *"Please report that..."* language
11. **Link-rot acknowledgment with archive URL** — when canonical URL dies, archive URL is the fallback
12. **Named lint rule with canonical exception** — eslint rule + disable-comment as discipline marker
13. **Shim explicitly names spec divergence** — *"differences in the order in which..."*
14. **TC39 spec citation as rationale** — spec URL justifies special handling
15. **Conceptual analogy to justify exception** — *"This is analogous to the data of..."*
16. **Substrate-of-substrates with zero @endo imports** — substrate packages have no internal-org dependencies
17. **traversePrototypes as named option** — boolean trade-offs exposed as named options, not positional args
18. **Canonical Endo idiom: named-function-via-object-destructure** — method-syntax + object-destructure + named-binding

## Library state after cycle 338

- §library-reaches-850-sections from 383 source documents
- §one-hundred-and-seventy-first consecutive designs-chat alternation
- §twenty-nine-cycles-with-named-pivot-domain-stay
- §fourteen-named-packages-in-the-pivot-cluster (harden's source after its README; thirteenth source page in the pivot)
- §sixty-two-citation-arc-closures-in-pivot-now (56 + 6 net new)
- §three-cycles-with-named-V8-stack-accessor-discipline (87 + 336 + 338)
- §three-cycles-with-named-named-function-via-object-destructure as a canonical Endo idiom (152 + 336 + 338)
- §four-shapes-of-atomic-transition-discipline (152 + 322 + 336 + 338)
- §the-named-three-phase-traversal-with-named-commit-after-all-frozen established as a tier-3 meta-pattern
- §the-named-FERAL-prefix-naming-convention established as a tier-3 meta-pattern
- §the-named-platform-detection-at-factory-time-not-per-call established as a tier-3 meta-pattern
- §the-named-substrate-of-substrates-zero-endo-imports established as a tier-3 meta-pattern (dependency-import-count tracks package tier)
- §the-named-streak-resumes-with-ninth-instance (cycle 337 → 338 same-package; ninth INSTANCE of one-cycle README↔source pattern; streak count is 1 because cycle 336 → 337 was cross-package)
