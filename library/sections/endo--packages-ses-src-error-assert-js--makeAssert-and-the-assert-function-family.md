---
title: The `makeAssert` factory that takes an optional `optRaise` callback (the *escalate-before-throw* hook) and an `unredacted` flag and produces a complete assert function family; the `fail` function that builds an error via `makeError`, optionally raises it through `optRaise`, then throws; the `Fail` template tag that is the *one-line-throwing-template-literal* shortcut (`x === 5 \|\| Fail\`got ${x}\``); the base `assert(condition, optDetails, errConstructor, options)` that short-circuits on truthy via the *||-fail* idiom; the `assert.equal` function paired with `Object.is`-style equality, defaulting `RangeError` for type-coherence with the spec's Range-Error-for-numeric-out-of-bounds discipline; the `assertTypeof` function that uses the `an(typename)` article-agreement helper to render `must be a string` / `must be an object`; the `assert.string` convenience shortcut; the assignment-and-freeze finishing pattern (`assign(assert, ...assertionFunctions, ...assertionUtilities, ...deprecated)`); the module-level `export const assert = makeAssert()`; the re-exports (`X`, `q`, `b`, `annotateError`, `assertEqual`, `makeError`) that name the assert surface for non-`assert.foo`-style consumers
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson]
source_lines: "479-604 (makeAssert + fail + Fail + assert + equal + assertTypeof + assertString + assertion bundles + module-level exports)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The *user-facing surface* of SES's assert module. The §makeAssert
  factory takes an optional `optRaise` callback that escalates-then-
  throws (used by `assertChecker` patterns where the caller wants to
  log or break before the throw propagates), and an `unredacted` flag
  that selects between `redactedDetails` and `unredactedDetails`. The
  produced `assert` function is callable as `assert(cond, X\`msg\`)`
  using the standard *||-fail* short-circuit idiom; carries `equal`,
  `typeof`, `string`, `fail`, `note`, `details`, `Fail`, `quote`,
  `bare`, `makeError`, `makeAssert` as methods; and is frozen via
  `assign(assert, ...) && freeze(...)`. The §Fail template-tag
  shortcut is the maintainer's preferred *one-line-throwing-
  template-literal* idiom — `x === 5 \|\| Fail\`got ${x}\`` reads as
  prose-with-substitution. The module's last action is `export const
  assert = makeAssert()` — the canonical pre-built assert that the
  rest of the codebase imports.
---

## Abstract

The §makeAssert factory (lines 484-584) takes two optional parameters: `optRaise` (a callback invoked on the error *before* it is thrown — typically used for `console.error`-style escalation, breakpoints, or causal-console flushing) and `unredacted` (a flag that selects `unredactedDetails` for the `details` bound inside this assert's templates). The §fail function builds an error via `makeError`, calls `optRaise(reason)` if provided, then throws the error. The §Fail template tag is the *one-line-throwing-template-literal* shortcut: `cond || Fail\`got ${value}\`` reads as `cond, or fail with this prose-with-substitution`. The §base assert function uses the standard JavaScript *||-fail* short-circuit idiom: `condition || fail(...)`. The §assert.equal function uses `Object.is`-style equality (imported as `is`) and defaults `RangeError` as the constructor (consistent with the standard's *out-of-range numeric values throw RangeError* discipline, generalized to *not-the-expected-value*). The §assertTypeof function dispatches on `typeof specimen === typename` and uses the §an(typename) article-agreement helper (imported from a sibling module) to render *must be a string* / *must be an object* / *must be an undefined*. The §assertString is a one-line convenience shortcut: `assertTypeof(specimen, 'string', optDetails)`. The §finalizing pattern: `assign(assert, {...assertionFunctions, ...assertionUtilities, ...deprecated})` and `freeze(finishedAssert)`. The §module-level `assert = makeAssert()` produces *the canonical assert* that the rest of @endo imports; the assert re-exports `X` (`= redactedDetails`), `q` (`= quote`), `b` (`= bare`), `annotateError` (`= note`), `assertEqual` (`= assert.equal`), and `makeError` for non-`assert.foo`-style consumers.

## Body

### §makeAssert — the factory's two parameters

The §makeAssert signature (line 484):

```js
export const makeAssert = (optRaise = undefined, unredacted = false) => {
```

The §two parameters:

- **`optRaise`** — a callback `(reason: Error) => void` that is invoked on the constructed error *before the throw*. The §use cases:
  - **Causal-console flushing**: the raise callback can immediately render the error to the console before throwing, so the log captures the error even if downstream code swallows it.
  - **Breakpoint affordance**: a maintainer can set `makeAssert(err => debugger)` to break on every assert failure.
  - **Test-failure escalation**: a test framework can `makeAssert(err => testFailureRecord.push(err))` to capture all assert failures without relying on uncaught-exception handlers.
- **`unredacted`** — a boolean that selects `unredactedDetails` (for `errorTaming: 'unsafe'` mode) over `redactedDetails`. The §discipline: when this assert is built under unsafe mode, every substitution in every template is automatically quoted, so the rendered messages show actual values.

The §destructured binding (line 485):

```js
const details = unredacted ? unredactedDetails : redactedDetails;
```

The §`details` symbol bound inside the factory captures which variant the templates will use. The factory's `Fail`, `fail`, `equal`, `assertTypeof` all reference `details`, so a single flag at factory-construction time controls all assertions' rendering.

The §`assertFailedDetails` (line 486):

```js
const assertFailedDetails = details`Check failed`;
```

This is the *default details for an assert with no specific message*. The constant captures it once at factory time so every default-message assert points to the same details-token.

### §fail — build, optionally raise, throw

The §fail function (lines 488-500):

```js
const fail = (
  optDetails = assertFailedDetails,
  errConstructor = undefined,
  options = undefined,
) => {
  const reason = makeError(optDetails, errConstructor, options);
  if (optRaise !== undefined) {
    optRaise(reason);
  }
  throw reason;
};
freeze(fail);
```

The §three-step trip:

1. **Build the error** via `makeError(optDetails, errConstructor, options)`. The constructor defaults to `globalThis.Error`; the options (cause/errors/errorName/sanitize) flow through.
2. **Optionally raise** before throw. If `optRaise` was provided at factory time, call it with the error. The callback may inspect, log, or breakpoint on the error.
3. **Throw the error**. The throw propagates up the call stack; if `optRaise` already logged/broke, the throw continues normally.

The §two-step *raise-then-throw* discipline is the *honest-broadcast-before-propagation* pattern: the raise gives interested listeners a chance to observe the error *while the rest of the program is still running normally*. If `optRaise` itself throws (e.g., from a buggy callback), the new throw propagates and `reason` is lost; this is *fail-fast* on raise-handler bugs.

### §Fail — the one-line-throwing-template-literal shortcut

The §Fail tag (line 503):

```js
const Fail = (template, ...args) => fail(details(template, ...args));
```

The §usage pattern (the *||-Fail* idiom):

```js
cond || Fail`got ${value}`;
```

The §structural reading:

- **`cond`** is the assertion (truthy means assertion holds).
- **`||`** short-circuits: if `cond` is truthy, the right-hand-side is never evaluated.
- **`Fail\`got ${value}\``** is the tagged-template invocation; when reached, it calls `details(template, ...args)` (constructs a details-token) and then `fail(...)` which throws.

The §design intent: this is *the most concise* way to write a one-line conditional throw with formatted message. Reading the source aloud: *cond, or Fail got value*. The verb form *Fail* makes the failure clause grammatical English.

The §contrast with `assert(cond, X\`got ${value}\`)`:

- `assert(...)` is a function call — the message-details are computed before the call (eagerly), even if `cond` is truthy.
- `cond || Fail\`...\`` is short-circuited — the template-tag is invoked only on failure.

The §choice between them: for hot paths where the message-template is non-trivial to compute, the `||`-Fail form avoids the per-call cost. For ordinary assertions, both forms are equivalent. The maintainer chooses based on hot-vs-cold and aesthetic preference.

### §The base assert function — the *||-fail* short-circuit

The §assert function (lines 505-514):

```js
const assert = (
  condition,
  optDetails = undefined,
  errConstructor = undefined,
  options = undefined,
) => {
  condition || fail(optDetails, errConstructor, options);
};
```

The §body is *one line*: `condition || fail(...)`. The §JavaScript expression evaluates as: *if condition is truthy, the expression result is condition (and discarded); otherwise, call fail (which throws)*.

The §undefined-detail default: if no optDetails is provided, `fail` uses its own default (`assertFailedDetails = details\`Check failed\``). So `assert(cond)` throws `Error: Check failed` if `cond` is falsy.

The §design intent: the assert function is *callable like a function*, but the body uses the short-circuit idiom for performance. Reading the source: *assert(cond, msg)* is equivalent to *if (!cond) throw makeError(msg)*; the short-circuit form lets a JIT inline the cond check.

The §non-export at this point (line 505 comment: *Don't freeze or export `assert` until we add methods*): the function is later augmented via `assign(assert, ...)` before being frozen and returned.

### §assert.equal — `Object.is` equality with `RangeError` default

The §equal function (lines 516-531):

```js
const equal = (
  actual,
  expected,
  optDetails = undefined,
  errConstructor = undefined,
  options = undefined,
) => {
  is(actual, expected) ||
    fail(
      optDetails || details`Expected ${actual} is same as ${expected}`,
      errConstructor || RangeError,
      options,
    );
};
freeze(equal);
```

The §three structural choices:

- **`is(actual, expected)`** is `Object.is`. Differs from `===` on `NaN === NaN` (false vs true) and `+0 === -0` (true vs false). The *value-equality* semantics that match the maintainer's intuition for *the same value*.
- **Default details `Expected ${actual} is same as ${expected}`**. The §template uses *is same as* not *equals* — the *Object.is* semantics is *same as* not *equal to*. This is the *prose-matches-semantics* discipline.
- **Default constructor `RangeError`**. The standard's discipline: `RangeError` is thrown for *out-of-range numeric values* (e.g., `new Array(-1)`). Generalized to assert.equal: *the actual value is out-of-the-expected-range-of-one-value*. Non-equality is treated as a *range* violation.

The §maintainer's choice of `RangeError` over the default `Error` reflects the *honest-type-information* discipline: an error with `name: 'RangeError'` tells the catch-clause that this is a *bounds* violation, not a *generic* failure. A catch clause can `if (err instanceof RangeError) { ... }` to selectively handle equality failures.

### §assertTypeof — typeof check with `an()` article agreement

The §assertTypeof function (lines 533-550):

```js
const assertTypeof = (specimen, typename, optDetails) => {
  if (typeof specimen === typename) {
    return;
  }
  typeof typename === 'string' || Fail`${quote(typename)} must be a string`;

  if (optDetails === undefined) {
    const typeWithDeterminer = an(typename);
    optDetails = details`${specimen} must be ${bare(typeWithDeterminer)}`;
  }
  fail(optDetails, TypeError);
};
freeze(assertTypeof);
```

The §three-stage check:

1. **Happy path: typeof match** → return silently.
2. **Input-validation: typename must be a string** → the *recursive-assertion* idiom; if the caller passed something other than a string as typename, `Fail\`${quote(typename)} must be a string\`` throws.
3. **Default details with `an(typename)` article-agreement** → if no explicit details, build `${specimen} must be ${bare(typeWithDeterminer)}`. The `an()` helper (imported from a sibling module) returns `a string`, `an object`, `an undefined`, etc. The `bare(...)` wrapper around `typeWithDeterminer` ensures the type-phrase is rendered verbatim (without JSON-quoting), since the phrase matches the `canBeBare` regex (only letters and spaces).

The §constructor choice: `TypeError`. The standard's discipline: `TypeError` is thrown for *type-mismatch on an operand*. assert.typeof is *literally* a typeof check; if it fails, it's a TypeError.

The §rendered example: `assert.typeof(42, 'string')` throws `TypeError: (a number) must be a string` (with redacted substitution for `42`).

The §recursive-assertion idiom (line 541) — `typeof typename === 'string' || Fail\`${quote(typename)} must be a string\`` — is itself an assert; if a caller writes `assert.typeof(x, 42)`, the recursive assert catches the broken call before the meaningless `typeof x === 42` check could falsely pass.

### §assertString — the one-line convenience

The §assertString function (lines 552-554):

```js
const assertString = (specimen, optDetails = undefined) =>
  assertTypeof(specimen, 'string', optDetails);
```

The §design intent: `assert.string(x)` is a frequent enough call that having a dedicated convenience makes the call-site read cleanly. Without it, every string-typecheck would be `assert.typeof(x, 'string')`.

The §absence of `assert.number`, `assert.object`, etc.: the maintainer's choice was to expose only `assert.string` as a convenience. Other typeof assertions go through the general `assert.typeof`. The asymmetry is honest about the call-site frequency: strings are the most common type-asserted value (because so much JavaScript treats every non-string as a coerce-to-string).

### §The finalizing assign-and-freeze pattern

The §three bundles (lines 556-575):

```js
const assertionFunctions = {
  equal,
  typeof: assertTypeof,
  string: assertString,
  fail,
};

const assertionUtilities = {
  makeError,
  note,
  details,
  Fail,
  quote,
  bare,
};

const deprecated = { error: makeError, makeAssert };
```

The §three-bag structure:

- **`assertionFunctions`** — the methods that *behave like assertions* (i.e., they throw on failure). These are typed as `AssertionFunctions` in TypeScript.
- **`assertionUtilities`** — the methods that *build assert artifacts* without themselves throwing. Most users use `details` and `Fail` through these.
- **`deprecated`** — `error` (was the old name for `makeError`) and `makeAssert` (mostly used internally; surfaced on assert for backward compatibility).

The §assign-and-freeze (lines 577-583):

```js
const finishedAssert = assign(assert, {
  ...assertionFunctions,
  ...assertionUtilities,
  ...deprecated,
});
return freeze(finishedAssert);
```

The §pattern:

1. **`assign`** mutates `assert` (the base function) to add the bundled methods.
2. **Spread-in-order** — assertionFunctions, then utilities, then deprecated. If a key collides, the later overrides; the order is *new-canonical-over-deprecated*.
3. **Freeze** the function-with-methods. After freeze, no method can be replaced; the assert is *value-typed* — passing it across compartment boundaries doesn't risk mutation.
4. **Return** the frozen assert.

### §The module-level `assert = makeAssert()` and re-exports

The §module-level assert (lines 587-589):

```js
const assert = makeAssert();
export { assert };
```

The §canonical assert: *no optRaise, redacted mode*. This is what every @endo and SES module imports. The §choice not to expose `optRaise` at module-level reflects the discipline: the canonical assert is *quiet* — failure throws, period, no escalation. Code that wants `optRaise` builds its own assert via `makeAssert(myRaise)`.

The §re-exports (lines 591-604):

```js
const assertEqual = assert.equal;

export {
  assertEqual,
  makeError,
  note as annotateError,
  redactedDetails as X,
  quote as q,
  bare as b,
};
```

The §rename intents:

- **`X`** — the *one-letter mnemonic* for `redactedDetails`. The mnemonic reads aloud as *X-template-tag*; it is the assert module's signature surface.
- **`q`** — `quote`. The shortest possible name for the most-common substitution wrapper.
- **`b`** — `bare`. Similarly short.
- **`annotateError`** — `note`. The full-word version for code that prefers self-documenting names.
- **`assertEqual`** — `assert.equal` as a direct binding. The §comment (lines 591-593):

  > Internal, to obviate polymorphic dispatch, but may become rigorously consistent with `@endo/error`:

  The §reasoning: code that does *many* equality checks per second can avoid the `.equal` property lookup by binding `assertEqual` directly. The comment is honest about the cross-module forward-compatibility consideration with `@endo/error`.

- **`makeError`** — direct binding for code that *builds* errors without throwing them (e.g., to package them as promise rejections or return values).

The §re-exports give the assert surface *multiple-name-affordances*: maintainers can use `assert.fail(X\`msg\`)` or `Fail\`msg\`` or `throw makeError(X\`msg\`)` depending on which idiom reads most clearly for the call-site. The module is *deliberately surface-rich* because the cost of an extra export is one line and the call-site readability gain compounds across the codebase.

## Connection to the wider library

This section is the **canonical *factory-produces-callable-with-methods-frozen* worked example**. Three threads:

1. **The `makeAssert` factory with `optRaise` parameter** is reusable for any *substrate-callback-before-trip* pattern. The error is built, the substrate is given a chance to observe/escalate, then the trip happens. Test frameworks, debuggers, and causal-console flushing all use this hook.

2. **The `Fail` template-tag idiom** is the canonical *one-line-throwing-template-literal* shortcut. The `cond || Fail\`...\`` pattern reads as prose-with-substitution and short-circuits the template-tag cost on the happy path.

3. **The three-bag assertionFunctions / assertionUtilities / deprecated structure** is the canonical *evolve-without-breaking-callers* discipline. New canonical names go in the first two bags; old names live in `deprecated` so existing code keeps working.

The §makeAssert design also embodies the *factory-vs-canonical-instance* split: the canonical `assert` (zero-config) is exported as the standard import; the factory `makeAssert` is exposed for niche use cases (custom raise, unredacted mode).

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `condition || fail(...)` | The standard *||-fail* short-circuit idiom; truthy means assertion holds. |
| `cond || Fail\`got ${value}\`` | The one-line-throwing-template-literal shortcut; reads as prose-with-substitution. |
| `Don't freeze or export assert until we add methods.` | The *augment-then-freeze* discipline; mutate the base, attach methods, freeze the composite. |
| `Object.is` (imported as `is`) | The value-equality semantics that differs from `===` on NaN and ±0. |
| `errConstructor || RangeError` (default for assert.equal) | The honest-type-information discipline; RangeError signals *not-the-expected-value*. |
| `typeof typename === 'string' \|\| Fail\`...\`` | The recursive-assertion idiom; assert.typeof asserts its own typename argument. |
| `an(typename)` article-agreement | The *a-vs-an-article-by-first-phoneme* helper; produces grammatically correct *a string* / *an object*. |
| `bare(typeWithDeterminer)` | Use bare for the type-phrase since it matches `canBeBare` regex; render verbatim without JSON-quoting. |
| `X`, `q`, `b` re-exports | One-letter mnemonics for high-frequency call-site idioms; substitute readability for length. |
| `Internal, to obviate polymorphic dispatch` | The honest-perf-optimization comment; direct binding avoids `.equal` property lookup in hot paths. |
| `assign(assert, {...funcs, ...utilities, ...deprecated})` | The *new-canonical-over-deprecated* spread-order discipline; later spreads win on key collision. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate; this assert module's exports are imported by every @endo and SES module.
- [[errors]] (topic) — the broader SES error-handling system; this section is the user-facing surface that builds and throws the errors.
- `endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details` — the redaction-discipline section; the `details`/`quote`/`bare`/`Fail` primitives this section composes.
- `endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler` — the rendering-machinery section; `makeError` and `note` that this section's `fail` and `Fail` produce errors through.
- `endo--packages-ses-src-error-console-js--*` (cycle 96) — the causal-console that renders errors; an `optRaise` callback can be wired to flush to the console before throw.
- `endo--packages-pass-style-src-error-js--*` (cycle 87) — pass-style's error-validation surface; errors thrown by `fail` flow through pass-style on cross-compartment passage.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — produces causal annotations; the `note` re-exported here as `annotateError` is the surface that track-turns annotates through.

## Common confusions

- **"`assert(cond, X\`msg\`)` and `cond || Fail\`msg\`` are different."** They are equivalent in success cases (both no-op on truthy cond). On failure: `assert(...)` evaluates the template before the call (slight perf cost on the cold path); `Fail\`...\`` invokes the template-tag only on failure. For hot paths, prefer `||`-Fail; for ordinary asserts, either works.
- **"`assert.equal` defaults to `RangeError` — that's wrong."** It is intentional. The standard's `RangeError` is for *out-of-range-of-an-expected-set-of-values*. assert.equal is *out-of-the-expected-set-of-one-value*. A catch clause can selectively handle `instanceof RangeError` for equality failures. The maintainer's choice surfaces type information at the throw.
- **"`assert.typeof(x, 42)` should throw earlier."** It does — via the recursive `typeof typename === 'string' || Fail\`...\`` line. The recursive assert catches the bad call before the meaningless `typeof x === 42` (which would always be `false` since `typeof` returns a string).
- **"`an()` is dead-code for English-only."** It produces grammatically-correct articles in *English*. The output is technically locale-specific, but the maintainer's choice was to keep error messages in English for diagnostic consistency across deployments. Localized error messages are out of scope.
- **"`X`, `q`, `b` are unreadable one-letter exports."** They are *intentional mnemonics* for high-frequency call-site idioms. A typical assert line reads `cond || Fail\`got ${q(x)} expected ${q(y)}\`` — using full names would make the call-site noisy. The README and JSDoc compensate with full documentation; the call-sites get terse.
- **"`makeAssert` re-exposing `optRaise` is a security hole."** It is — *if a malicious party can construct a custom assert and hand it to code that expects the canonical one*. The discipline: the canonical `assert` is the module's main export and is the one most code imports; custom asserts via `makeAssert` are *opt-in* and the caller chooses to trust their own raise hook.
- **"`deprecated.error = makeError` is dead code."** It is *deliberate backwards-compatibility*. Old code wrote `assert.error(X\`msg\`)` to build (not throw) an error; the canonical name is now `makeError` but the old name still works. The deprecated bag is for these graceful renames.
- **"`assertEqual = assert.equal` is just a perf hack."** It is — and *honestly named*. The comment says *Internal, to obviate polymorphic dispatch*. The maintainer didn't hide the optimization; they documented it. Reading the source one understands both *what the line does* and *why it exists*.
