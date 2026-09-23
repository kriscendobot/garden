---
title: Body
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: 1b978bfbec82786398c61b004019f83cafef3527
source_date: 2026-06-17
source_authors: [Mark S. Miller]
source_lines: "279-586 (makeLoggingConsoleKit + pumpLogToConsole + ErrorInfo + makeCausalConsole + logError)"
topics: [hardened-javascript, errors]
status: current
notes: |
  Refreshed 2026-06-27 (file-commit e02b0f66 → 1b978bfb). The
  makeLoggingConsoleKit / pumpLogToConsole / ErrorInfo / logError
  render-sequence is unchanged; the *makeCausalConsole* opening and the
  closing wrapper-construction subsections were updated to match the new
  feralConsole parameter, the Node Console customInspect circumvention,
  the sanitizeFormatData integration, the dedicated assert/timeLog
  wrappers, and the single trailing `name in baseConsole` filter.
parent: endo--packages-ses-src-error-console-js--logging-console-causal-console-and-error-info-rendering
---

### §makeLoggingConsoleKit — the delayed-application buffer

The §logging-console subsection (lines 281-317):

```js
export const makeLoggingConsoleKit = (
  loggedErrorHandler,
  { shouldResetForDebugging = false } = {},
) => {
  if (shouldResetForDebugging) {
    loggedErrorHandler.resetErrorTagNum();
  }

  // Not frozen!
  let logArray = [];

  const loggingConsole = fromEntries(
    arrayMap(consoleMethodPermits, ([name, _]) => {
      const method = defineName(name, (...args) => {
        arrayPush(logArray, [name, ...args]);
      });
      return [name, freeze(method)];
    }),
  );
  freeze(loggingConsole);

  const takeLog = () => {
    const result = freeze(logArray);
    logArray = [];
    return result;
  };
  freeze(takeLog);

  return freeze({ loggingConsole: typedLoggingConsole, takeLog });
};
```

The structural reading:

- **Every console method becomes a `[name, ...args]`-push into `logArray`**. The actual log entries are *deferred*; nothing reaches a real console until `takeLog` is called.
- **`logArray` is *not frozen***. The `// Not frozen!` comment is explicit: the array must be mutable across pushes. After `takeLog()` drains it, a fresh array is allocated.
- **`shouldResetForDebugging`** option resets error tag numbering before capture begins — useful for deterministic test output.
- **`takeLog()` returns a frozen snapshot and resets** — atomically captures the current state and starts a fresh logArray for the next batch.

The §delayed-application shape is reusable: any test framework, batch-replay-debugger, or *capture-and-inspect* logger can use this pattern. The §canonical use is in test environments where logs should be captured during a test run and reviewed after — the logging-console captures; the test framework calls `takeLog()` at test end and asserts on the contents.

### §pumpLogToConsole — replaying captured log entries

The §pumpLogToConsole function (lines 328-335):

```js
export const pumpLogToConsole = (log, baseConsole) => {
  for (const [name, ...args] of log) {
    baseConsole[name](...args);
  }
};
```

The §comment names the use case:

> Makes the same calls on a `baseConsole` that were made on a `loggingConsole` to produce this `log`. In this way, a logging console can be used as a buffer to delay the application of these calls to a `baseConsole`.

The §pattern is *capture-then-replay*. A test may capture into a logging-console; if the test fails, the captured log is replayed onto the real console for debugging. If the test passes, the log is discarded.

### §ErrorInfo constants — four annotation kinds

The §ErrorInfo constants (lines 337-345):

```js
const ErrorInfo = {
  NOTE: 'ERROR_NOTE:',
  MESSAGE: 'ERROR_MESSAGE:',
  CAUSE: 'cause:',
  ERRORS: 'errors:',
};
freeze(ErrorInfo);
```

The four kinds:

| Kind | Prefix string | Meaning |
|---|---|---|
| `NOTE` | `ERROR_NOTE:` | An annotation attached to the error via `assert.note(error, ...)` (the track-turns.js callsite). |
| `MESSAGE` | `ERROR_MESSAGE:` | The error's main message log-args (from `takeMessageLogArgs`). |
| `CAUSE` | `cause:` | The standard ES `error.cause` property. |
| `ERRORS` | `errors:` | The AggregateError `error.errors` property. |

The four kinds reflect the *structured-error* model: a single error carries (a) a main message, (b) optional cause-chain, (c) optional sub-errors aggregation, and (d) optional notes attached after the fact. The causal-console renders all four kinds in a structured way.

### §makeCausalConsole — the structural core

