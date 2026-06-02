---
title: The `getLogArgs` function that converts a hidden-details parts array into a console-substitution-friendly args array by unquoting `declassifiers`-registered substitutions and trimming substitution-adjacent spaces (since console.log inserts its own argument-separator spaces); the `hiddenMessageLogArgs` WeakMap that lets the causal-console look up the *most-informative* log-args form of an error's message after the error has been constructed; the `errorTagNum` counter + `errorTags` WeakMap + `tagError` function that assign each error a unique tag like `Error#3` for cross-reference between the rendered short form and the full annotation tree; the `sanitizeError` function that strips host-added own properties (V8's `fileName`/`lineNumber`/`columnNumber`/`stack`/`message`/`name` getters), annotates the error with the dropped values via `note`, converts remaining accessor properties to data properties, and freezes; the `makeError` factory that constructs an `Error` from a details-token; the `note` annotation function with hiddenNoteCallbacks for after-the-error logging; the `defaultGetStackString` non-privileged fallback that the loggedErrorHandler prefers `globalThis.getStackString` over; the `loggedErrorHandler` itself — the canonical bridge object that cycle 96's console.js receives
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson]
source_lines: "204-477 (getLogArgs + hiddenMessageLogArgs + errorTagNum + tagError + sanitizeError + makeError + note + defaultGetStackString + loggedErrorHandler)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The *rendering machinery* of SES's assert module — the bridge
  between the cycle-90 (track-turns), cycle-93 (tame-v8), and cycle-96
  (causal-console) facets, all consumed via the exported
  `loggedErrorHandler`. Eight named surfaces: `getLogArgs`,
  `hiddenMessageLogArgs`, `errorTagNum` + `tagError`, `sanitizeError`,
  `makeError`, `note` + `hiddenNoteCallbacks`, `defaultGetStackString`,
  and `loggedErrorHandler`. The §getLogArgs structure unquotes
  declassifier-wrapped substitutions back to their underlying values
  for console-substitution and trims substitution-adjacent spaces
  *because the console logger inserts its own separating spaces
  between arguments*. The §sanitizeError function captures the
  host's automatically-added Error own-properties (fileName /
  lineNumber / etc. in non-V8 engines), annotates the error with a
  `note` describing the dropped values, and converts accessor
  properties (V8's `stack` getter) to data properties to make the
  error robust to redaction. The §loggedErrorHandler is the exact
  bridge cycle-96's makeCausalConsole consumes.
---

## Abstract

The §getLogArgs function (lines 204-238) converts a hidden-details parts array into a console-substitution-friendly args array. Each substitution is checked against `declassifiers`: if registered, the underlying value replaces the wrapper; the literal-parts around it are trimmed of substitution-adjacent spaces because *the console logger inserts its own argument-separator space between adjacent log-args*. The §hiddenMessageLogArgs WeakMap (line 246) stores the per-error log-args form of the original message-details so the causal-console can later render the *most-informative* form. The §errorTagNum counter + §errorTags WeakMap + §tagError function (lines 247-271) assign each error a unique short tag like `Error#3` so the rendered short form (e.g. `(Error#3)` in a substitution) can be cross-referenced with the full annotation tree. The §sanitizeError function (lines 273-330) strips host-added own properties — in non-V8 engines, `Error` constructors silently add `fileName`/`lineNumber`/`columnNumber`/`name`/`message` as enumerable own properties; in V8, `stack` is a getter on the instance. The function captures these as a `dropped` object, removes them from the error, annotates the error with a `note` describing what was dropped, converts any remaining accessor properties (V8 `stack`) to data properties, and freezes. The §makeError factory (lines 335-386) constructs an `Error` from a details-token: it looks up the hidden details, computes the message string, handles `AggregateError` specially, stores the log-args form in `hiddenMessageLogArgs`, optionally tags the error, optionally sanitizes, and returns. The §note function (lines 407-428) is the after-the-error annotation surface; if a callback has been registered for the error (via `loggedErrorHandler.takeNoteLogArgsArray`), the callback is invoked immediately so the console can render the annotation *as it arrives* rather than waiting for next-log; otherwise the annotation is queued. The §defaultGetStackString function (lines 438-448) is the non-privileged fallback used when `globalThis.getStackString` is not present — it just reads `error.stack`. The §loggedErrorHandler (lines 451-477) is the canonical bridge object: it bundles `getStackString` (preferring `globalThis.getStackString`), `tagError`, `resetErrorTagNum`, `getMessageLogArgs`, `takeMessageLogArgs`, and `takeNoteLogArgsArray` — exactly the surface cycle 96's `makeCausalConsole` consumes.

## Body

### §getLogArgs — unquoting and space-trimming for console substitution

The §getLogArgs function (lines 204-238):

```js
const getLogArgs = ({ template, args }) => {
  const logArgs = [template[0]];
  for (let i = 0; i < args.length; i += 1) {
    let arg = args[i];
    if (weakmapHas(declassifiers, arg)) {
      arg = weakmapGet(declassifiers, arg);
    }
    // Remove the extra spaces that would be inserted between
    // adjacent log args, because they are unhelpful when the
    // adjacent log args have nothing of interest between them.
    const priorWithoutSpace = stringReplace(
      /** @type {string} */ (logArgs[logArgs.length - 1]),
      / $/,
      '',
    );
    if (priorWithoutSpace !== logArgs[logArgs.length - 1]) {
      logArgs[logArgs.length - 1] = priorWithoutSpace;
    }
    let next = template[i + 1];
    if (stringStartsWith(next, ' ')) {
      next = stringSlice(next, 1);
    }
    logArgs.push(arg, next);
  }
  return logArgs;
};
```

The §three-step rewrite per substitution:

1. **Unquote the substitution if it's a declassifier**. If `arg` is in `declassifiers`, replace it with the underlying value. This is the *log-args version* of the substitution: the rendered console output gets the actual value (which the console can pretty-print using its own object inspector), not the redacted `(an Object)` placeholder.
2. **Trim trailing space from the prior literal part**. The just-pushed literal-part is updated to strip its trailing space (if any). The intent: the console logger will insert a space between adjacent log-args automatically; if the literal-part already ended with a space, the substitution would be preceded by *two* spaces.
3. **Trim leading space from the next literal part**. Similarly, the next literal-part (template[i+1]) gets its leading space stripped.

The §design intent: when the assert source reads `X\`unexpected ${value} when expecting ${expected}\``, the literal parts are `['unexpected ', ' when expecting ', '']`. The naïve substitution would render with double-spaces around each value (because the console inserts its own space between argument slots). The trimming produces `'unexpected'`, `value`, `'when expecting'`, `expected`, `''` — and the console concatenates those with single-space separators.

The §honest-name in the comment (*adjacent log args have nothing of interest between them*) is the structural admission: the trimming is *not* lossy because the spaces it removes are *redundant with the console's own argument-separator inserts*.

### §The hiddenMessageLogArgs WeakMap

The §hiddenMessageLogArgs WeakMap (line 246) is one of the module's *top-level mutable state* members (the one the file header warned about):

```js
const hiddenMessageLogArgs = new WeakMap();
```

The §purpose: each error created via `makeError` has its log-args form stored here keyed by the error instance. The causal-console later looks this up to render the *most-informative* form of the message: if `hiddenMessageLogArgs.get(error)` returns a log-args array (with substitutions as their unquoted underlying values), the console uses that; otherwise it falls back to `error.message` (the redacted string form).

The §weakness reason: WeakMap so that errors that are no longer referenced can be garbage collected even though they were once tagged. The map is *exposed* via `loggedErrorHandler.getMessageLogArgs` and `loggedErrorHandler.takeMessageLogArgs` — the *narrow gate* the file header named.

### §errorTagNum + errorTags + tagError

The §errorTagNum mutable counter + §errorTags WeakMap (lines 247-249):

```js
let errorTagNum = 0;
/** @type {WeakMap<Error, string>} */
const errorTags = new WeakMap();
```

The §tagError function (lines 250-271):

```js
const tagError = (err, optErrorName = undefined) => {
  let errorTag = weakmapGet(errorTags, err);
  if (errorTag !== undefined) {
    return errorTag;
  }
  if (optErrorName !== undefined && typeof optErrorName !== 'string') {
    throw TypeError(`error name must be a string: ${optErrorName}`);
  }
  if (optErrorName !== undefined) {
    errorTag = optErrorName;
  } else {
    errorTagNum += 1;
    errorTag = `${err.name}#${errorTagNum}`;
  }
  weakmapSet(errorTags, err, errorTag);
  return errorTag;
};
```

The §two-mode behavior:

- **`tagError(err)`** — assigns a monotonically-increasing tag like `Error#1`, `TypeError#2`, `RangeError#3`, derived from `err.name` and the counter.
- **`tagError(err, optErrorName)`** — uses the explicit name as the tag. Useful when an error has a maintainer-meaningful identity (e.g. tagged at `makeError` time via the `errorName` option).

