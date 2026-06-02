---
title: The *no-special-privilege* prelude paired with the candid acknowledgment that this module holds *top-level mutable state observable to any code that has access to `loggedErrorHandler`*; the *declassifiers* WeakMap that pairs a `quote`/`bare` result with the underlying value it intentionally exposes; the `quote` operator that produces a frozen object whose `toString` invokes `bestEffortStringify`; the `bare` operator that returns its argument verbatim if it matches the `canBeBare` regex `/^[\w:-]( ?[\w:-])*$/` and otherwise falls back to `quote`; the `redactedDetails` template tag (the canonical `X`/`details`) that wraps every substitution into a `DetailsToken` whose `toString` produces *redacted* type-tag forms like `(a TypeError)`; the `unredactedDetails` variant used by `errorTaming: 'unsafe'` that wraps substitutions in `quote` so logged details survive into the rendered message
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson]
source_lines: "1-202 (file header + declassifiers/quote/bare + hiddenDetailsMap + DetailsTokenProto + redactedDetails + unredactedDetails)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The *redaction discipline* surface of SES's assert module. Three
  threads: (1) the *no-special-privilege* prelude that mirrors cycle
  96's console.js prelude, paired with an explicit *but-actually-this-
  one-has-top-level-mutable-state* admission for the `loggedErrorHandler`
  bridge; (2) the *declassifier* discipline — `quote`/`bare` mark
  substitutions whose underlying value is *intentionally exposed* to
  the message rendering, while everything else is *redacted* to a
  type-tag string; (3) the `redactedDetails` (default `X` template
  tag) vs `unredactedDetails` (`errorTaming: 'unsafe'` mode that
  preserves substitution content) split. The §canBeBare regex
  `/^[\w:-]( ?[\w:-])*$/` is the *safe-as-prose* gate: a string
  matches if it contains only word-chars/colons/hyphens with
  optional single-space separators, in which case `bare` returns
  the text directly; otherwise it falls back to `quote`-with-
  bestEffortStringify. The §DetailsTokenProto is structurally a
  *frozen-marker-with-toString* — the `hiddenDetailsMap` WeakMap
  pairs each token with its parts; the token itself carries no own
  properties, so it cannot leak its substitutions accidentally.
---

## Abstract

The §file-header comment block (lines 1-12) opens with the same *no-special-privilege* axiom as cycle 96's `console.js`: *Subject to the conditions and limitations of [the Apache 2.0 license]...*. But unlike `console.js`, the §next lines (lines 6-12) carry a candid admission:

> Note that this module is unusual among the packages in @endo, because it has top-level mutable state, observable to any code that has access to the `loggedErrorHandler`. ... The exposure is intentional: anyone holding `loggedErrorHandler` is, by definition, the logging substrate, and the substrate needs the mutable state to render annotations after the error has been thrown.

This is the §honest-mutable-state-with-narrow-exposure discipline. The §declassifiers WeakMap (lines 65-69) pairs an *opaque marker token* with the underlying value it intentionally exposes; the §quote function (lines 70-80) returns a frozen object whose `toString` invokes `bestEffortStringify(value)`; the §bare function (lines 83-92) returns its argument verbatim if it matches `canBeBare = /^[\w:-]( ?[\w:-])*$/` and otherwise falls back to `quote`. The §canBeBare regex is the *safe-as-prose* gate: a string matches if it contains only word characters, colons, or hyphens with optional single-space separators — the structural intent is *names that look like identifiers or short prose without metacharacters that could be confused with substitutions*. The §hiddenDetailsMap WeakMap (line 95) holds the parts of each details-token outside the token itself, so the token carries no own properties that could leak. The §DetailsTokenProto (lines 111-127) is the prototype of every details-token; its `toString` produces type-tag substitutions like `(a TypeError)` for non-declassified Error arguments. The §redactedDetails template tag (lines 144-178) is the canonical `X` / `details` tag: it captures the literal parts and substitution values, builds a frozen DetailsToken, and stores the parts in the hidden map. The §unredactedDetails template tag (lines 181-202) is the variant used by `errorTaming: 'unsafe'`: it wraps every substitution in `quote` so the substitution's underlying value survives into the rendered message instead of being redacted to a type-tag.

