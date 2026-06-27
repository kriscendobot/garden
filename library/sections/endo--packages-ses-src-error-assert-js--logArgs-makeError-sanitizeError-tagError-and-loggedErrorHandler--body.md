---
title: Body
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: bfa149b4f18c6ad1cf1fed3e91cbaddf1e61b39d
source_date: 2026-06-23
source_authors: [Richard Gibson]
source_lines: "214-506 (getLogArgs + hiddenMessageLogArgs + errorTagNum + tagError + sanitizeError + makeError + note + defaultGetStackString + loggedErrorHandler)"
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
parent: endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler
---

### §getLogArgs — unquoting and space-trimming for console substitution

The §getLogArgs function (lines 222-248):

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

The §hiddenMessageLogArgs WeakMap (line 257) is one of the module's *top-level mutable state* members (the one the file header warned about):

```js
const hiddenMessageLogArgs = new WeakMap();
```

The §purpose: each error created via `makeError` has its log-args form stored here keyed by the error instance. The causal-console later looks this up to render the *most-informative* form of the message: if `hiddenMessageLogArgs.get(error)` returns a log-args array (with substitutions as their unquoted underlying values), the console uses that; otherwise it falls back to `error.message` (the redacted string form).

The §weakness reason: WeakMap so that errors that are no longer referenced can be garbage collected even though they were once tagged. The map is *exposed* via `loggedErrorHandler.getMessageLogArgs` and `loggedErrorHandler.takeMessageLogArgs` — the *narrow gate* the file header named.

### §errorTagNum + errorTags + tagError

The §errorTagNum mutable counter + §errorTags WeakMap (lines 260-265):

```js
let errorTagNum = 0;
/** @type {WeakMap<Error, string>} */
const errorTags = new WeakMap();
```

The §tagError function (lines 272-281):

```js
const tagError = (err, optErrorName = err.name) => {
  let errorTag = weakmapGet(errorTags, err);
  if (errorTag !== undefined) {
    return errorTag;
  }
  errorTagNum += 1;
  errorTag = `${optErrorName}#${errorTagNum}`;
  weakmapSet(errorTags, err, errorTag);
  return errorTag;
};
```

The §two-mode behavior (the `optErrorName` parameter defaults to `err.name`, so the *name component* of the tag is always supplied; the *number* is always appended):

- **`tagError(err)`** — assigns a monotonically-increasing tag like `Error#1`, `TypeError#2`, `RangeError#3`, where the name part defaults to `err.name` and the number is the post-increment of the shared `errorTagNum` counter.
- **`tagError(err, optErrorName)`** — substitutes an explicit name for the name component, yielding `${optErrorName}#${errorTagNum}`. Useful when an error has a maintainer-meaningful identity (e.g. tagged at `makeError` time via the `errorName` option). Note the *number* is still appended — the explicit name does not replace the whole tag.

The §idempotence: if the error has already been tagged, return the existing tag. This means *every error gets exactly one tag* over its lifetime; subsequent `tagError(err)` calls return the same string.

The §counter is *intentionally mutable top-level state* — the *one* of the module's mutable surfaces that is *not* a WeakMap. It increments globally across all errors ever tagged in the process. The `loggedErrorHandler.resetErrorTagNum` method lets the test infrastructure reset the counter to 0 between tests so test output is reproducible.

The §cross-reference rendering: when the causal-console encounters an error as a substitution (e.g., a child error inside an `AggregateError.errors`), it renders the short form `(TypeError#5)` rather than the full error message. The tag is the *cross-reference key* — the full error is rendered separately (with its tag as header) and the short form is the pointer.

### §sanitizeError — stripping host-added own properties

The §sanitizeError function (lines 310-340):

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

The §makeError function (lines 345-414):

