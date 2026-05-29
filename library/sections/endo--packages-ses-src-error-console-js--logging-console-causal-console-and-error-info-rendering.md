---
title: The makeLoggingConsoleKit *delayed-application-buffer* pair (loggingConsole that captures all calls into a logArray + takeLog that drains and returns the captured array); pumpLogToConsole that replays captured calls onto a baseConsole; the makeCausalConsole core with extractErrorArgs (swaps Error arguments for `(errorTag)` strings); logErrorInfo for emitting one error-annotation; logSubErrors for nested-error grouping; errorsLogged WeakSet preventing re-logging; logError as the main *render-one-error-with-all-its-annotations* function with the *most-informative-message* rule that uses messageLogArgs over `error.message` when available
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "159-415 (makeLoggingConsoleKit + pumpLogToConsole + makeCausalConsole + logError + ErrorInfo)"
topics: [hardened-javascript, errors]
status: current
---

## Abstract

The §middle cluster of `console.js` defines the *logging console* (a delayed-application-buffer that captures all method calls into a logArray) and the *causal console* (the actual error-aware wrapper that the rest of the SES error-handling subsystem uses). **makeLoggingConsoleKit** (lines 161-198) builds a `loggingConsole` whose every method is `(...args) => arrayPush(logArray, [name, ...args])` — *not frozen* logArray, drained on `takeLog()`. The *delayed-application* shape lets a `loggingConsole` be used as a *buffer* to delay the application of console calls until a real `baseConsole` is available; **pumpLogToConsole** (lines 209-214) replays captured log entries onto a `baseConsole`. The §ErrorInfo constants (lines 217-224) name four kinds of error-info-rendering: `NOTE`, `MESSAGE`, `CAUSE`, `ERRORS`. **makeCausalConsole** (lines 227-415) is the structural core. It receives a `baseConsole` and a `loggedErrorHandler` (which provides `getStackString`, `tagError`, `takeMessageLogArgs`, `takeNoteLogArgsArray`). The *extractErrorArgs* helper (lines 240-249) walks logArgs and *replaces each Error argument with a `(errorTag)` string while pushing the error itself onto subErrorsSink* — so the user-visible log line shows the *tag* (e.g. `(err-3)`) while the actual error is queued for nested rendering. *logErrorInfo* (lines 258-265) renders one annotation: `errorTag: <message>` or `errorTag <kind> <args>`. *logSubErrors* (lines 275-306) renders the nested-error block: zero → no-op; one with no tag → recurse-and-log; otherwise wrap in a `baseConsole.group(label)` / `baseConsole.groupEnd()` pair with label `Nested N errors under tag`. The *errorsLogged WeakSet* (line 308) prevents re-logging of the same error if it appears multiple times in the same logging session. *makeNoteCallback* (lines 311-317) handles the *annotation-arrived-after-error-already-logged* case: *just log the annotation immediately, rather than remembering it*. The structural payload is **logError** (lines 323-377) — the *render-one-error-with-all-its-annotations* function. The *most-informative-message rule* (lines 335-351): if `takeMessageLogArgs(error)` returns undefined, render `errorTag: error.message`; otherwise render the messageLogArgs *instead* (taking the more-informative one). The function then renders the stack via `getStackString`, then the four annotation kinds (NOTE / MESSAGE / CAUSE / ERRORS), then recursively logs all sub-errors. The closing lines (lines 379-414) construct the level-method wrappers (debug/log/info/warn/error/trace/...) and the other-method wrappers (assert/timeLog/dir/group/...). The level methods *extract errors* and *log sub-errors after the main log entry*; the other methods *pass through* to baseConsole unchanged.

## Body

### §makeLoggingConsoleKit — the delayed-application buffer

The §logging-console subsection (lines 159-198):

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

The §pumpLogToConsole function (lines 209-214):

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

The §ErrorInfo constants (lines 217-224):

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

The §causal-console subsection (lines 227-415) is the largest in the file. It receives:

```js
export const makeCausalConsole = (baseConsole, loggedErrorHandler) => {
  if (!baseConsole) {
    return undefined;
  }

  const { getStackString, tagError, takeMessageLogArgs, takeNoteLogArgsArray } =
    loggedErrorHandler;
  // ...
```

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

### §The level-method and other-method wrappers

The §closing lines (lines 379-414) construct the actual wrapped console:

```js
const levelMethods = arrayMap(consoleLevelMethods, ([level, _]) => {
  const levelMethod = defineName(level, (...logArgs) => {
    const subErrors = [];
    const argTags = extractErrorArgs(logArgs, subErrors);
    if (baseConsole[level]) {
      baseConsole[level](...argTags);
    }
    logSubErrors(level, subErrors);
  });
  return [level, freeze(levelMethod)];
});
const otherMethodNames = arrayFilter(
  consoleOtherMethods,
  ([name, _]) => name in baseConsole,
);
const otherMethods = arrayMap(otherMethodNames, ([name, _]) => {
  const otherMethod = defineName(name, (...args) => {
    baseConsole[name](...args);
    return undefined;
  });
  return [name, freeze(otherMethod)];
});

const causalConsole = fromEntries([...levelMethods, ...otherMethods]);
return freeze(causalConsole);
```