The §idempotence: if the error has already been tagged, return the existing tag. This means *every error gets exactly one tag* over its lifetime; subsequent `tagError(err)` calls return the same string.

The §counter is *intentionally mutable top-level state* — the *one* of the module's mutable surfaces that is *not* a WeakMap. It increments globally across all errors ever tagged in the process. The `loggedErrorHandler.resetErrorTagNum` method lets the test infrastructure reset the counter to 0 between tests so test output is reproducible.

The §cross-reference rendering: when the causal-console encounters an error as a substitution (e.g., a child error inside an `AggregateError.errors`), it renders the short form `(TypeError#5)` rather than the full error message. The tag is the *cross-reference key* — the full error is rendered separately (with its tag as header) and the short form is the pointer.

### §sanitizeError — stripping host-added own properties

The §sanitizeError function (lines 273-330):

```js
const sanitizeError = error => {
  const descs = getOwnPropertyDescriptors(error);
  const {
    name: _nameDesc,
    message: _messageDesc,
    errors: _errorsDesc,
    cause: _causeDesc,
    stack: _stackDesc,
    ...restDescs
  } = descs;

  const restNames = ownKeys(restDescs);
  if (restNames.length >= 1) {
    for (const name of restNames) {
      delete error[name];
    }
    const dropped = create(objectPrototype, restDescs);
    const droppedDetails = redactedDetails`originally with properties ${quote(dropped)}`;
    // eslint-disable-next-line no-use-before-define
    note(error, droppedDetails);
  }
  for (const name of ownKeys(error)) {
    const desc = descs[name];
    if (desc && hasOwn(desc, 'get')) {
      const value = error[name]; // invokes the getter
      defineProperty(error, name, { value });
    }
  }
  freeze(error);
};
```

