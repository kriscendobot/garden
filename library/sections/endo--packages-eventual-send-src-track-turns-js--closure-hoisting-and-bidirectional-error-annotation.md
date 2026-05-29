---
title: The closure-hoisting discipline that prevents HandledPromise argument retention; the bidirectional error-annotation construction (wrapFunction handles synchronous throws; addRejectionNote handles asynchronous rejections); the *must-capture-this-now* timing rule that captures the details-note before the catch triggers; the `THROWN to top of event loop` vs `REJECTED at top of event loop` log distinction
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
---

## Abstract

§Closure-hoisting (lines 33-36) names a *retention hazard* the module's authors observed: *we hoist the following functions out of trackTurns() to discourage the closures from holding onto 'args' or 'func' longer than necessary, which we've seen cause HandledPromise arguments to be retained for a surprisingly long time*. The structural fix: hoist `addRejectionNote` and `wrapFunction` to module scope so the closures they create capture only the arguments explicitly passed (`func`, `sendingError`, `X`), not the whole `trackTurns` activation record. The §wrapFunction body (lines 47-76) implements *bidirectional error annotation*: when the wrapped TurnStarterFn is called, the module mutates the three hidden-counters (`hiddenPriorError = sendingError; hiddenCurrentTurn += 1; hiddenCurrentEvent = 0`), then runs `func(...args)` inside two nested try/catch blocks. **The inner try/catch handles synchronous throws**: any Error thrown synchronously by `func` is annotated with `X\`Thrown from: ${hiddenPriorError}:${hiddenCurrentTurn}.${hiddenCurrentEvent}\`` and re-thrown; the optional VERBOSE log writes `THROWN to top of event loop`. **The asynchronous-rejection annotation uses `Promise.resolve(result).catch(addRejectionNote(detailsNote))`**: the result is treated as a thenable; if it eventually rejects, `addRejectionNote` annotates the rejection reason with the captured detailsNote. The *must capture this now, not when the catch triggers* comment (line 69) names the timing subtlety: the detailsNote is *built immediately* in line 70 (just before `Promise.resolve(result)`), so the `hiddenCurrentTurn` and `hiddenCurrentEvent` values it interpolates are *the current ones*; if the detailsNote were built lazily *inside* the catch, the counters might have shifted by the time the rejection arrives, and the annotation would carry the wrong turn-and-event. The `finally` block clears `hiddenPriorError` to undefined so subsequent same-turn events don't inherit the prior error's annotation.

## Body

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

## Connection to the wider library

This section is the **canonical worked example of *bidirectional-error-annotation-with-must-capture-this-now-timing*** at the @endo/eventual-send pipeline level. Three threads:

1. **The closure-hoisting discipline as retention mitigation.** A *known-hazard-from-practice* observation — HandledPromise arguments retained for a surprisingly long time — that hoisting closures out of frequently-called functions can mitigate. Generalizes to any module that creates closures in hot paths.

2. **The bidirectional-error-annotation pattern.** Wrap a function and annotate *both* synchronous throws *and* asynchronous rejections with the same source-context. The two-channel-handling shape (try/catch for sync; `.catch` for async) is reusable for any annotation framework.

3. **The must-capture-this-now timing discipline.** When mutable state evolves between *handler-registration time* and *handler-invocation time*, the handler must capture the relevant state *eagerly* at registration time and refer to the capture, not the live state. Reusable for any deferred-execution pattern.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Closure-hoisting to module scope | Minimize closure capture; hoist helper functions to module scope rather than nesting in hot-path callers. |
| HandledPromise argument retention | A specific instance of the closure-retention class; observed in practice, fixed by hoisting. |
| Bidirectional error annotation | Wrap a function to annotate *both* sync throws and async rejections; two separate handler-channels share the source-context. |
| Must capture this now, not when the catch triggers | Eager capture of mutable state at registration time; lazy reference inside handler. |
| `THROWN to top of event loop` vs `REJECTED at top of event loop` | Distinct log strings for distinct failure modes; developer can grep the log to find which path failed. |
| `finally` clear of per-call state | Don't leak per-call state across turn boundaries; clear deterministically on exit. |

## See also

- [[eventual-send]] (topic) — the broader pipeline; wrapped TurnStarterFn calls happen at the top of each microturn.
- [[errors]] (topic) — `assert.note` is the annotation mechanism this section's wrap/rejection-note machinery feeds.
- `endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates` — the prior section in this source: cyclic-dependency disclaimer + global mutable state + env-option gates.
- `endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model` — the next section: the trackTurns JSDoc model of sending-events-causing-receiving-events.
- `endo--packages-marshal-src-marshal-js--error-diagnostic-priority` — adjacent comment-fragment: why the stack is deliberately not put on the wire; the marshal-side complement to track-turns' diagnostic-only state.
- `endo--packages-eventual-send-readme--use-in-tests` — patterns for testing eventually-sent code; complementary infrastructure.

## Common confusions

- **"The closure-hoisting is premature optimization."** It is *practice-driven*: the comment says *we've seen cause HandledPromise arguments to be retained for a surprisingly long time*. The discipline came from a real observation, not from theoretical fear. Without the hoist, the closures held onto more than they needed; with the hoist, the retention shrinks.
- **"Synchronous throw and asynchronous rejection should be unified."** They cannot be from JavaScript's perspective: the synchronous throw bubbles up the call stack immediately; the asynchronous rejection arrives via a microtask. The two annotation channels (try/catch for sync; `.catch` for async) are *necessary*, not duplicative.
- **"The detailsNote should be lazy."** It cannot be: by the time the catch handler runs, the hidden-counters will have shifted. The eager-capture is *required by the timing*. The *Must capture this now, not when the catch triggers* comment names this directly.
- **"`Promise.resolve(result)` may double-wrap a promise."** It is *idempotent for thenables*: `Promise.resolve(p)` is identical to `p` when `p` is already a Promise. For non-thenables, `Promise.resolve(x)` wraps `x` in a resolved Promise. Both behaviors are what we want: thenables get `.catch` for rejection-annotation; non-thenables get no-op behavior (the `.catch` never fires).
- **"The `finally` clear is unnecessary."** It is necessary: without the clear, `hiddenPriorError` would *persist* across turn boundaries, and the next sending-event would be misattributed as *caused by* the stale prior error. The clear is the per-call hygiene.
- **"`assert.note` is a side effect."** It mutates the Error object's notes-list. The Error is being thrown or rejected; annotating it doesn't affect *what happens next*, only what the causal-console shows when the Error eventually lands somewhere that logs it. This is the meta-level-privilege framing from the prior section's discipline.
