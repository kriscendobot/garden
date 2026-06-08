---
title: "@endo/pass-style helpers cluster (byteArray + copyArray + copyRecord + tagged + iter-helpers + string + makeTagged) — §PassStyleHelper-uniform-shape + §two-phase-validation (confirmCanBeValid + assertRestValid) + §rest-spread-collects-everything-not-named + §don't-coerce-input + §env-option-gated-strictness + §adapt-feature-detection"
source-slug: endo--packages-pass-style-helpers-cluster
section-id: PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
url: https://github.com/endojs/endo/tree/master/packages/pass-style/src
authors: [Endo contributors]
repo: endojs/endo
path: packages/pass-style/src/{byteArray.js, copyArray.js, copyRecord.js, tagged.js, iter-helpers.js, string.js, makeTagged.js}
status: shipping
ingest-cycle: 227
ingest-date: 2026-06-08
lane: chat
---

# @endo/pass-style helpers cluster — uniform `PassStyleHelper` shape across pass-style kinds

§Seven-file-cluster in `packages/pass-style/src/`: 38 + 70 + 68 + 49 + 60 + 83 + 31 = 399 lines. Six pass-style helpers (byteArray + copyArray + copyRecord + tagged + iter-helpers + string + makeTagged) sharing the §PassStyleHelper-uniform-shape — a §code-file-cluster-with-shared-template parallel to cycle 226's §design-document-cluster-with-shared-template (endoclaw six-design-cluster).

§Two-different-cluster-ingest-types now in library are well-established:
- Cluster-of-code-files: cycle 199 trampoline/memoize/nat trio (small @endo packages) + cycle 211 @endo/common ten-utility-files + cycle 227 pass-style helpers.
- Cluster-of-design-documents: cycle 226 endoclaw six-design-cluster.

## §The-`PassStyleHelper`-uniform-shape

Four of the seven files (byteArray + copyArray + copyRecord + tagged) export a `PassStyleHelper`-typed object with the same three-field shape:

```js
export const XxxHelper = harden({
  styleName: '...',
  confirmCanBeValid: (candidate, reject) => ...,
  assertRestValid: (candidate, passStyleOfRecur) => ...,
});
```

§Three-uniform-fields-per-helper:
1. **§styleName** — string literal identifying the pass-style kind.
2. **§confirmCanBeValid** — cheap structural check (returns boolean or rejects via the Rejector parameter).
3. **§assertRestValid** — deep validation (called only after confirmCanBeValid passed; throws on invalid).

§Borrowable-pattern: §uniform-shape-with-pluggable-fields across a cluster of files. §The-dispatcher (passStyleOf, cycle 71) dispatches on `styleName` + §calls-both-methods-in-sequence (confirmCanBeValid first; if true, then assertRestValid).

§Sibling to cycle 226 endoclaw cluster's §two-facet-control-pair canonical shape — both designs §uniform-shape-across-cluster-members.

## §Two-phase-validation (confirmCanBeValid + assertRestValid)

§The-load-bearing-architectural-move. §The-two-phases-have-different-purposes:

- §confirmCanBeValid — §the-`is-it-this-kind`-check. Cheap; returns boolean via Rejector. Called by passStyleOf to discriminate among kinds.
- §assertRestValid — §the-`is-it-well-formed`-check. May be expensive; throws on invalid. Called once passStyleOf is sure of the kind.

§Borrowable-pattern: §split-validation-into-cheap-discriminator + §deep-well-formedness. §The-cheap-check-runs-on-every-classification; §the-deep-check-runs-only-after-classification-succeeds.

§Sibling to cycle 215 @endo/hex's §two-different-shapes-for-dispatching-to-native (unconditional for encode + dispatch-with-on-failure-polyfill-rerun for decode). §Cycle 215's pattern is at the protocol layer; cycle 227's pattern is at the validation layer.

§Borrowable-pattern: §Rejector-typedef-from-cycle-217 used consistently across all four helpers — `(candidate, reject)` signature in confirmCanBeValid. §The-Rejector-trio-pattern (cycle 217) instantiated in each helper.

## §copyRecord.js — §confirmObjectPrototype + §confirmPropertyCanBeValid

