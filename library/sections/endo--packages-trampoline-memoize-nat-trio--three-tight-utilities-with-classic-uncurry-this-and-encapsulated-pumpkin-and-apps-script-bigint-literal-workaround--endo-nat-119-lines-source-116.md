---
title: "@endo/nat (119 lines source + 116 README) — §Apps-Script-workaround + §two-different-error-types"
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
parent: endo--packages-trampoline-memoize-nat-trio--three-tight-utilities-with-classic-uncurry-this-and-encapsulated-pumpkin-and-apps-script-bigint-literal-workaround
---

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