The §three structural steps:

1. **Whitelist the *known-standard* own-properties** (`name`, `message`, `errors`, `cause`, `stack`) and rest-collect everything else.
2. **Delete the rest-collected properties from the error**, but *preserve them via a `note` annotation*. The dropped values are wrapped in `quote(dropped)` and noted as *originally with properties …*. The error doesn't *lose* the diagnostic information — it is moved from own-property to annotation-list.
3. **Convert remaining accessor properties to data properties** (V8's `stack` is the canonical case — it's a getter on the instance). This is the *eagerly-evaluate-and-freeze* discipline: after this pass, the error has no live getters, so freezing it doesn't accidentally lock in mutable behavior.

The §rationale for stripping:

- In **non-V8 engines** (SpiderMonkey, JavaScriptCore), `new Error(...)` adds enumerable own properties like `fileName`, `lineNumber`, `columnNumber` automatically. These are *information leaks* — the file path and line number reveal source-tree structure.
- In **V8**, `stack` is a getter on the instance (not the prototype) that computes the stack-trace lazily. The getter form is incompatible with `freeze` (frozen objects can have data properties but not configurable accessors).
- The §discipline: *normalize the error to a frozen object with only the SES-permitted own properties*. The dropped values survive as an annotation so debugging is still possible; the error itself is now a *deterministic, frozen value* safe to pass across compartment boundaries.

The §note about the dropped values is rendered by the causal-console as a sub-line under the error, so a maintainer reading the log sees both *the sanitized error* and *the host-added context that was stripped*. This is the *moved-not-lost* discipline.

### §makeError — the factory

The §makeError function (lines 335-386):

```js
const makeError = (
  optDetails = redactedDetails`Assert failed`,
  errConstructor = globalThis.Error,
  { errorName = undefined, cause = undefined, errors = undefined, sanitize = true } = {},
) => {
  if (typeof optDetails === 'string') {
    optDetails = redactedDetails([optDetails]);
  }
  const hiddenDetails = weakmapGet(hiddenDetailsMap, optDetails);
  if (hiddenDetails === undefined) {
    throw TypeError(`unrecognized details ${quote(optDetails)}`);
  }
  const messageString = getMessageString(hiddenDetails);
  const opts = cause && { cause };
  let error;
  if (typeof AggregateError !== 'undefined' && errConstructor === AggregateError) {
    error = AggregateError(errors || [], messageString, opts);
  } else {
    const ErrorCtor = /** @type {ErrorConstructor} */ (errConstructor);
    error = ErrorCtor(messageString, opts);
    if (errors !== undefined) {
      defineProperty(error, 'errors', {
        value: errors, writable: true, enumerable: false, configurable: true,
      });
    }
  }
  weakmapSet(hiddenMessageLogArgs, error, getLogArgs(hiddenDetails));
  if (errorName !== undefined) { tagError(error, errorName); }
  if (sanitize) { sanitizeError(error); }
  return error;
};
```