```js
const confirmObjectPrototype = (candidate, reject) => {
  return (
    getPrototypeOf(candidate) === objectPrototype ||
    (reject && reject`Records must inherit from Object.prototype: ${candidate}`)
  );
};

const confirmPropertyCanBeValid = (candidate, key, value, reject) => {
  return (
    (typeof key === 'string' ||
      (reject &&
        reject`Records can only have string-named properties: ${candidate}`)) &&
    (!canBeMethod(value) ||
      (reject &&
        reject`Records cannot contain non-far functions because they may be methods of an implicit Remotable: ${candidate}`))
  );
};
```

§Two-named-internal-predicates with §the-Rejector-three-line-idiom (`cond || (reject && reject\`...\`)`). §confirmCanBeValid composes them with `.every`:

```js
confirmCanBeValid: (candidate, reject) => {
  return (
    confirmObjectPrototype(candidate, reject) &&
    ownKeys(candidate).every(key =>
      confirmPropertyCanBeValid(candidate, key, candidate[key], reject),
    )
  );
},
```

§Three-constraints-checked-in-sequence: §inherits-from-Object.prototype + §string-named-property-keys + §no-method-like-values. §Sibling to cycle 230 (anticipated) Remotable's §non-far-functions-may-be-methods discipline.

§The-TODO-comment in `confirmPropertyCanBeValid`:

```js
// TODO: Update message now that there is no such thing as "implicit Remotable".
```

§Honest-acknowledgment-of-stale-error-message-text. §Borrowable-pattern: §TODO-comment-marks-a-stale-error-message that's still informative-enough-to-be-useful. §The-fix-is-not-urgent; the comment is.

## §copyArray.js — §the-length-vs-ownKeys-check

```js
// Expect one key per index plus one for 'length'.
ownKeys(candidate).length === len + 1 ||
  assert.fail(X`Arrays must not have non-indexes: ${candidate}`, TypeError);
```

§Defensive-shape: an array with N indices has §exactly-N+1-own-keys (N indices + the special `length` key). §Any-extra-own-keys (e.g., `[]; arr.foo = 'bar'`) §violates-the-pass-style + §rejected-with-named-error.

§Borrowable-pattern: §invariant-on-own-keys-count + §reject-deviations. §The-array-has-no-non-index-properties is the §invariant-encoded-as-count-check.

## §tagged.js — §rest-spread-collects-everything-not-named (revisit)

```js
const {
  [passStyleKey]: _passStyleDesc,
  [tagKey]: _labelDesc,
  payload: _payloadDesc,
  ...restDescs
} = getOwnPropertyDescriptors(candidate);
ownKeys(restDescs).length === 0 ||
  Fail`Unexpected properties on tagged record ${ownKeys(restDescs)}`;
```