## Body

### §The no-special-privilege prelude with mutable-state admission

The §opening comment block (lines 1-12) carries two structurally connected axioms.

The §first (shared with cycle 96's `console.js`) is the *no-special-privilege* axiom: SES modules should be loadable into hardened compartments without depending on ambient authority. The licensing prelude and the *Subject to the conditions and limitations* phrasing match `console.js` line-for-line.

The §second axiom is *specific to this module*:

> Note that this module is unusual among the packages in @endo, because it has top-level mutable state, observable to any code that has access to the `loggedErrorHandler`.

The structural reading:

- **Top-level mutable state is normally forbidden in hardened compartments**. A hardened module is supposed to be a *pure* substrate — its top-level should freeze at module-load time.
- **This module is the exception**. The mutable state is the *causal-console annotation surface*: when `note(error, details)` is called after the error has been created, the new details are appended to the error's hidden annotation list.
- **The exposure is intentional and narrow**. The mutable state is observable to *anyone holding `loggedErrorHandler`* — which is the logging substrate itself, not arbitrary user code.

The §honest-admission idiom: *we know this is unusual; we are doing it deliberately; the exposure surface is documented*. The maintainer reading the file is told *up front* that the assert module is not pure, and the reader is given the precise gate (`loggedErrorHandler`) for understanding who can observe the state.

The §contrast with cycle 96's `console.js`: that module is *purely-receiving* — it takes `baseConsole` as an argument and wraps it. The assert module *holds the state* that the wrapping reads from. The two modules are designed to compose: `console.js` accepts a `loggedErrorHandler`, and the canonical one comes from this module.

### §The declassifiers WeakMap and the quote operator

The §declassifiers WeakMap (lines 65-69):

```js
/**
 * @type {WeakMap<object, any>} Maps the wrappers returned by `quote` and
 * `bare` back to the underlying value they wrap, used by the redacted
 * `details` template tag to decide whether a substitution should be
 * declassified into the logged message.
 */
const declassifiers = new WeakMap();
```

The §quote operator (lines 70-80):

```js
const quote = (value, spaces = undefined) => {
  const result = freeze({
    toString: freeze(() => bestEffortStringify(value, spaces)),
  });
  weakmapSet(declassifiers, result, value);
  return result;
};
freeze(quote);
```

The structural pattern:

- **`quote(value)` returns an opaque wrapper**. The returned object has no own properties except `toString`; the wrapper is frozen; the underlying value is unobservable via property enumeration.
- **The `toString` invokes `bestEffortStringify`**. `bestEffortStringify` is a SES utility that produces a debug-printable representation of any value without throwing — it handles cycles, exotic objects, and uncatchable getters by falling back to placeholders like `(some object)`.
- **The wrapper is registered in `declassifiers`**. This is the *declassification gate*: the redacted-details template tag inspects each substitution against this WeakMap to decide whether the substitution was *intentionally exposed* or should be redacted to a type-tag.

The §design intent: a maintainer writing `assert.fail(X\`got ${value} expected ${quote(value2)}\`)` is *opting in* to logging `value2` while letting `value` be redacted. The `quote` call is the syntactic marker for *I, the assert-call author, take responsibility for exposing this value*.

The §spaces parameter is JSON-pretty-print width: `quote(obj, 2)` produces 2-space-indented multi-line stringification. Default is undefined (compact).

### §The bare operator and the canBeBare regex

The §canBeBare regex (lines 83-84):

```js
const canBeBare = freeze(/^[\w:-]( ?[\w:-])*$/);
```

The §regex anatomy:

- `^[\w:-]` — must start with a word character (`[A-Za-z0-9_]`), a colon, or a hyphen.
- `( ?[\w:-])*` — followed by zero-or-more groups of (optional-single-space, word-char-or-colon-or-hyphen).
- `$` — end-of-string.

The §structural intent: *names that look like identifiers or short prose without metacharacters that could be confused with substitutions*. Examples that match:

- `foo` (word).
- `foo-bar` (kebab-case).
- `foo:bar` (namespaced).
- `Type Error` (two words separated by single space).
- `key-1:bar baz` (compound).

Examples that *don't* match:

- `foo bar baz` with `bar` having a leading or trailing space — no, this matches.
- `foo\nbar` (newline) — does not match.
- `foo  bar` (double space) — does not match.
- `foo*bar` (asterisk) — does not match.
- `${interpolation}` (dollar-brace) — does not match.

The §bare operator (lines 85-92):

```js
const bare = (str, spaces = undefined) => {
  if (typeof str !== 'string' || !regexpTest(canBeBare, str)) {
    return quote(str, spaces);
  }
  const result = freeze({ toString: freeze(() => str) });
  weakmapSet(declassifiers, result, str);
  return result;
};
freeze(bare);
```

The §two-branch structure:

- **The string passes `canBeBare`** → return a declassifier whose `toString` is *the string itself, verbatim*. No JSON-quoting; no wrapping.
- **The string fails `canBeBare`** → fall back to `quote(str, spaces)`. This forces JSON-style escaping (with double-quotes around the value).

The §design intent: when an assert author writes `\`got ${specimen} expected ${bare(typeName)}\``, they want `typeName` (e.g. `"string"`) to appear in the rendered message as `string`, *not* as `"string"`. The `bare` operator is the *safe-prose-substitution* path — the regex acts as a sanitizer to ensure no metacharacters leak through.

The §typeof check (`typeof str !== 'string'`) is the input-validation gate: non-strings are immediately routed to `quote` so the operator can't be tricked into emitting raw object representations.

### §The hiddenDetailsMap and DetailsTokenProto

The §hiddenDetailsMap WeakMap (line 95):

```js
const hiddenDetailsMap = new WeakMap();
```

The §rationale: a `DetailsToken` instance is structurally *just a frozen marker* — it carries no own properties that could leak. The actual literal-parts-and-substitutions of the template-tag invocation live in this hidden map, keyed by the token. Reading the token directly reveals nothing; the rendering logic looks up the hidden parts via this map.

The §DetailsTokenProto (lines 111-127):

```js
const DetailsTokenProto = freeze({
  toString() {
    const hiddenDetails = weakmapGet(hiddenDetailsMap, this);
    if (hiddenDetails === undefined) {
      return '[Not a DetailsToken]';
    }
    return getMessageString(hiddenDetails);
  },
});
freeze(DetailsTokenProto.toString);
```

The §two-branch toString:

- **Token has hidden details** → return `getMessageString(hiddenDetails)` (the redacted rendering).
- **Token has no hidden details** → return `[Not a DetailsToken]` as a fallback. This branch is reached if the prototype has been transplanted onto a non-token object (defensive programming).

The §getMessageString function (lines 99-109; not shown here in full but called by the prototype's `toString`) walks the literal parts and substitutions; for each substitution it checks the `declassifiers` WeakMap to see if the substitution was intentionally exposed, and if so emits the underlying value; otherwise it emits a type-tag.

The §type-tag rendering examples:

- Substitution is a declassified `quote`/`bare` result → render its `toString` (the exposed underlying value).
- Substitution is an `Error` instance not in declassifiers → render `(a TypeError)`, `(a RangeError)`, etc. — the constructor's name with `a`/`an` agreement.
- Substitution is some other value not in declassifiers → render `(an Object)`, `(a string)`, etc.

### §The redactedDetails template tag

The §redactedDetails function (lines 144-178; the canonical `details` / `X` tag):

```js
const redactedDetails = (template, ...args) => {
  // Keep in mind that the vast majority of `details` calls pass a
  // template literal, so this argument can be a frozen array.
  template = freeze(template);
  const parts = [template[0]];
  for (let i = 0; i < args.length; i += 1) {
    parts.push(args[i], template[i + 1]);
  }
  const token = freeze({ __proto__: DetailsTokenProto });
  weakmapSet(hiddenDetailsMap, token, parts);
  return token;
};
freeze(redactedDetails);
```

The §structural picture:

- **Inputs**: `template` is the array of literal-string parts (from the tagged template); `args` are the substitutions.
- **Output**: a frozen token whose hidden details are the interleaved `parts` array (`[literal, sub, literal, sub, ..., literal]`).
- **The token's identity is the only handle**. The substitutions are stored *outside* the token in `hiddenDetailsMap`; the token itself has no own properties.

The §canonical usage:

```js
assert.fail(X`unexpected ${value} when expecting ${expected}`);
```

The §template-literal call produces:

- `template = ['unexpected ', ' when expecting ', '']`
- `args = [value, expected]`

The §resulting token's hidden details are `['unexpected ', value, ' when expecting ', expected, '']`. When `error.message` is computed via `getMessageString`, each substitution is checked against `declassifiers`:

- `value` not declassified → renders as `(an Object)` (or similar).
- `expected` not declassified → renders as `(a string)` (or similar).

The §message becomes `unexpected (an Object) when expecting (a string)` — *redacted*. To preserve the actual values, the caller wraps them: `X\`unexpected ${quote(value)} when expecting ${quote(expected)}\`` → renders `unexpected {"foo":42} when expecting "bar"`.

### §The unredactedDetails variant for `errorTaming: 'unsafe'`

The §unredactedDetails function (lines 181-202):

```js
const unredactedDetails = (template, ...args) => {
  template = freeze(template);
  args = arrayMap(args, arg =>
    weakmapHas(declassifiers, arg) ? arg : quote(arg),
  );
  return redactedDetails(template, ...args);
};
freeze(unredactedDetails);
```

The §two-step structure:

1. **Wrap every non-declassified substitution in `quote`**. The `arrayMap` walks each substitution; if the substitution is *already* in `declassifiers` (i.e., the caller called `quote`/`bare` explicitly), it stays as-is; otherwise it is wrapped via `quote(arg)`, which registers it in `declassifiers` with its own underlying value.
2. **Delegate to `redactedDetails`** with the now-all-declassified arguments. Since every substitution is now in `declassifiers`, the rendered message will include the underlying values instead of type-tags.

The §usage context: `unredactedDetails` is what assert returns as `details` when `lockdown({ errorTaming: 'unsafe' })` is in effect. The §discipline: in safe mode (the default), error messages are sparse — substitutions are redacted to type-tags so a hostile party catching the error gets minimal information. In unsafe mode, error messages are verbose — the developer sees the actual values for debugging.

The §safety argument: when `errorTaming: 'unsafe'`, the developer is opting *out* of confidentiality protection for error data. This is appropriate for development environments; production should keep `errorTaming` at its safe default so error messages don't leak object state across mutually-suspicious-compartment boundaries.

## Connection to the wider library

This section is the **canonical *substitution-declassification-as-default-redact* pattern**. Three threads:

1. **The mutable-state-with-narrow-exposure admission** generalizes to other SES-internal modules that must hold state across compartment-loading boundaries. The discipline is *narrow-typed-gate* (here `loggedErrorHandler`) plus *up-front honest admission in the file header*.

2. **The declassifier-WeakMap pattern** is reusable for any *intentional-vs-accidental-exposure* discrimination. The opaque-wrapper-plus-side-map approach lets the discriminator inspect the wrapper without the wrapper carrying its underlying value as an own property.

3. **The safe-prose regex (`canBeBare`)** is a worked example of the *whitelist-sanitization-for-string-interpolation* discipline. The regex constrains the input to *names-and-short-prose-only*; metacharacters trigger fallback to JSON-quoting via `bestEffortStringify`.

The §redacted-vs-unredacted-details split is the canonical *safe-default-with-unsafe-opt-in* pattern: the dangerous behavior (logging arbitrary object content) is reachable only by an explicit lockdown setting.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `top-level mutable state, observable to any code that has access to the loggedErrorHandler` | The honest-mutable-state-with-narrow-exposure admission; surface the gate up-front in the file header. |
| `Maps the wrappers returned by quote and bare back to the underlying value they wrap` | The opaque-marker-plus-side-map declassification pattern. |
| `canBeBare = /^[\w:-]( ?[\w:-])*$/` | The whitelist-sanitization-for-string-interpolation discipline; constrain input to names-and-short-prose-only. |
| `redactedDetails` (the default `X` tag) | Default-redact substitutions; expose only declassified ones. |
| `unredactedDetails` (under `errorTaming: 'unsafe'`) | Opt-in unsafe verbose-rendering for development; default is sparse-type-tag rendering. |
| `(a TypeError)` / `(an Object)` type-tag rendering | The sparse-type-tag-without-content rendering for *known-class-but-redacted-content* substitutions. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate; this module is one of SES's internal taming surfaces.
- [[errors]] (topic) — the broader SES error-handling system this module's *redaction discipline* is the canonical entry point to.
- `endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler` — the next section: the rendering machinery that consumes these tokens and the loggedErrorHandler bridge to cycle 96's `console.js`.
- `endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family` — the third section: `makeAssert` factory plus the `fail` / `Fail` / `assert` / `assert.equal` / `assert.typeof` family.
- `endo--packages-ses-src-error-console-js--*` (cycle 96) — the causal-console rendering surface; that module receives the `loggedErrorHandler` this module exports.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--*` (cycle 93) — provides the privileged `getStackString` capability that `loggedErrorHandler.getStackString` prefers when available.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — produces the causal annotations that pass through `note(error, details)` (covered in next section).

## Common confusions

- **"`top-level mutable state` is forbidden in hardened modules."** It is — *unless the module honestly admits it and narrows the exposure*. This module is the documented exception; the gate is `loggedErrorHandler`. The opening comment names the exception so a reader of the file is told up-front rather than discovering it later.
- **"`quote(value)` JSON-stringifies the value."** It returns a wrapper *whose `toString` invokes `bestEffortStringify`* — `bestEffortStringify` is JSON-stringify-shaped but handles cycles, exotic objects, and uncatchable getters by falling back to placeholders. It cannot throw.
- **"`bare` is just `quote` without quotes."** It is — *but only if the input matches the `canBeBare` regex*. Non-matching inputs fall back to `quote`. The regex acts as a *safe-prose gate* against metacharacter injection.
- **"`canBeBare` is too restrictive — what about `foo.bar`?"** The dot is intentionally excluded. The regex permits `[\w:-]` (word, colon, hyphen) only. A property-path like `foo.bar` will fall back to `quote` and be JSON-rendered. The conservative regex prevents accidental injection of newlines, dollar-braces, or other format-string metacharacters.
- **"`hiddenDetailsMap` is just an obfuscation."** It is *structural unobservability*. A `DetailsToken` has no own properties; reading it directly via `for-in`/`Object.keys`/`JSON.stringify` reveals nothing. The substitutions live in the WeakMap; only code that holds a reference to the map can inspect them. The token's `toString` is the only intentional channel.
- **"`redactedDetails` vs `unredactedDetails` is a config-knob bug — they should be one function."** They are deliberately separate. The redacted form is the *safe default*; the unredacted form is reached only via an explicit `lockdown({ errorTaming: 'unsafe' })`. Conflating them would let unsafe behavior leak into safe code paths.
- **"Why are Errors special-cased in the type-tag rendering?"** Errors are common substitution targets in assert messages (`X\`got error ${err}\``), and rendering `(a TypeError)` is more useful than `(an Object)` because the constructor identity is *non-confidential* (it's a primitive class name). Object instances of arbitrary classes get the generic `(an Object)` to avoid leaking class-naming information that might be confidential.
- **"`(a TypeError)` reveals the error class — that's a leak."** Class names are *types*, not *contents*. The SES threat model considers types non-confidential (they are part of the platform's universal vocabulary); contents (property values, message text) are confidential by default. The redacted form leaks types but not contents, which is the intentional information-disclosure trade-off.