The §structural difference between level and other methods:

- **Level methods (debug/log/info/warn/error/trace/etc.)** extract errors from args and queue sub-errors. After calling `baseConsole[level]` with the tag-substituted args, `logSubErrors(level, subErrors)` renders the nested errors.
- **Other methods (assert/timeLog/clear/etc.)** pass through to `baseConsole[name]` *without* error extraction. They are pass-through proxies.

The §`otherMethodNames` filter (line 395-397) drops other-methods that the baseConsole doesn't implement. The level methods are *always* wrapped; the other methods are *conditionally* wrapped.

The §existence-check pattern (`if (baseConsole[level])`) is the *defensive-binding* discipline: not every baseConsole implements every method. The wrapping silently no-ops on missing methods.

## Connection to the wider library

This section is the **canonical worked example of *causal-console-as-structured-error-renderer***. Three threads:

1. **The capture-then-replay logging buffer.** Reusable for any test infrastructure that wants deterministic-console-output assertions. The `makeLoggingConsoleKit` + `pumpLogToConsole` pair is reusable as-is.

2. **The tag-instead-of-toString discipline for nested errors.** Errors render once with a tag (`err-3`); the tag appears wherever the error is referenced; the actual rendering happens once per error in a nested group. Prevents log-flood while preserving structural relationships.

3. **The most-informative-message rule.** When two sources of error-content disagree (the `details`-template-tag args vs the plain `error.message` string), the richer source wins. Reusable for any system with multiple-source content.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `makeLoggingConsoleKit` + `takeLog` | Capture-then-replay test infrastructure; the canonical *defer-log-until-needed* pattern. |
| `pumpLogToConsole` | Replay captured log entries onto a real console for debugging. |
| `extractErrorArgs` swap-Error-for-tag-string | The *render-once-reference-by-tag* discipline; prevents log flood. |
| `ErrorInfo.NOTE / MESSAGE / CAUSE / ERRORS` | The four-kind structured-error model; reusable for any error-rendering subsystem. |
| `errorsLogged` WeakSet | Dedup-with-WeakSet for arbitrary-graph rendering; prevents infinite recursion. |
| Most-informative-message rule | Multi-source content: richer source wins; document which sources exist. |
| `if (baseConsole[level])` defensive binding | Optional-method wrapping; silent no-op on missing methods. |
| `assert.note(error, X\`...\`)` callback timing | The *annotation-arrived-after-the-fact* case; emit immediately rather than queue. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate.
- [[errors]] (topic) — the broader SES error-handling surface.
- `endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists` — the first section in this source: the no-special-privilege axiom + permit lists this section uses.
- `endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console` — the third section: AVA t.log adapter + filter console.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the track-turns module that *produces* the notes this section renders via `takeNoteLogArgsArray`. Track-turns annotates; this console renders the annotations.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns` (cycle 93) — the `getStackString` capability this section calls comes from there. The two cycles together describe the full *stack-attenuation-plus-rendering* pipeline.
- `endo--packages-pass-style-src-error-js--*` (cycle 87) — pass-style's error-validation; this console handles errors that pass-style validates.

## Common confusions

- **"`takeLog()` doesn't deep-freeze the entries."** It freezes the *outer* array — the entries themselves (which include arrays of args) are not deep-frozen. A consumer that mutates an arg-array would corrupt the captured log. The §discipline is *capture-and-don't-mutate*; the freezing is documentation, not enforcement.
- **"`extractErrorArgs` is too eager — what if I want to log the error normally?"** The level-method wrappers always extract; that's the *causal-console contract*. If you want to log an error *as a plain object*, wrap it: `console.log({ err })`. The plain `console.log(err)` triggers extraction.
- **"`errorsLogged` is a memory leak."** It uses a `WeakSet` — when the error is GC'd, the entry vanishes. The dedup-cache is scoped to the lifetime of the errors, not the console.
- **"The `if (subErrors.length === 1 && optTag === undefined)` special case is fragile."** It is the *single-error-without-explicit-parent-tag-can-render-flat* optimization. Without it, every single-sub-error case would emit a degenerate one-element group. The optimization keeps the log readable.
- **"The most-informative-message rule loses `error.message`."** It loses the *string* form. The richer `messageLogArgs` form *contains* equivalent or richer information. If a developer needs the plain message, they can read `error.message` directly (it's still on the object).
- **"`baseConsole.group(label)` then `baseConsole.groupEnd()` may not be balanced if `logError` throws."** The try/finally around the group-end ensures balance — even if `logError` throws mid-iteration, the `finally` block calls `groupEnd()`. The defense is explicit.
- **"`takeMessageLogArgs(error)` drains the args — what if I call it twice?"** The *take-once* pattern is intentional: the args are consumed at logging time so they can't be re-logged. If a developer wants to inspect the args, they should do so before the error reaches the console.