The §six-step construction:

1. **Coerce a string `optDetails` into a single-literal details token**. Maintainers can write `makeError('something failed')` instead of `makeError(X\`something failed\`)` for the no-substitution case.
2. **Look up the hidden parts**. If the token doesn't have hidden parts, throw `TypeError` — the caller passed something that wasn't a details-token.
3. **Compute the redacted message string** via `getMessageString` (used as the error's `.message` own property).
4. **Branch on AggregateError**. If the requested constructor is `AggregateError`, use its constructor signature `(errors, message, opts)`. Otherwise call the standard `(message, opts)` and *backfill* `errors` as a non-enumerable own-property if provided. The §`opts.cause` field uses the new `Error.prototype.cause` semantics.
5. **Store the log-args form** in `hiddenMessageLogArgs` so the causal-console can later render the verbose form.
6. **Optionally tag and sanitize**. The default is `sanitize: true`; callers who want to preserve host-added properties can pass `sanitize: false`.

The §footer comment (line 383): `// The next line is a particularly fruitful place to put a breakpoint.` — the *honest-debugger-affordance* idiom. The maintainer wrote this knowing that anyone debugging an assert failure will want to break right before the error is returned to its eventual `throw`.

### §note — the after-the-error annotation surface

The §hiddenNoteCallbacks WeakMap + §note function (lines 405-428):

```js
const hiddenNoteCallbacks = new WeakMap();

const note = (error, detailsNote) => {
  if (typeof detailsNote === 'string') {
    detailsNote = redactedDetails([detailsNote]);
  }
  const hiddenDetails = weakmapGet(hiddenDetailsMap, detailsNote);
  if (hiddenDetails === undefined) {
    throw TypeError(`unrecognized details ${quote(detailsNote)}`);
  }
  const logArgs = getLogArgs(hiddenDetails);
  const callbacks = weakmapGet(hiddenNoteCallbacks, error);
  if (callbacks !== undefined) {
    for (const callback of callbacks) {
      callback(error, logArgs);
    }
  } else {
    addNoteLogArgs(error, logArgs);
  }
};
```

The §two-mode dispatch:

- **A callback is registered for the error** (via `loggedErrorHandler.takeNoteLogArgsArray`'s callback parameter) → invoke each callback *immediately* with `(error, logArgs)`. This is the *streaming-annotation* mode: the console has already logged the error; further annotations should be appended to the log as they arrive.
- **No callback registered** → append the log-args to the error's *pending annotation list* via `addNoteLogArgs`. This is the *queued-annotation* mode: when the console eventually logs the error, it will drain the queue.

The §`makeNoteLogArgsArrayKit` is defined elsewhere; this module imports its `addLogArgs` and `takeLogArgsArray` and uses them as the queue's *back* and *front* respectively.

The §design intent: errors are often created and annotated over their lifetime — track-turns adds annotations as the causal chain crosses turn boundaries, and `sanitizeError` adds a *originally with properties …* annotation when it strips host-added properties. The console must be able to render all of them *and* update its rendering as new ones arrive.

### §defaultGetStackString — the non-privileged fallback

The §defaultGetStackString function (lines 438-448):

```js
const defaultGetStackString = error => {
  if (!('stack' in error)) {
    return '';
  }
  const stackString = `${error.stack}`;
  const pos = stringIndexOf(stackString, '\n');
  if (stringStartsWith(stackString, ' ') || pos === -1) {
    return stackString;
  }
  return stringSlice(stackString, pos + 1); // exclude the initial newline
};
```

The §honest-fallback discipline: when `globalThis.getStackString` (the privileged version from cycle 93's `tame-v8-error-constructor.js`) is *not* present, this function provides a *non-privileged* alternative that just reads `error.stack` and strips the first line (which on V8 is the error's message, redundant with the message we already render separately).

The §two-branch trim:

- **The first character is a space, or there is no newline at all** → return the stack string as-is. This handles SpiderMonkey-style stacks (lines start with a space) and degenerate cases.
- **Otherwise** → strip everything up to and including the first newline. This removes the V8-style first-line header `TypeError: some message at ...`.

The §comment naming choice: *unprivileged form that just uses the de facto `error.stack` property*. The *de facto* word is honest about the non-standardness of `error.stack` — it isn't in the ECMA-262 spec; every engine implements it, but the formats diverge. The fallback works on every engine that has *some* stack property.

### §loggedErrorHandler — the canonical bridge object

The §loggedErrorHandler (lines 451-477):

```js
const loggedErrorHandler = {
  getStackString: globalThis.getStackString || defaultGetStackString,
  tagError: error => tagError(error),
  resetErrorTagNum: () => { errorTagNum = 0; },
  getMessageLogArgs: error => weakmapGet(hiddenMessageLogArgs, error),
  takeMessageLogArgs: error => {
    const logArgs = weakmapGet(hiddenMessageLogArgs, error);
    weakmapDelete(hiddenMessageLogArgs, error);
    return logArgs;
  },
  takeNoteLogArgsArray: (error, callback) => {
    const logArgsArray = takeAllNoteLogArgs(error);
    if (callback !== undefined) {
      const callbacks = weakmapGet(hiddenNoteCallbacks, error);
      if (callbacks) {
        arrayPush(callbacks, callback);
      } else {
        weakmapSet(hiddenNoteCallbacks, error, [callback]);
      }
    }
    return logArgsArray || [];
  },
};
freeze(loggedErrorHandler);
export { loggedErrorHandler };
```

The §six methods:

- **`getStackString`** — `globalThis.getStackString` if the privileged version is present (cycle 93's tame-v8 exports it), otherwise the unprivileged fallback.
- **`tagError`** — returns the unique tag for the error (creating one on first call).
- **`resetErrorTagNum`** — resets the global counter; the *test-reproducibility* knob.
- **`getMessageLogArgs`** — *non-destructive* read of the per-error log-args.
- **`takeMessageLogArgs`** — *destructive* read; subsequent calls return undefined. The intent: the console takes the log-args once when it first renders the error.
- **`takeNoteLogArgsArray`** — *destructive* read of the queued annotations *plus optional registration of a callback for future annotations*. The console calls this when it first logs the error: it drains the queue *and* registers itself to receive streaming updates.

The §narrow-gate principle: `loggedErrorHandler` is *the entire surface* through which the causal-console accesses the module's top-level mutable state. The file header warned *anyone holding `loggedErrorHandler`* observes the mutable state — this object is exactly that handle.

The §freeze and §export: the bridge is frozen at module-load and exported. Cycle 96's `console.js` imports it and passes it through to `makeCausalConsole(baseConsole, loggedErrorHandler)`.

## Connection to the wider library

This section is the **canonical *narrow-gate-bridge between two SES-internal modules* worked example**. Three threads:

1. **The `loggedErrorHandler` is structurally a *capability object*** — a frozen bundle of methods whose holder is exactly the substrate authorized to observe the assert module's mutable state. The file header names the gate up-front; the bridge object is the gate's concrete form.

2. **The `sanitizeError` discipline** is the canonical *normalize-host-added-state-without-losing-it* pattern. Host engines silently add properties; SES strips them but preserves them as annotations so debugging is unaffected.

3. **The `tagError` cross-reference pattern** generalizes to any *render-the-summary-here-render-the-detail-elsewhere-cross-reference-by-tag* structure. The tag is the join key; the summary form (used in substitutions) is a short string; the full form is rendered separately under its tag header.

The §three-cycle trilogy of the SES causal-console architecture:

- **Cycle 90 `track-turns.js`** (Mark Miller) — produces annotations on errors as they cross turn boundaries.
- **Cycle 93 `tame-v8-error-constructor.js`** (Richard Gibson) — provides the privileged `getStackString`.
- **Cycle 96 `console.js`** (Mark Miller) — renders the structured errors using these capabilities.

This section *completes* the bridge: **cycle 98's `assert.js` (Richard Gibson) holds the mutable state and exports `loggedErrorHandler`** as the bridge object cycle 96's `console.js` imports.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `Remove the extra spaces that would be inserted between adjacent log args` | The console-substitution-aware space-trimming discipline; substituted args are space-separated by the logger itself. |
| `originally with properties ${quote(dropped)}` (note from sanitizeError) | The moved-not-lost discipline; host-added own-properties survive as annotations even after being stripped. |
| `tagError` → `Error#3` cross-reference | The render-summary-here-detail-elsewhere cross-reference-by-tag pattern. |
| `unprivileged form that just uses the de facto error.stack property` | The honest-non-standard-fallback discipline; works on every engine with some stack property, even if formats diverge. |
| `globalThis.getStackString \|\| defaultGetStackString` | The optional-privileged-capability pattern; prefer the V8-tamed version if present, fall back to the unprivileged form. |
| `takeMessageLogArgs` (destructive) vs `getMessageLogArgs` (non-destructive) | The take-vs-get nomenclature for one-shot vs idempotent reads. |
| `freeze(loggedErrorHandler); export { loggedErrorHandler };` | The frozen-capability-bundle as the narrow-gate to module-internal state. |
| `The next line is a particularly fruitful place to put a breakpoint.` | The honest-debugger-affordance idiom; a maintainer-targeted comment about where to inject diagnostics. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate; this module exports the canonical `loggedErrorHandler` consumed by SES's causal-console.
- [[errors]] (topic) — the broader SES error-handling system; this section is the rendering-machinery layer.
- `endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details` — the previous section: the redaction discipline that produces the details-tokens this section's `makeError` and `note` consume.
- `endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family` — the next section: the user-facing `makeAssert` factory and the `assert` / `Fail` / `assert.equal` / `assert.typeof` family.
- `endo--packages-ses-src-error-console-js--*` (cycle 96) — the causal-console rendering surface; `makeCausalConsole(baseConsole, loggedErrorHandler)` consumes this section's exported bridge.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--*` (cycle 93) — provides `globalThis.getStackString` that `loggedErrorHandler.getStackString` prefers when present.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — produces annotations that pass through `note(error, details)`.
- `endo--packages-pass-style-src-error-js--*` (cycle 87) — pass-style's error-validation surface; sanitized errors flow through that gate.

## Common confusions

- **"`getLogArgs` is just `getMessageString` with no string-concat."** It is — *plus the space-trimming around substitution boundaries*. `getMessageString` concatenates everything to one string with no trimming because the result is *a single rendered string*; `getLogArgs` returns *an array of arguments* that the console will space-separate on its own, so the trimming avoids double-spaces.
- **"`tagError` could just use `error.message` as the tag."** Errors with the same message would collide. The counter-based tag guarantees uniqueness even when many errors of the same name share a message. The counter increments globally, so `Error#3` always identifies *one specific error instance* in the current process.
- **"`sanitizeError` loses diagnostic information."** It does *not*. The dropped properties survive as a `note` annotation on the error (`originally with properties …`). The causal-console renders the annotation under the error, so a maintainer reading the log sees the same information that would have been visible from `console.dir(err)` — it's just been moved to a different rendering channel.
- **"V8's `stack` getter is just a perf optimization."** It is a *deferred-stack-walking optimization* (the JIT collects the frame information at throw time, but formatting it as a string is lazy). The SES-side concern is that *freezing an object with live accessors locks in their behavior* — calling the getter *again* after freeze invokes the same getter, which on V8 captures the *current* stack, not the *throw-time* stack. Eagerly evaluating and converting to a data property locks in the *throw-time* stack.
- **"`loggedErrorHandler` is just a god object."** It is the *intentional narrow-gate*. The file header explicitly names *anyone holding `loggedErrorHandler` observes the mutable state*. Concentrating the surface in one frozen bundle makes the auth-boundary auditable: anywhere the bridge is exported or passed, an auditor can see exactly which compartment was granted the observation capability.
- **"`takeMessageLogArgs` being destructive is a bug — the console should not lose data."** It is *intentional*. The contract: the console takes the log-args *exactly once*, when it first renders the error. Subsequent renders use whatever it has cached. The destructive read frees the WeakMap entry so the error can be GC'd if no other reference holds it.
- **"The `note` callback re-entrancy with `hiddenNoteCallbacks` looks like a bug."** It is the *streaming-annotation* mode: once the console has registered a callback, future `note(error, …)` calls hand the annotation directly to the console rather than queueing. This lets the console show *just-arrived* annotations even after the error has already been logged.
- **"The errorTagNum counter monotonically growing is a leak."** It is a *test-determinism affordance* (`loggedErrorHandler.resetErrorTagNum`) — tests reset the counter at test-start so output is reproducible. In production, the counter grows; it is an integer, so even `Number.MAX_SAFE_INTEGER` is reached only after 9e15 error tags.