```js
const makeError = (
  optDetails,
  errConstructor,
  { errorName = undefined, cause = undefined, errors = undefined, sanitize = true } = {},
) => {
  // The first two parameters above cannot be inferred unless this is rewritten
  // as a function declaration using an @overload tag. This is a workaround so
  // that we at least have type-safety within the function body.
  //
  // Note that due to the overload of AssertionUtilities['makeError'], strict
  // mode will complain if default parameters are provided in the method
  // signature. The below workaround (optDetails -> details; errConstructor ->
  // errCtor) is functionally equivalent but allows us to use type assertions to
  // workaround the strict mode issue.
  let details = /** @type {Details} */ (
    optDetails ?? redactedDetails`Assert failed`
  );
  // Internally, this is a GenericErrorConstructor, but externally it can be
  // some T which extends GenericErrorConstructor.
  const errCtor = /** @type {GenericErrorConstructor} */ (
    errConstructor ?? globalThis.Error
  );
  if (typeof details === 'string') {
    details = redactedDetails([details]);
  }
  const hiddenDetails = weakmapGet(hiddenDetailsMap, details);
  if (hiddenDetails === undefined) {
    throw TypeError(`unrecognized details ${quote(details)}`);
  }
  const messageString = getMessageString(hiddenDetails);
  const opts = cause && { cause };
  let error;
  if (typeof AggregateError !== 'undefined' && errCtor === AggregateError) {
    error = AggregateError(errors || [], messageString, opts);
  } else {
    const ErrorCtor = /** @type {ErrorConstructor} */ (errCtor);
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

1. **Apply the parameter defaults internally, not in the signature**. As of the 2026-06-23 refactor (Christopher Hiller, commit `bfa149b4`) the `optDetails`/`errConstructor` parameters carry *no* default-value expressions; instead the body reassigns `details = optDetails ?? redactedDetails\`Assert failed\`` and `errCtor = errConstructor ?? globalThis.Error` behind `@type` assertions. The §reason named in the new comment block: `AssertionUtilities['makeError']` is a typed *overload*, and TypeScript strict mode complains when default parameters are written on a method that has an `@overload` declaration. The behaviour is *functionally equivalent* to the old signature defaults — this is purely a type-checking workaround — but the rename (`optDetails` → `details`, `errConstructor` → `errCtor`) lets the assertions land. Maintainers can still write `makeError('something failed')` instead of `makeError(X\`something failed\`)`; the string-coercion below turns it into a single-literal details token.
2. **Look up the hidden parts**. If the token doesn't have hidden parts, throw `TypeError` — the caller passed something that wasn't a details-token.
3. **Compute the redacted message string** via `getMessageString` (used as the error's `.message` own property).
4. **Branch on AggregateError**. If the requested constructor is `AggregateError`, use its constructor signature `(errors, message, opts)`. Otherwise call the standard `(message, opts)` and *backfill* `errors` as a non-enumerable own-property if provided. The §`opts.cause` field uses the new `Error.prototype.cause` semantics.
5. **Store the log-args form** in `hiddenMessageLogArgs` so the causal-console can later render the verbose form.
6. **Optionally tag and sanitize**. The default is `sanitize: true`; callers who want to preserve host-added properties can pass `sanitize: false`.

The §footer comment (line 412): `// The next line is a particularly fruitful place to put a breakpoint.` — the *honest-debugger-affordance* idiom. The maintainer wrote this knowing that anyone debugging an assert failure will want to break right before the error is returned to its eventual `throw`. The 2026-06-23 refactor prefixes this with a short note that the return type is externally `InstanceType<T>` (where `T extends GenericErrorConstructor`) but internally `InstanceType<GenericErrorConstructor>` for implementation simplicity — the same internal-vs-external typing distinction the parameter rename is in service of.

### §note — the after-the-error annotation surface

The §hiddenNoteCallbacks WeakMap + §note function (lines 434-456):

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

The §defaultGetStackString function (lines 467-477):

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

The §loggedErrorHandler (lines 480-505):

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