§The-rest-spread-collects-everything-not-named idiom (sibling to cycle 217 @endo/errors' rename-utilities-split-from-assertions). §Destructure-the-three-known-properties + §rest-spread-collects-the-unexpected-ones + §reject-if-any-unexpected.

§Borrowable-pattern: §when-an-object-must-have-exactly-N-specific-properties + §no-others, §destructure-the-N-known-ones + §rest-spread-the-rest + §assert-the-rest-is-empty. §The-rest-spread-IS-the-validation-of-no-extra-properties.

§This-is-the-second-use-of-the-pattern in library:
- Cycle 217 @endo/errors: §destructure-with-underscore-prefix-to-deliberately-discard (omits one property).
- Cycle 227 tagged.js: §rest-spread-collects-the-unexpected + §assert-rest-is-empty.

§Two-different-purposes-for-the-same-mechanism: cycle 217 omits known property; cycle 227 detects unknown properties.

## §byteArray.js — §adapt-feature-detection for §immutable-ArrayBuffer

```js
const adaptImmutableArrayBuffer = () => {
  const anArrayBuffer = new ArrayBuffer(0);
  if (anArrayBuffer.sliceToImmutable === undefined) {
    return {
      immutableArrayBufferPrototype: null,
      immutableGetter: () => false,
    };
  }
  const anImmutableArrayBuffer = anArrayBuffer.sliceToImmutable();
  const immutableArrayBufferPrototype = getPrototypeOf(anImmutableArrayBuffer);
  const immutableGetter = getOwnPropertyDescriptor(immutableArrayBufferPrototype, 'immutable').get;
  return { immutableArrayBufferPrototype, immutableGetter };
};

const { immutableArrayBufferPrototype, immutableGetter } =
  adaptImmutableArrayBuffer();
```

§Feature-detection-with-fallback. §If-the-platform-lacks-sliceToImmutable (cycle 201 @endo/immutable-arraybuffer sibling), §return-deny-shapes (null prototype + always-false getter). §The-rest-of-the-file-uses-these-bindings-uniformly — §the-validation-degrades-to-always-reject-byteArrays.

§Borrowable-pattern: §feature-detection-returns-bindings-that-deny-when-the-feature-is-missing. §The-consumer-code-doesn't-branch-on-feature-presence; §the-bindings-do-the-right-thing.

§Sibling to cycle 215 @endo/hex's §ponyfill-with-load-time-dispatch — both designs §load-time-feature-test + §use-bindings-uniformly-after.

§Apply-immutableGetter via Reflect.apply: `apply(immutableGetter, candidate, [])`. §Sibling to cycle 215's §Reflect.apply-as-the-defensive-uncurry. §Fifth-instance of §Reflect.apply-defensive-uncurry in library (cycles 199 + 207 + 211 + 215 + 227).

§Six-cycles-with-the-identifier-IS-the-capability discipline now if we extend to §the-prototype-IS-the-discriminator: cycle 200 (retention paths) + cycle 210 (deterministic naming) + cycle 211 (file path IS import path) + cycle 220 (deterministic address IS the route) + cycle 224 (formula ID IS bearer token) + cycle 227 (immutableArrayBufferPrototype IS the discriminator).

## §string.js — §don't-coerce-input + §env-option-gated-strictness

```js
export const isWellFormedString = hasWellFormedStringMethod
  ? str => typeof str === 'string' && str.isWellFormed()
  : str => {
      if (typeof str !== 'string') {
        return false;
      }
      // ... polyfill iteration ...
    };
```

§Don't-coerce-input — the standard `String.prototype.isWellFormed` §coerces-non-strings-to-strings before checking. §This-package-doesn't-want-that-behavior. The comment:

> Unfortunately, the standard built-in `String.prototype.isWellFormed` does a ToString on its input, causing it to judge non-strings to be well-formed strings if they coerce to a well-formed strings. This recapitulates the mistake in having the global `isNaN` coerce its inputs, causing it to judge non-string to be NaN if they coerce to NaN.

§Borrowable-pattern: §wrap-the-platform-method-with-an-explicit-typeof-check + §explain-why-in-the-comment + §cite-the-isNaN-precedent. §The-coercion-is-the-mistake; §this-package-fixes-it-by-pre-checking-typeof.

§Three-different-shapes-for-don't-coerce-input in library:
- Cycle 142 @endo/pass-style/passStyle-helpers: §isPrimitive's-safer-but-slower-on-XS trade-off (`Object(val) !== val` would be safer but expensive).
- Cycle 227 pass-style/string: §pre-typeof-check-before-platform-method.
- (any other?)

§Borrowable-pattern: §when-the-platform-method-coerces, §guard-it-with-typeof-check.

### §env-option-gated-strictness

```js
const ONLY_WELL_FORMED_STRINGS_PASSABLE =
  getEnvironmentOption('ONLY_WELL_FORMED_STRINGS_PASSABLE', 'disabled', [
    'enabled',
  ]) === 'enabled';

export const assertPassableString = str => {
  typeof str === 'string' || Fail`Expected string ${str}`;
  !ONLY_WELL_FORMED_STRINGS_PASSABLE || assertWellFormedString(str);
};
```

§Env-option-gates-additional-strictness. §The-default-is-disabled because §we-do-not-yet-know-the-performance-impact. §Two-modes-with-explicit-future-plan:

> Currently, `ONLY_WELL_FORMED_STRINGS_PASSABLE` defaults to `'disabled'` because we do not yet know the performance impact. Later, if we decide we can afford it, we'll first change the default to `'enabled'` and ultimately remove the switch altogether. Be prepared for these changes.

§Borrowable-pattern: §env-option-gated-strictness with §named-three-phase-plan (default-disabled → default-enabled → switch-removed). §The-comment-tells-the-consumer-what-to-expect-over-time.

§Sibling to cycle 130 message-breakpoints.js's §env-option-yields-undefined-when-unset (cycle 130's env-option is feature-presence; cycle 227's env-option is strictness-mode). §Two-different-purposes-for-env-options.

§Three-cycles-on-env-option-gated-features now:
- Cycle 130 message-breakpoints.js: feature-presence + zero-cost-when-unset.
- Cycle 217 @endo/errors: load-bearing-comment-out-lines (similar shape — disabled by default).
- Cycle 227 pass-style/string: strictness-mode with named-three-phase-plan.

§Three-different-shapes-for-env-option-controlled-features.

## §iter-helpers.js — §mapIterable + §filterIterable (lazy iterator utilities)

```js
export const mapIterable = (baseIterable, func) =>
  Far('mapped iterable', {
    [Symbol.iterator]: () => {
      const baseIterator = baseIterable[Symbol.iterator]();
      return Far('mapped iterator', {
        next: () => {
          const { value: baseValue, done } = baseIterator.next();
          const value = done ? baseValue : func(baseValue);
          return harden({ value, done: !!done });
        },
      });
    },
  });
```

§Lazy-iterator-utilities: §map and §filter that return Far-wrapped iterables + iterators. §The-Far-wrapping makes them §pass-style-valid (they're remotables).

§Borrowable-pattern: §lazy-iterator-utility-that-returns-Far-wrapped-objects to be §pass-style-passable. §Sibling to cycle 213 stream-node's §self-referential-asyncIterator (both designs §iterator-as-pass-style-object).

§done ? baseValue : func(baseValue) — §the-completion-value-is-passed-through-not-transformed. §Borrowable-pattern: §the-completion-value-of-an-iterator-is-not-a-mapped-value; §don't-transform-the-completion-value.

§!!done — §boolean-coerce-the-done-flag to ensure the result is always strictly boolean. §Borrowable-pattern: §the-IteratorResult-protocol-says-done-is-boolean + §coerce-explicitly-to-avoid-leaking-undefined-or-other-values.

## §makeTagged.js (31 lines)

```js
import { confirmTagRecord } from './passStyle-helpers.js';

export const makeTagged = (tag, payload) => {
  // ... assertions ...
  return harden({
    [PASS_STYLE]: 'tagged',
    [Symbol.toStringTag]: tag,
    payload,
  });
};
```

§The-tagged-pass-style-constructor — pairs with cycle 227's tagged.js (the validator). §The-constructor-creates-a-valid-tagged-record + §the-validator-checks-it-can-be-trusted.

§Borrowable-pattern: §pair-the-constructor-with-the-validator in adjacent files; §the-constructor-is-the-trusted-path; §the-validator-is-the-untrusted-path.

§Sibling to cycle 136 make-far.js's §three-piece-prefix-handling-discipline — both designs §the-constructor-produces + §the-validator-checks.

## §The-pass-style-helper-cluster as completion of cycle 71's passStyleOf

Cycle 71 (passStyleOf.js) is the dispatcher; cycle 227 ingests the helpers it dispatches to. §The-pair-now-complete:
- Cycle 71: §passStyleOf-dispatcher (the central classification function).
- Cycle 227: §the-helpers (one file per pass-style kind).

§Borrowable-pattern: §central-dispatcher + §uniform-shape-of-handlers-per-case. §The-handlers-live-in-separate-files + §each-handler-implements-the-same-interface + §the-dispatcher-just-looks-up-the-right-handler.

§Sibling to cycle 221 @endo/bundle-source's §format-dispatch-with-lazy-loading — both designs §central-dispatcher + §per-case-handlers; cycle 221 lazy-loads handlers; cycle 227 imports them statically.

## §pass-style-cluster-membership

Eight pass-style files now in library:

| Cycle | File | Role |
|-------|------|------|
| 71 | passStyleOf.js | Central dispatcher |
| 87 | error.js | Error pass-style helper |
| 134 | remotable.js | Remotable pass-style predicate |
| 136 | make-far.js | Far constructor |
| 138 | safe-promise.js | Safe-promise predicate |
| 140 | deeplyFulfilled.js | Deep Promise.all for Passables |
| 142 | passStyle-helpers.js | Foundational helpers (PASS_STYLE symbol, etc.) |
| 148 | symbol.js | Hilbert-Hotel encoding for symbols |
| 150 | typeGuards.js | Four predicate-assertion pairs + Atom subset |
| 227 | byteArray + copyArray + copyRecord + tagged + iter-helpers + string + makeTagged | Helpers cluster |

§The-pass-style-package-is-now-comprehensively-ingested. §Tenth-and-eleventh-...-fifteenth-cycle on @endo/pass-style.

## §Twenty-third-honest-design-evolution-record family member

§A-new-shape: §cluster-of-source-code-files-with-uniform-PassStyleHelper-shape — §parallel-to-cycle-226's-cluster-of-design-documents but at the §code-substrate.

§Eight-different-shapes-of-design-evolution-record across cycles:
| Cycle | Shape |
|-------|-------|
| 199 | §three-tight-utilities (small @endo packages with shared discipline) |
| 211 | §ten-utility-files in one package |
| 214 | §within-document self-correcting prose |
| 216 | §parent-Complete + §child-Not-Started extraction via Predecessor section |
| 218 | §sibling-Ready + §this-Not-Started via two-part Status |
| 220 | §three-state-Status + §design-deviations-section |
| 222 | §Parent-pointer-as-explicit-frontmatter-field |
| 224 | §Status-Complete-with-explicit-Design-deviations-None-significant |
| 226 | §six-Parent-pointer-children-sharing-a-template (design-document cluster) |
| 227 | §uniform-PassStyleHelper-shape-across-pass-style-kind-files (code-file cluster) |

§Two-cluster-shapes-now-paired: cycle 226 (design-documents) + cycle 227 (code-files).

## Related material in the library

- **cycle 71 passStyleOf.js**: §the-central-dispatcher that calls each helper's confirmCanBeValid + assertRestValid.
- **cycle 87 error.js**: §error pass-style helper (already ingested; sibling of cycle 227's helpers).
- **cycles 134 + 136 + 138 + 140 + 142 + 148 + 150**: §the-pass-style-package other source files already ingested.
- **cycle 201 @endo/immutable-arraybuffer**: §the-Immutable-ArrayBuffer-shim that cycle 227's byteArray.js feature-tests for.
- **cycle 217 @endo/errors**: §Rejector-typedef + §rename-utilities-split-from-assertions (cycle 227 uses both).
- **cycle 215 @endo/hex**: §Reflect.apply-as-the-defensive-uncurry sibling (cycle 227 byteArray uses it for immutableGetter).
- **cycle 226 endoclaw six-design-cluster**: §parallel-cluster-shape — design-documents with shared template (cycle 226) + code-files with shared template (cycle 227).
- **cycle 130 message-breakpoints + cycle 217 @endo/errors + cycle 227 string.js**: §three-cycles-on-env-option-controlled-features.
- **cycle 199 trampoline-memoize-nat trio + cycle 211 @endo/common + cycle 227 pass-style helpers**: §three-cycles-of-code-file-clusters-with-shared-template.

## §Library-reaches-733-sections at cycle 227 (chat-lane @endo/pass-style helpers cluster).

## §Sixty-first consecutive designs-chat alternation cycles 166-227.

## §Three-cycles-of-code-file-clusters-with-shared-template

| Cycle | Files | Shared discipline |
|-------|-------|-------------------|
| 199 | trampoline + memoize + nat | §tight-utility-with-classic-uncurry |
| 211 | @endo/common ten files | §one-export-per-file + §tree-shaking-friendly |
| 227 | pass-style four helpers | §PassStyleHelper-uniform-shape (styleName + confirmCanBeValid + assertRestValid) |

§Three-different-shared-disciplines + §three-different-purposes-for-the-cluster-shape.
