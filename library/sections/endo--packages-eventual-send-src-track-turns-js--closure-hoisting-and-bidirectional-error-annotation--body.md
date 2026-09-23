---
title: Body
source: packages/eventual-send/src/track-turns.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
source_lines: "33-76 (closure-hoisting rationale + addRejectionNote + wrapFunction with capture-now timing)"
topics: [eventual-send, errors]
status: current
notes: |
  The closure-hoisting comment is short but load-bearing — it names a
  *retention hazard* observed in practice (*HandledPromise arguments
  retained for a surprisingly long time*) and the structural fix
  (hoist the wrappers out of the calling function so the wrappers'
  closures don't hold onto unrelated state). The wrapFunction +
  addRejectionNote pair implements *bidirectional error annotation*:
  whichever way the wrapped function fails (synchronous throw or
  asynchronous rejection), the original sending-turn's address is
  attached as a `note` on the failure. The *must-capture-this-now*
  comment names a timing subtlety: the details-note string carries
  the *current* turn-and-event counters, which would shift before
  the catch handler runs.
parent: endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation
---

### §Closure-hoisting — discouraging long-lived closure captures

The §Closure-hoisting comment (lines 33-36):

> We hoist the following functions out of trackTurns() to discourage the closures from holding onto 'args' or 'func' longer than necessary, which we've seen cause HandledPromise arguments to be retained for a surprisingly long time.

The structural reading:

- **The hazard**: if `addRejectionNote` and `wrapFunction` were *defined inside* `trackTurns`, their closures would capture the entire `trackTurns` activation record — including `funcs`, `sendingError`, the destructured `X` and `annotateError`, and any other locals.
- **The HandledPromise-argument-retention observation**: in practice, the authors observed that `HandledPromise` arguments (the values the user passes to `E(target).method(...args)`) were being retained *for a surprisingly long time*. The closures held by track-turns were one source of the leak.
- **The fix**: hoist the wrappers to module scope. The closures now capture *only what's explicitly passed* — for `addRejectionNote`, only `detailsNote`; for `wrapFunction`, only `func`, `sendingError`, and `X`.

This is a *known-hazard-from-practice* discipline. The comment doesn't *prove* that hoisting fixes the retention issue; it *records the observation* that hoisting *was a fix in practice*. Generalizes to any module that creates closures inside frequently-called functions — *consider whether the closure captures more than it needs*.

The two hoisted functions:

**`addRejectionNote`** is a *curry*:

```js
const addRejectionNote = detailsNote => reason => {
  if (reason instanceof Error) {
    globalThis.assert.note(reason, detailsNote);
  }
  if (VERBOSE) {
    console.log('REJECTED at top of event loop', reason);
  }
};
```

The outer arrow takes the detailsNote and returns a function that takes the rejection reason. This shape is what `.catch(addRejectionNote(detailsNote))` needs — `.catch` takes a single-argument function. The curry lets the detailsNote be *captured at promise-creation time* but the rejection handler not fire until *promise-rejection time*.

**`wrapFunction`** is also a curry:

```js
const wrapFunction =
  (func, sendingError, X) =>
  (...args) => {
    // ... body that wraps func
  };
```

The outer arrow takes the three captures (func, sendingError, X) and returns the wrapped function with the same arity as `func` (via `(...args) =>`). The wrapped function is what `funcs.map(func => func && wrapFunction(func, sendingError, X))` returns to `trackTurns`'s caller.

### §wrapFunction — synchronous-throw annotation

The `wrapFunction` body opens with the three hidden-counter mutations:

```js
hiddenPriorError = sendingError;
hiddenCurrentTurn += 1;
hiddenCurrentEvent = 0;
```

The structural reading:

- **`hiddenPriorError = sendingError`**: install the *current sending-turn's address* as the prior-error. Any error annotated within this turn will reference *this sending turn* as the cause.
- **`hiddenCurrentTurn += 1`**: each call to a wrapped TurnStarterFn is a *new turn*. The turn-counter is bumped *unconditionally*.
- **`hiddenCurrentEvent = 0`**: each new turn starts at event zero. The within-turn event counter is reset.

The inner try/catch handles synchronous throws:

```js
try {
  result = func(...args);
} catch (err) {
  if (err instanceof Error) {
    globalThis.assert.note(
      err,
      X`Thrown from: ${hiddenPriorError}:${hiddenCurrentTurn}.${hiddenCurrentEvent}`,
    );
  }
  if (VERBOSE) {
    console.log('THROWN to top of event loop', err);
  }
  throw err;
}
```

Structural reading:

- **The try/catch is around the single `func(...args)` call**. Only the wrapped function's *synchronous* behavior is in scope.
- **The annotation `Thrown from: ...:T.E`** carries the sending-turn's error reference and the current turn-and-event counters.
- **The VERBOSE log fires before the re-throw**: `THROWN to top of event loop` for diagnostic visibility.
- **The error is re-thrown** so the outer caller sees the original behavior — track-turns *annotates* but does not *swallow* errors.

### §addRejectionNote — asynchronous-rejection annotation

After the inner try/catch returns successfully, the function captures the rejection-annotation immediately:

```js
// Must capture this now, not when the catch triggers.
const detailsNote = X`Rejection from: ${hiddenPriorError}:${hiddenCurrentTurn}.${hiddenCurrentEvent}`;
Promise.resolve(result).catch(addRejectionNote(detailsNote));
return result;
```

The *Must capture this now, not when the catch triggers* comment names the timing subtlety:

- **The detailsNote string is built immediately** (line 70). At this moment, `hiddenPriorError`, `hiddenCurrentTurn`, and `hiddenCurrentEvent` hold *the current sending-turn's address*.
- **`Promise.resolve(result).catch(addRejectionNote(detailsNote))`** uses the captured detailsNote *inside the catch handler*. By the time the catch handler runs (potentially in some later turn), the hidden-counters will have *shifted* (later trackTurns calls will have mutated them).
- **If detailsNote were built lazily *inside* `addRejectionNote`**, it would interpolate the *then-current* counters — the wrong ones. The annotation would carry the wrong turn-and-event.

The fix is *capture the counters now, use them later*. The comment names the rule explicitly because the timing is non-obvious — a reader scanning the code might think *the catch handler builds the message at rejection time*, but the message must be built *at promise-creation time*.

The `addRejectionNote` function then:

```js
const addRejectionNote = detailsNote => reason => {
  if (reason instanceof Error) {
    globalThis.assert.note(reason, detailsNote);
  }
  if (VERBOSE) {
    console.log('REJECTED at top of event loop', reason);
  }
};
```

- **Annotates if the reason is an Error** (`assert.note(reason, detailsNote)`).
- **Logs `REJECTED at top of event loop`** if VERBOSE.

The two log strings — `THROWN to top of event loop` (sync) and `REJECTED at top of event loop` (async) — distinguish the failure mode in the console output. A developer scanning logs can immediately see which path failed.

### §The `finally` clear — preventing inter-turn cross-contamination

The `wrapFunction` body ends with:

```js
} finally {
  hiddenPriorError = undefined;
}
```

The structural reading:

- **`finally` runs whether the try-block threw, the try-block returned normally, or the promise-creation chain completed**. The `hiddenPriorError` is cleared *unconditionally*.
- **The clear prevents inter-turn cross-contamination**: if `hiddenPriorError` remained set after this turn, a *subsequent* unrelated `trackTurns` call (in a later turn) could find the stale value and incorrectly attribute its causality.
- **The next `trackTurns` call** (which is *itself* a sending event) will then set `hiddenPriorError = undefined` initially, and the *if (hiddenPriorError !== undefined) annotateError(sendingError, X\`Caused by: ${hiddenPriorError}\`)* line in `trackTurns` will correctly skip the annotation.

The *clear-on-exit* discipline is the *don't-leak-state-across-turn-boundaries* pattern. The hidden counters (`hiddenCurrentTurn` and `hiddenCurrentEvent`) are not cleared — they accumulate across turns by design — but `hiddenPriorError` is *per-call* and must be cleared.