The §causal-console subsection (lines 346-586) is the largest in the file. As of the 2026-06-17 refresh its first parameter is `feralConsole`, and before destructuring `loggedErrorHandler` it constructs a private `baseConsole` (on Node) that all the wrappers below delegate to:

```js
export const makeCausalConsole = (feralConsole, loggedErrorHandler) => {
  if (!feralConsole) {
    return undefined;
  }

  // ... build a replacement that opts out of Node's custom-inspect deep scan ...
  const Console = /** @type {any} */ (feralConsole).Console;
  const { stdout, stderr } = globalThis.process || { __proto__: null };
  const baseConsole =
    typeof Console === 'function' && (stdout || stderr)
      ? new Console({
          stdout,
          stderr,
          inspectOptions: { colors: undefined, customInspect: false },
        })
      : feralConsole;

  const { getStackString, tagError, takeMessageLogArgs, takeNoteLogArgsArray } =
    loggedErrorHandler;
  // ...
```

The §feralConsole-to-baseConsole circumvention (the refresh's most security-relevant addition) is documented in the source:

> In Node.js, the global console does a deep scan of its inputs for methods keyed by `Symbol.for('nodejs.util.inspect.custom')`, and invokes any that are found with unhardened arguments [...]. To circumvent that problematic behavior, we use its `Console` constructor to build a replacement that explicitly opts out by setting the `customInspect` option to false.

The structural picture:

- **The hazard.** Node's global `console`, when handed an object carrying a `Symbol.for('nodejs.util.inspect.custom')` method, *calls that method with unhardened arguments* during rendering. In a hardened SES world that is an unwanted authority leak: attacker-controlled inspect-custom code runs with arguments it should never see.
- **The fix.** If the passed-in `feralConsole` exposes the Node `Console` *constructor* and a `process` with `stdout`/`stderr` is reachable, the module builds a *private* `baseConsole = new Console({ stdout, stderr, inspectOptions: { customInspect: false } })`. Setting `customInspect: false` makes Node skip the deep custom-inspect scan entirely.
- **The graceful fallback.** Off Node (no `Console` constructor, or no `process.stdout`/`stderr`), `baseConsole` is just `feralConsole` unchanged — the circumvention is Node-specific and inert elsewhere.
- **The renaming consequence.** Every wrapper below now delegates to this private `baseConsole`, not to the raw argument. The argument was renamed `feralConsole` precisely to mark that it is *untrusted host material* that must be tamed before use — the same *feral-vs-tamed* vocabulary SES uses for the realm's intrinsics.

The four functions provided by `loggedErrorHandler`:

- **`getStackString(error)`** — returns the censored / shortened stack string (per cycle-93's tame-v8-error-constructor.js).
- **`tagError(error)`** — assigns and returns a unique tag like `err-3` for the error.
- **`takeMessageLogArgs(error)`** — drains the error's main message log-args (from the `details` template-tag).
- **`takeNoteLogArgsArray(error, callback)`** — drains the error's notes (from `assert.note` calls), passing each to the callback.

#### §extractErrorArgs — replacing errors with tags

```js
const extractErrorArgs = (logArgs, subErrorsSink) => {
  const argTags = arrayMap(logArgs, arg => {
    if (isError(arg)) {
      arrayPush(subErrorsSink, arg);
      return `(${tagError(arg)})`;
    }
    return arg;
  });
  return argTags;
};
```

The §pattern: **scan each argument for Error-ness; replace Errors with their tag-string; queue the actual Error onto the subErrorsSink for nested rendering**.

So a call like `console.error('Failed to send', err)` becomes:
- Visible log line: `Failed to send (err-3)`
- subErrorsSink: `[err]` — to be logged separately under the parent.

This is the *tag-instead-of-toString* discipline: errors are *referenced* by tag in the main log; the *full* error rendering happens in a nested section. Prevents the main log from being flooded with stack traces.

#### §logErrorInfo — render one annotation

```js
const logErrorInfo = (severity, error, kind, logArgs, subErrorsSink) => {
  const errorTag = tagError(error);
  const errorName =
    kind === ErrorInfo.MESSAGE ? `${errorTag}:` : `${errorTag} ${kind}`;
  const argTags = extractErrorArgs(logArgs, subErrorsSink);
  baseConsole[severity](errorName, ...argTags);
};
```

The §pattern:

- For `MESSAGE` kind: prefix `errorTag:` (e.g. `err-3:`).
- For `NOTE` / `CAUSE` / `ERRORS` kinds: prefix `errorTag KIND` (e.g. `err-3 cause:`).

Then call `baseConsole[severity](errorName, ...argTags)` with the tag-substituted args.

#### §logSubErrors — nested-error grouping

```js
const logSubErrors = (severity, subErrors, optTag = undefined) => {
  if (subErrors.length === 0) {
    return;
  }
  if (subErrors.length === 1 && optTag === undefined) {
    logError(severity, subErrors[0]);
    return;
  }
  let label;
  if (subErrors.length === 1) {
    label = `Nested error`;
  } else {
    label = `Nested ${subErrors.length} errors`;
  }
  if (optTag !== undefined) {
    label = `${label} under ${optTag}`;
  }
  baseConsole.group(label);
  try {
    for (const subError of subErrors) {
      logError(severity, subError);
    }
  } finally {
    if (baseConsole.groupEnd) {
      baseConsole.groupEnd();
    }
  }
};
```

The §three cases:

1. **No sub-errors** → no-op.
2. **Single sub-error, no parent tag** → just recursively log it; no group wrapper needed.
3. **Otherwise** → wrap in a `baseConsole.group(label)` / `baseConsole.groupEnd()` pair with label `Nested N errors under PARENT_TAG`.

The §group-label naming is the *human-readable-context* discipline: a reader sees `Nested 3 errors under err-2` and knows the three sub-errors are children of err-2.

The §try/finally around the group-end ensures the group is closed even if `logError` throws mid-iteration. The `if (baseConsole.groupEnd)` check is defensive — some base consoles may not implement `groupEnd`.

#### §errorsLogged WeakSet — re-logging prevention

```js
const errorsLogged = new WeakSet();
```

The §WeakSet tracks which errors have already been logged in the current session. The `logError` function early-returns if the error is already in the set:

```js
const logError = (severity, error) => {
  if (weaksetHas(errorsLogged, error)) {
    return;
  }
  // ...
  weaksetAdd(errorsLogged, error);
  // ...
};
```

The §discipline prevents *circular-reference infinite recursion* and *duplicate rendering* when an error appears in multiple slots (e.g. as both `cause` of one error and `errors[i]` of another aggregate).

#### §makeNoteCallback — annotation-arrived-after-the-fact

```js
const makeNoteCallback = severity => (error, noteLogArgs) => {
  const subErrors = [];
  logErrorInfo(severity, error, ErrorInfo.NOTE, noteLogArgs, subErrors);
  logSubErrors(severity, subErrors, tagError(error));
};
```

The §callback is what `takeNoteLogArgsArray` invokes when it finds an annotation. The §comment:

> Annotation arrived after the error has already been logged, so just log the annotation immediately, rather than remembering it.

The §timing-handling: notes are attached via `assert.note(error, X\`...\`)` *after* the error is constructed; they may arrive at the console after the error has already been logged. The callback emits the annotation immediately rather than queueing it.

#### §logError — the main render function

```js
const logError = (severity, error) => {
  if (weaksetHas(errorsLogged, error)) {
    return;
  }
  const errorTag = tagError(error);
  weaksetAdd(errorsLogged, error);
  const subErrors = [];
  const messageLogArgs = takeMessageLogArgs(error);
  const noteLogArgsArray = takeNoteLogArgsArray(
    error,
    makeNoteCallback(severity),
  );
  // Show the error's most informative error message
  if (messageLogArgs === undefined) {
    baseConsole[severity](`${errorTag}:`, error.message);
  } else {
    logErrorInfo(
      severity,
      error,
      ErrorInfo.MESSAGE,
      messageLogArgs,
      subErrors,
    );
  }
  // After the message but before any other annotations, show the stack.
  let stackString = getStackString(error);
  if (
    typeof stackString === 'string' &&
    stackString.length >= 1 &&
    !stringEndsWith(stackString, '\n')
  ) {
    stackString += '\n';
  }
  baseConsole[severity](stackString);
  // Show the other annotations on error
  if (error.cause) {
    logErrorInfo(severity, error, ErrorInfo.CAUSE, [error.cause], subErrors);
  }
  if (error.errors) {
    logErrorInfo(severity, error, ErrorInfo.ERRORS, error.errors, subErrors);
  }
  for (const noteLogArgs of noteLogArgsArray) {
    logErrorInfo(severity, error, ErrorInfo.NOTE, noteLogArgs, subErrors);
  }
  // explain all the errors seen in the messages already emitted.
  logSubErrors(severity, subErrors, errorTag);
};
```

The §logError sequence:

1. **Dedup-check** via `errorsLogged` WeakSet; early-return if already logged.
2. **Tag** the error and add to errorsLogged.
3. **Extract messageLogArgs and noteLogArgsArray** from the error.
4. **Render the main message**: messageLogArgs if available; otherwise `error.message`. The *most-informative-message rule*:
   > If there is one [messageLogArgs], we take it to be strictly more informative than the message string carried by the error, so show it *instead*.
5. **Render the stack** via `getStackString(error)`, with the *ensure-trailing-newline* fixup.
6. **Render `cause`** if present (chained-error pattern).
7. **Render `errors`** if present (AggregateError aggregation).
8. **Render each note** via `logErrorInfo` with `ErrorInfo.NOTE`.
9. **Recursively log sub-errors** under the parent's tag via `logSubErrors`.

The §sequence is *deterministic*: message → stack → cause → errors → notes → sub-errors. A reader scanning the console sees a *consistent rendering structure* for every error.

The §most-informative-message rule is structurally significant: the `details` template-tag produces a *richer* message than `error.message` (which is just a string); when both are present, the richer one wins.

### §The level / special / other wrappers (refreshed 2026-06-17)

The §closing lines (lines 519-585) construct the actual wrapped console. The 2026-06-17 refresh reorganized this in four ways: level wrappers now key on the method *name* (not the severity), call `sanitizeFormatData` before error-extraction, and call `baseConsole[name]` *unconditionally*; `assert` and `timeLog` get dedicated wrappers; and a *single* trailing `name in baseConsole` filter replaces the per-list existence guards.

```js
const levelMethods = arrayMap(consoleLevelMethods, ([name, level]) => {
  const levelMethod = defineName(name, (...logArgs) => {
    const subErrors = [];
    const argTags = extractErrorArgs(sanitizeFormatData(logArgs), subErrors);
    // eslint-disable-next-line @endo/no-polymorphic-call
    baseConsole[name](...argTags);
    logSubErrors(level, subErrors);
  });
  return [name, freeze(levelMethod)];
});

const assertMethod = defineName('assert', (...assertArgs) => {
  if (assertArgs.length <= 1) {
    baseConsole.assert(...assertArgs);
  } else {
    const [cond, ...logArgs] = assertArgs;
    const subErrors = [];
    const argTags = extractErrorArgs(sanitizeFormatData(logArgs), subErrors);
    baseConsole.assert(cond, ...argTags);
    logSubErrors('error', subErrors);
  }
});

const timeLogMethod = defineName('timeLog', (...timeLogArgs) => {
  if (timeLogArgs.length <= 1) {
    baseConsole.timeLog(...timeLogArgs);
  } else {
    const [label, ...logArgs] = timeLogArgs;
    const subErrors = [];
    const argTags = extractErrorArgs(sanitizeFormatData(logArgs), subErrors);
    baseConsole.timeLog(label, ...argTags);
    logSubErrors('log', subErrors);
  }
});

const otherMethods = arrayMap(consoleOtherMethods, ([name, _level]) => {
  const otherMethod = defineName(name, (...args) => {
    baseConsole[name](...args);
    return undefined;
  });
  return [name, freeze(otherMethod)];
});

const methodEntries = arrayFilter(
  [
    ...levelMethods,
    ['assert', assertMethod],
    ['timeLog', timeLogMethod],
    ...otherMethods,
  ],
  ([name, _]) => name in baseConsole,
);

const causalConsole = fromEntries(methodEntries);
return freeze(causalConsole);
```

The §structural difference between the three method families:

- **Level methods (debug/log/info/warn/error/trace/etc.)** extract errors from args and queue sub-errors. Args are first run through `sanitizeFormatData` (the new `%c`-stripper from section 1), then `extractErrorArgs`. The wrapper now destructures `[name, level]` and calls `baseConsole[name]` (the method name) rather than `baseConsole[level]` — a bug-class fix, since previously a severity like `'log'` shared by `trace`/`dirxml`/`group` would have collided. After the call, `logSubErrors(level, subErrors)` renders the nested errors at the paired severity.
- **Special methods (assert, timeLog)** get bespoke wrappers. Each keeps its leading argument verbatim (`assert`'s condition, `timeLog`'s label), sanitizes + error-extracts the *remaining* args, and renders sub-errors at the list's paired severity (`'error'` / `'log'`). The `length <= 1` short-circuit passes a no-extra-args call straight through.
- **Other methods (clear/dir/group/table/etc.)** pass through to `baseConsole[name]` *without* error extraction — pure proxies.

The §single-filter discipline (the `methodEntries` `arrayFilter` keyed on `name in baseConsole`) replaces the prior per-list guards. The old code used an inline `if (baseConsole[level])` existence check inside each level wrapper *and* a separate `otherMethodNames` filter; the refresh unifies both into one filter applied to the combined `[level..., assert, timeLog, other...]` entry list. The wrapped console therefore exposes exactly the permitted methods that the (tamed) `baseConsole` actually implements — the *defensive-binding* discipline, now expressed once.
