---
title: Three-tight-utilities cluster — @endo/trampoline + @endo/memoize + @endo/nat — §classic-uncurry-this-via-bind.bind(bind.call) + §encapsulated-pumpkin-sentinel for recursion + §four-tier-safety-hierarchy + §Apps-Script-bigint-literal-workaround + §two-different-error-types-for-type-vs-range
source: endo packages/{trampoline,memoize,nat}/{src/*.js,README.md,docs/memoize.md}
source-slug: endo--packages-trampoline-memoize-nat-trio
ingest-cycle: 199
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal, Endo contributors]
related:
  - endo--packages-base64 (cycle 181: §three-tier-dispatch + §Reflect.apply capture sibling)
  - endo--packages-cli-src-utility-cluster (cycle 195: §six-tight-utilities-with-no-internal-dependencies sibling)
  - endo--packages-panic (cycle 197: §Eval-Twin-Problem cross-reference; memoize.md cites endojs/endo#1583)
  - endo--packages-pass-style (cycle 71+: passStyleOf is the §canonical-memoize-user named in memoize.md)
keywords:
  - three-tight-utilities cluster
  - classic-uncurry-this via bind.bind(bind.call)
  - encapsulated-pumpkin sentinel for recursion-protection
  - contingent-safety framing
  - four-tier safety hierarchy (defensiveness / unobservable / preserves-isolation / not-communications-channel)
  - sync/async two-color sharing via generator trampoline
  - generator-throw send-error-into-generator
  - Apps-Script-bigint-literal-workaround
  - two-different-error-types (TypeError type / RangeError range)
  - safely-representable IEEE-754 integer discipline
  - freeze-as-harden-substitute pending PR #3008
---

# @endo/{trampoline,memoize,nat} trio — §three-tight-utilities cluster

## Source

- `endo packages/trampoline/src/trampoline.js` — 59 lines + `types.d.ts` 24 lines + `README.md` 101 lines (sync + async generator-based trampolining)
- `endo packages/memoize/src/memoize.js` — 54 lines + `README.md` 76 lines + `docs/memoize.md` 176 lines (memoize with encapsulated-pumpkin recursion-protection)
- `endo packages/nat/src/index.js` — 119 lines + `README.md` 116 lines (isNat predicate + Nat assertion; ZERO_N + ONE_N bigint constants)

Cycle 199 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 198's designs-lane patterns-diagnostic-feedback; §thirty-third consecutive designs/chat alternation cycle 166-199).

§Eighteenth-member of §small-files-with-large-knowledge-density family (cycles 165 + 167 + 169 + 171 + 173 + 175 + 177 + 179 + 181 + 183 + 185 + 187 + 189 + 191 + 193 + 195 + 197 + 199).

## Single most structurally interesting move

§three-tight-utilities sharing §a-common-dependency-on-harden-or-freeze-substitute but otherwise §no-internal-dependencies (sibling pattern to cycle 195 cli/src cluster). Each utility has its own load-bearing structural move:

- **@endo/trampoline**: §classic-uncurry-this-via-bind.bind(bind.call) (Mark Miller's canonical idiom) + §sync/async-two-color-sharing-via-generator + §try/catch-around-generator-next-calling-generator-throw-to-send-errors-back.
- **@endo/memoize**: §encapsulated-pumpkin-sentinel (`harden({})` that "must not escape this module") for §recursion-through-memoization detection AND §non-weak-key-compat early-error AND §try/catch-deletes-on-fn-throw cleanup, all via the same set-pumpkin-then-detect mechanism + §four-tier-safety-hierarchy in docs/memoize.md (Base / Defensiveness / Unobservable / Preserves-Isolation / Not-Communications-Channel).
- **@endo/nat**: §Apps-Script-bigint-literal-workaround (`BigInt(0)` and `BigInt(1)` not `0n`/`1n`) preserved for `@endo/marshal` and `@endo/ocapn` minimal-dependency aspiration (PR #3008) + §two-different-error-types (TypeError for non-bigint-non-number; RangeError for out-of-range or non-safe-integer) + §`freeze`-as-`harden`-substitute pending PR #3008 with §explicit-honest-deferral-comment.

## @endo/trampoline (59 lines) — §classic-uncurry-this + §sync/async two-color sharing

```js
const { getPrototypeOf } = Object;
const { bind } = Function.prototype;
const uncurryThis = bind.bind(bind.call);
export const { prototype: generatorPrototype } = getPrototypeOf(function* () {});
const generatorNext = uncurryThis(generatorPrototype.next);
const generatorThrow = uncurryThis(generatorPrototype.throw);
```

§The-classic-uncurry-this-idiom: `bind.bind(bind.call)` is the §Mark-Miller-canonical-form. Applied to a method, it produces a function that takes the receiver as the first argument: `generatorNext(iterator)` instead of `iterator.next()`. The §rationale is §protect-against-prototype-tampering — once the original `Function.prototype.bind` is captured pre-lockdown, the uncurried form survives even if the prototype is later replaced.

§Two-step capture:
1. `bind.bind(bind.call)` — produces a function `f` such that `f(method)(receiver, ...args) === method.call(receiver, ...args)`.
2. `uncurryThis(generatorPrototype.next)` returns `generatorNext` such that `generatorNext(iterator, value) === iterator.next(value)`.

§Why-via-the-generator-prototype-not-via-the-iterator-instance: §the-prototype-is-captured-once-at-module-load; §iterator-instances-may-have-been-tampered-with (their `.next` could be overridden per-instance). §The-prototype's-original-`.next`-is-what-the-uncurry-locks-in.

§The-sync/async pair:

```js
export function syncTrampoline(generatorFn, ...args) {
  const iterator = generatorFn(...args);
  let result = generatorNext(iterator);
  while (!result.done) {
    try {
      result = generatorNext(iterator, result.value);
    } catch (err) {
      result = generatorThrow(iterator, err);
    }
  }
  return result.value;
}

export async function asyncTrampoline(generatorFn, ...args) {
  const iterator = generatorFn(...args);
  let result = generatorNext(iterator);
  while (!result.done) {
    try {
      const val = await result.value;
      result = generatorNext(iterator, val);
    } catch (err) {
      result = generatorThrow(iterator, err);
    }
  }
  return result.value;
}
```

§Two-color-sharing: the same generator function body can be driven §synchronously (yielded values used directly) or §asynchronously (yielded values awaited). §The-author-writes-one-generator-function-and-picks-the-trampoline-at-the-call-site. Sibling pattern to Haskell's `IO` monad or Rust's async-trait — §abstract-the-effect-color.

§generator-throw-send-error-into-generator: when `generatorNext` (or the `await` in async case) throws, `generatorThrow(iterator, err)` resumes the generator §at-the-`yield`-with-`throw` rather than `next`. §The-generator-can-catch-the-error-in-a-try/catch-around-the-yield and continue. §Without-this the trampoline would have no way to send errors back into the generator's control flow.

§Two-eslint-discipline-exceptions named:
- `// eslint-disable @endo/no-polymorphic-call` on the `uncurryThis = bind.bind(bind.call)` line.
- `// eslint-disable @jessie.js/safe-await-separator` at file head (for the `const val = await result.value` line; Jessie's rule requires `await` to be a statement-level operation, not embedded in a const-init).

§Both-rules-are-discipline-aware-exceptions — the package's specific need overrides the general rule with the linter exception local to the file.

§JSDoc-generics-and-type-inference: `TrampolineResult<TFn>` extracts the `Generator<any, infer TResult>` return type; `SyncTrampolineResult<TFn>` further narrows by §rejecting if the result is a Promise (sync trampoline can't await). §Type-system-encodes-the-color-asymmetry.

## @endo/memoize (54 lines + 76-line README + 176-line docs/memoize.md) — §encapsulated-pumpkin + §four-tier-safety-hierarchy

### §The encapsulated-pumpkin idiom

```js
/**
 * Must not escape this module.
 */
const encapsulatedPumpkin = harden({});
```

§The-pumpkin-must-not-escape — the comment is §the-honor-system-discipline (the module's authors commit to never returning `encapsulatedPumpkin` from any export). The empty hardened object is §the-canonical-sentinel: §reference-equality-not-content-equality is the discriminator (`memoedResult === encapsulatedPumpkin`).

§Why-`harden({})`-not-`Symbol()`: §a-hardened-empty-object is §a-valid-WeakMap-key (whereas a primitive Symbol might or might not be one depending on engine version) AND §the-§== Symbol === sentinel approach has §Eval-Twin issues (registered symbols are twin-safe but local symbols are not; the pumpkin pattern is local to the module).

### §Three-uses-of-one-sentinel

The same `memo.set(arg, encapsulatedPumpkin)` line plays three roles:

1. **§Recursion-protection**: §`if (memoedResult === encapsulatedPumpkin) throw new TypeError('no recursion through memoization with same arg')` — if the same arg is seen mid-call (the previous call hasn't yet returned), throw.
2. **§Non-weak-key-compat-early-error**: §`memo.set(arg, encapsulatedPumpkin)` throws synchronously if `arg` isn't a valid WeakMap key. §The-error-is-raised-before-`fn`-is-called (so the user sees a WeakMap error not a confusingly-late mismatch later).
3. **§Try/catch-cleanup-on-fn-throw**: §`try { result = fn(arg); } catch (e) { memo.delete(arg); throw e; }` — if `fn` throws, the recursion-protection marker is removed so a later call can retry. §Throws-from-`fn(arg)`-are-not-memoized; §rejected-promises-returned-by-`fn(arg)`-***are***-memoized (the docs make this distinction explicit).

§One-sentinel-three-purposes is §code-density-with-named-effect. §Each-purpose-would-otherwise-require-its-own-check.

### §The four-tier safety hierarchy in docs/memoize.md

The docs distinguish §four-progressively-stronger-safety-properties, each with §a-list-of-named-requirements:

1. **§Base-semantics**: §Hardened-JS-substrate must hold (WeakMap conforms to spec, methods conform). §`lockdown()` makes this §non-violable post-lockdown.
2. **§Defensiveness**: §`fn` must throw on §invalid-WeakMap-keys and §non-memoization-candidates.
3. **§Unobservable-Memoization**: §three-requirements:
   - §`fn` transitively-immutable-and-powerless (no mutable state, no ability to cause effects).
   - §`fn(arg)` must not cause effects on success; §if-`arg`-is-a-proxy-this-is-hard-to-meet.
   - §`fn(arg)` deterministic: always returns the same result for the same arg.
4. **§Preserving-Isolation** (§not-a-communications-channel): §four-requirements, including §determinism-with-fresh-identity-allowance:
   - §fn transitively-immutable-and-powerless.
   - §fn(arg) returns without effects.
   - §result-objects: §transitively-immutable-and-powerless; §equivalent-aside-from-object-identity; §either-always-same-identity-or-fresh-allocation-per-call.

§The-hierarchy-is-monotonic — each tier strengthens the previous. §The-docs-make-clear-that-§"contingent-safety" framing applies because §the-tooling-cannot-check-or-enforce-the-requirements.

### §passStyleOf cited as the canonical memoize-user

> For example, the function `passStyleOf` from the package `@endo/pass-style` internally uses a memo for a huge efficiency gain, but is nevertheless **defensive / unobservable / not a communications channel**.

§The-docs-name-the-flagship-consumer — §passStyleOf-case-splits-and-only-memoizes-its-internal-algorithm-for-the-WeakMap-key-cases. §passStyleOf-itself-is-not-the-memoFn but rather a wrapper that delegates the WeakMap-key case to an internally-memoized helper.

§Cross-reference: cycle 71+ pass-style ingests confirm passStyleOf uses memoization internally. The memoize.md doc §cites-it-as-the-pattern-to-emulate.

### §The Eval-Twin Problem reference

> But because of JavaScript's [Eval Twin](https://github.com/endojs/endo/issues/1583) problem, such a module should also be prepared to be haphazardly duplicated. Ideally, such a module should act in such a way that its haphazard duplication is unobservable, so when the haphazardness of its duplication changes, those changes are not disruptive.

§Sibling-to cycle 197 @endo/panic which §explicitly-cites-#1583. §The-memoize-doc names the §haphazard-duplication-must-be-unobservable design discipline. §When-twin-duplication-changes-it-should-not-be-disruptive.

### §`harden(memoize)` after `harden(memoFn)`

The module ends with `harden(memoize)` (after the inner `harden(memoFn)` inside the returned closure). §Both-the-factory-and-the-products-are-hardened. §Sibling-pattern to cycle 175 harden-selector and other discipline patterns.

## @endo/nat (119 lines source + 116 README) — §Apps-Script-workaround + §two-different-error-types

### §Apps-Script-bigint-literal-workaround

```js
/**
 * Regarding Google Apps Script limitations,
 * [...]
 * > Literal syntax limitation: The shortcut syntax for `BigInt` literals
 * > (e.g., `10n`) is not supported by the script editor's parser,
 * > and will cause a syntax error. You must use the `BigInt()` constructor
 * > with a string argument instead (e.g., `BigInt("10")`).
 * Actually, when a number is accurate, we can use that instead of a string.
 *
 * Endo is not in general trying for compat with Apps Script. But packages that
 * will have minimal dependencies after adapting to
 * https://github.com/endojs/endo/pull/3008
 * might, such as `@endo/marshal` and `@endo/ocapn`.
 */
export const ZERO_N = BigInt(0);
[...]
export const ONE_N = BigInt(1);
```

§The-comment-block-is-duplicated-verbatim above `ZERO_N` and `ONE_N` — §each-export-stands-alone with its own justification. §The-comment-is-six-paragraphs-of-prose explaining §a-two-line-export.

§The-§"actually-when-a-number-is-accurate-we-can-use-that-instead-of-a-string" line is §honest-narrowing — the Apps Script workaround technically wants strings, but `0` and `1` are exact JS numbers so the implementor uses the cleaner `BigInt(0)` form.

§The-§"Endo-is-not-in-general-trying-for-compat-with-Apps-Script" disclaimer prevents §future-readers-from-thinking-Endo-targets-Apps-Script. §The-narrow-targeting-is-explicit: §packages-with-minimal-dependencies (specifically `@endo/marshal` and `@endo/ocapn`) §might-care; §the-rest-of-Endo-does-not.

§Sibling-pattern to cycle 197 @endo/panic's §three-named-future-extensions and cycle 198 patterns-diagnostic-feedback's §future-helpers-named-not-shipped — §nat's-Apps-Script-aspiration is §a-future-portability-target-named-explicitly.

### §`freeze`-as-`harden`-substitute pending PR #3008

```js
/**
 * Use as a standin for `harden` until https://github.com/endojs/endo/pull/3008
 * Since we're only using it on unadorned arrow functions, `freeze` in this
 * case is actually equivalent to `harden`.
 */
const { freeze } = Object;
```

§Explicit-honest-deferral with §named-equivalence-rationale: §`freeze`-is-equivalent-to-`harden`-on-unadorned-arrow-functions because §arrow-functions-have-no-prototype-property (no chain to harden). §The-comment-prevents-a-future-reader-from-changing-this-without-understanding-why-it's-safe.

§Sibling-pattern to cycle 197 panic's §Object.freeze discipline (also a §freeze-but-not-harden where harden isn't available pre-lockdown) and cycle 146 E.js's §freeze-but-not-harden-the-proxy-target.

§The-PR-#3008-reference is §named-future-state: §when-3008-lands-this-code-can-use-`harden`-directly.

### §`isNat` + `Nat` — predicate + assertion pair

```js
export const isNat = allegedNum => {
  if (typeof allegedNum === 'bigint') {
    return allegedNum >= 0;
  }
  if (typeof allegedNum !== 'number') {
    return false;
  }
  return Number.isSafeInteger(allegedNum) && allegedNum >= 0;
};
freeze(isNat);

export const Nat = allegedNum => {
  if (typeof allegedNum === 'bigint') {
    if (allegedNum < ZERO_N) {
      throw RangeError(`${allegedNum} is negative`);
    }
    return allegedNum;
  }
  if (typeof allegedNum === 'number') {
    if (!Number.isSafeInteger(allegedNum)) {
      throw RangeError(`${allegedNum} is not a safe integer`);
    }
    if (allegedNum < 0) {
      throw RangeError(`${allegedNum} is negative`);
    }
    return BigInt(allegedNum);
  }
  throw TypeError(
    `${allegedNum} is a ${typeof allegedNum} but must be a bigint or a number`,
  );
};
freeze(Nat);
```

§Predicate-assertion-pair (sibling pattern to cycle 150's `confirmAtom` / `assertAtom` and cycle 102's checkKey trio). §`isNat`-returns-boolean; §`Nat`-returns-bigint-or-throws.

§Three-distinct-error-conditions named:
1. §Bigint-negative → `RangeError(\`${n} is negative\`)`.
2. §Number-not-safe-integer → `RangeError(\`${n} is not a safe integer\`)`.
3. §Number-negative → `RangeError(\`${n} is negative\`)`.
4. §Neither-bigint-nor-number → `TypeError(\`${n} is a ${typeof n} but must be a bigint or a number\`)`.

§Two-different-error-types-encode-two-different-failure-categories:
- §TypeError = §wrong-kind-of-value (caller passed string/object/undefined/etc).
- §RangeError = §right-kind-wrong-value (caller passed a number/bigint but it failed value-constraint).

§Distinguishing-these is §important-for-callers (a wrong-type error indicates §a-bug-in-the-caller; a range error indicates §a-runtime-value-out-of-domain). §Sibling-pattern to cycle 195 cli/src number-parse's §strict-regex-bigint-parser which throws TypeError, but Nat distinguishes more finely.

§Coercion-to-bigint on-success: §`Nat(5)` → `5n`, §`Nat(5n)` → `5n`. §Consumers-can-rely-on-the-output-type-being-bigint. §Sibling-pattern to cycle 152 Hilbert-Hotel encoding which also has §coerce-on-success.

### §The README explanation of "safely representable"

The README spends §a-skippable-detail paragraph on §IEEE-754-discipline:

> The JavaScript expression `2**70` evaluates to a JS number that exactly represents the mathematical number you expect. However, the JavaScript expression `2**70+1 === 2**70` evaluates to `true` because this JS number is outside the contiguous range of integers that the JS number type can represent *unambiguously*.

§The-contiguous-range is §`-(2**53)` to `2**53`, but §`2**53+1 === 2**53` so §the-safe-range is `-(2**53-1)` to `2**53-1`. §Safe-natural-numbers are `0` to `2**53-1`.

§Bigint-is-inherently-safe — §every-bigint-`>= 0n`-safely-represents-a-natural-number. §The-bigint-input-path is §unambiguously-correct; the §number-input-path requires §safe-integer-check.

§"A-skippable-detail" tag is §explicit-named-skip-marker — §the-author-tells-the-reader-this-is-optional-reading. §Sibling-pattern to cycle 197 panic's §"Details" subsection and the general §progressive-disclosure discipline.

## §Cross-cutting patterns across the trio

### §All-three-import-harden-or-use-freeze-substitute

- **trampoline**: §does-not-harden (no exported functions are hardened in source). Relies on §the-caller-harden-the-trampoline-functions-if-needed. §Subtle-difference from memoize and nat.
- **memoize**: §`import harden from '@endo/harden'`; both `memoFn` and `memoize` are explicitly hardened.
- **nat**: §`const { freeze } = Object` as §harden-substitute; both `isNat` and `Nat` are frozen.

§Three-different-approaches-to-the-same-discipline depending on §where-in-the-loading-order the package sits. §trampoline-as-most-permissive (no harden), §memoize-as-most-defensive (full harden), §nat-as-middle-ground (freeze-as-substitute pending PR).

### §All-three-target-`@endo/marshal`-and/or-`@endo/ocapn`-minimal-dependency

- **trampoline**: used for §sync/async-shared-algorithm patterns; bundle-source uses it.
- **memoize**: §passStyleOf-uses-it (the @endo/marshal substrate).
- **nat**: §`@endo/marshal` and `@endo/ocapn` are named explicitly as the consumers PR #3008 targets.

§Minimal-dependency-discipline is §the-shared-constraint: §each-utility-aims-to-be-loadable-by-marshal-without-pulling-in-the-rest-of-Endo. §The-tiny-package-discipline is §enforced-by-the-marshal-aspiration.

### §All-three-tested-by-the-larger-consumer

- §trampoline: tested in `endo/packages/trampoline/test/` (integration tests)
- §memoize: tested in `endo/packages/memoize/test/` and §implicitly-tested by passStyleOf's test suite
- §nat: tested in `endo/packages/nat/test/`

§Per-package-unit-tests + §integration-tests-via-the-larger-consumers — §sibling to cycle 195 cli/src cluster's §implicitly-tested-by-the-CLI-itself.

## §Borrowable patterns (tier-1)

1. **§classic-uncurry-this-via-bind.bind(bind.call)** for §prototype-tamper-resistant method capture; captures `Function.prototype.bind` once and produces functions that take receiver as first arg.
2. **§capture-the-prototype-not-the-instance** — the original `.next`/`.throw` come from `getPrototypeOf(function*(){})`, not from individual iterator instances.
3. **§sync/async-two-color-sharing-via-generator-trampoline** — write one generator function body, pick the trampoline at call site.
4. **§generator-throw-send-error-into-generator** for §propagating-errors-from-effect-handler-back-into-effect-source.
5. **§eslint-discipline-aware-exceptions** with §file-local-comment for §specific-need-overrides-general-rule.
6. **§encapsulated-pumpkin-sentinel** (`harden({})` that must not escape module) for §recursion-protection AND §non-weak-key-compat-early-error AND §try/catch-cleanup-on-fn-throw — §one-sentinel-three-purposes.
7. **§four-tier-safety-hierarchy** (Base / Defensiveness / Unobservable / Preserves-Isolation / Not-Communications-Channel) for §progressive-disclosure-of-safety-requirements.
8. **§contingent-safety-framing** — name the §if-then-property AND acknowledge §the-tooling-cannot-check-or-enforce.
9. **§throws-not-memoized + §rejected-promises-memoized** distinction — §the-docs-make-this-explicit; consumers must understand both cases.
10. **§passStyleOf-as-cited-flagship-consumer** — name the canonical pattern-emulator so readers know §what-to-look-at-as-the-exemplar.
11. **§Apps-Script-bigint-literal-workaround** as §named-future-portability-target with §explicit-narrowing ("Endo is not in general trying for compat with Apps Script. But packages that will have minimal dependencies might").
12. **§freeze-as-harden-substitute pending PR #3008** with §named-equivalence-rationale (§freeze-is-equivalent-to-harden-on-unadorned-arrow-functions because §arrow-functions-have-no-prototype-property).
13. **§two-different-error-types** (TypeError = wrong-kind; RangeError = right-kind-wrong-value) for §finer-error-classification-helping-callers-distinguish-caller-bug-from-runtime-domain-error.
14. **§predicate-assertion-pair** (`isNat` + `Nat`) — boolean for branching, throwing-with-coercion for assertion.
15. **§coerce-to-bigint-on-success** — even when input is a number, output is bigint for type-uniformity.
16. **§safely-representable-IEEE-754-integer discipline** — `Number.isSafeInteger` for §contiguous-range-guarantee.
17. **§skippable-detail tag** as §explicit-named-skip-marker for §progressive-disclosure-in-prose.
18. **§one-sentinel-three-purposes** as §code-density-with-named-effect.
19. **§comment-block-duplicated-verbatim** above sibling exports — each export stands alone with its own justification (six paragraphs of prose explaining two lines of code).
20. **§harden-the-factory-and-the-products** — both `memoize` and the closure-returned `memoFn` get hardened.

## §Synthesis-target

Slot machine library can §borrow-the-trampoline-pattern for §sync/async-shared-deck-shuffling-algorithm — same algorithm body, two effect colors. §uncurry-this idiom borrowable for any §pre-lockdown-utility that needs §prototype-tamper-resistance.

§Encapsulated-pumpkin-sentinel borrowable for any §self-referential-WeakMap-recursion-protection. §The §one-sentinel-three-purposes shape is §a-template-for-tight-utility-code.

§Four-tier-safety-hierarchy borrowable as §documentation-shape for any §security-sensitive-utility that has multiple property-levels callers might want to rely on. §Contingent-safety-framing is §the-honest-shape when §the-tooling-cannot-check-the-requirements.

§Apps-Script-bigint-literal-workaround is borrowable wherever §minimal-dependency-package-discipline meets §exotic-runtime-target-constraints. §The §"Endo is not in general trying for compat" §explicit-narrowing prevents §scope-creep.

§Two-different-error-types pattern borrowable for §any-validation-function that distinguishes §wrong-kind from §right-kind-wrong-value (§a-bug-in-the-caller vs §a-runtime-domain-error).

§Predicate-assertion-pair (isNat + Nat) borrowable wherever §the-caller-might-want-either-branching-or-asserting. §Coerce-to-bigint-on-success borrowable for §type-uniformity-at-the-output even when input types vary.

## §Cycle 199 meta-observations

§The-thirty-third-consecutive-designs/chat-alternation-cycle 166-199.

§Papers-lane-blocked 93+ consecutive cycles (since cycle ~106).

§Library-reaches-704-sections at cycle 199.

§Eighteenth-member of §small-files-with-large-knowledge-density family (cycles 165-199 chat-lane).

§This-trio is §sibling-cluster to cycle 195 cli/src six-utility cluster — both §multi-file chat-lane ingests with §no-internal-dependencies. §Cycle-199's-trio shares §one-common-discipline (harden-or-freeze-substitute) whereas §cycle-195's-six shared §none. §Tighter-coherence in 199.

§Eval-Twin-Problem cited in this cluster's memoize.md doc, joining cycle 197 panic and the chain referenced in cycle 196 endoclaw. §Three-consecutive-chat-lane-or-designs-cycles-citing-#1583 (197 + 198 indirectly via panic mention + 199) — §the-Eval-Twin-Problem-is-load-bearing-across-the-@endo-substrate.
