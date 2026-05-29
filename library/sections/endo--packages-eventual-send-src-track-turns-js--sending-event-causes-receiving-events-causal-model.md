---
title: The trackTurns JSDoc causal model — each call to trackTurns is itself a sending event in some turn at some event-within-turn, and each subsequent call to the returned TurnStarterFns is a receiving event that begins a new turn; the sending event *caused* each of the receiving events. The early-return guard for ENABLED / globalThis / globalThis.assert as the *inert-fallback* discipline. The `Caused by:` chain that links the new sending-event to the prior turn's prior-error. The TurnStarterFn typedef as the type-level closure of the model
source: packages/eventual-send/src/track-turns.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
source_lines: "78-117 (trackTurns JSDoc + body + TurnStarterFn typedef)"
topics: [eventual-send, errors, capability-theory]
status: current
---

## Abstract

§trackTurns (lines 78-110) is the module's *public* entry-point and its JSDoc is the most quotable statement of the *causal model* the entire module instruments: *the call to `trackTurns` is itself a sending event, that occurs in some call stack in some turn number at some event number within that turn. Each call to any of the returned `TurnStartFn`s is a receiving event that begins a new turn. This sending event caused each of those receiving events.* The structural model is a directed bipartite chain — sending events fan out to multiple receiving events; each receiving event begins a new turn that may itself contain new sending events. The trackTurns body opens with an *inert-fallback guard*: `if (!ENABLED || typeof globalThis === 'undefined' || !globalThis.assert) return funcs;` — three conditions for *no instrumentation*. When instrumented, the body bumps `hiddenCurrentEvent += 1` (this trackTurns call is an event *within the current turn*), allocates a `sendingError = Error(\`Event: ${hiddenCurrentTurn}.${hiddenCurrentEvent}\`)` whose stack trace identifies *where in the calling code the sending event occurred*, and — if a `hiddenPriorError` exists from a prior wrapping — annotates the new sendingError with `Caused by: ${hiddenPriorError}` to build a causality chain. The returned array is `funcs.map(func => func && wrapFunction(func, sendingError, X))` — each function in the input list is wrapped with the same `sendingError` as their shared causal source. The `func && wrapFunction(...)` shape preserves undefined / null entries (a `TurnStarterFn` is the type `((...args) => any) | undefined`); the wrapping skips undefined entries. The §TurnStarterFn typedef (lines 112-117) closes the file: *An optional function that is not this-sensitive, expected to be called at bottom of stack to start a new turn.* The *this-free* constraint is significant: TurnStarterFns are dispatched without a receiver, so they cannot rely on `this`-bound state to identify themselves.

## Body

### §The causal model — sending events cause receiving events

The §trackTurns JSDoc is the *single most quotable* paragraph in this module:

> The call to `trackTurns` is itself a sending event, that occurs in some call stack in some turn number at some event number within that turn. Each call to any of the returned `TurnStartFn`s is a receiving event that begins a new turn. This sending event caused each of those receiving events.

The structural reading:

- **`trackTurns(funcs)` is a *sending event***. The caller is in *some* turn (counter `hiddenCurrentTurn`) at *some* event-within-turn (counter `hiddenCurrentEvent`, bumped by 1 at the start of `trackTurns`'s body). This sending event has an address `T.E`.
- **Each returned TurnStarterFn, when called, is a *receiving event***. The receiving event *begins a new turn* (`hiddenCurrentTurn += 1` in `wrapFunction`).
- **The sending event caused each receiving event** — the `hiddenPriorError = sendingError` assignment in `wrapFunction` makes the sending-event's address the receiving-event's *prior-error reference*.

The model is a *directed bipartite chain*:

```
turn T:
  sending event T.1 ──┬──> receiving event (new turn T+1)
                      ├──> receiving event (new turn T+2)
                      └──> receiving event (new turn T+3)
  ...
  sending event T.k ──> ...
```

Each sending event can fan out to multiple receiving events (since `trackTurns` takes a list of TurnStarterFns). Each receiving event begins a new turn that may itself contain new sending events, building a tree of causality.

This causal model is what the §Drossopoulou-Noble-Miller-Murray 2015 paper (cycle 85) would call the *event-causality DAG* at the runtime level; cycle 89's chat-voice-command-parser drives this same DAG at the UI level (each voice-issued send is the receiving event of the parser's sending event). The general pattern: **sending events are stack-located; receiving events are at-the-bottom-of-a-new-stack; the causality link is the sendingError reference**.

### §The inert-fallback guard

The trackTurns body opens with a three-condition guard:

```js
export const trackTurns = funcs => {
  if (!ENABLED || typeof globalThis === 'undefined' || !globalThis.assert) {
    return funcs;
  }
  // ... instrumentation body
};
```

The three conditions:

1. **`!ENABLED`** — the feature is gated by `TRACK_TURNS=enabled`. When not enabled, the module is fully inert.
2. **`typeof globalThis === 'undefined'`** — defensive check for environments where `globalThis` is not yet defined (very early bootstrapping, pre-ES2020 environments without polyfill). Returns the input funcs unchanged.
3. **`!globalThis.assert`** — the SES `assert` global has not been installed. Pre-lockdown environments fall here. Returns the input funcs unchanged.

The *inert-fallback* discipline: **when track-turns cannot run, it returns the input unchanged**. The caller's behavior is *identical* whether the feature is enabled or not — the only difference is whether the diagnostic surface shows additional causality annotation. This is the *zero-impact-when-disabled* property that lets `trackTurns` be called *everywhere* in the eventual-send pipeline without performance concern when the feature is off.

The §inert-fallback pattern is reusable: a module that *instruments* another module's behavior should *fall back to no instrumentation* when its preconditions don't hold. The caller's behavior should be the same in both cases.

### §The sendingError and the Caused-by chain

After the guard passes, the body runs:

```js
const { details: X, note: annotateError } = globalThis.assert;

hiddenCurrentEvent += 1;
const sendingError = Error(
  `Event: ${hiddenCurrentTurn}.${hiddenCurrentEvent}`,
);
if (hiddenPriorError !== undefined) {
  annotateError(sendingError, X`Caused by: ${hiddenPriorError}`);
}

return /** @type {T} */ (
  funcs.map(func => func && wrapFunction(func, sendingError, X))
);
```

Structural reading line by line:

- **`{ details: X, note: annotateError } = globalThis.assert`** — pull the two SES `assert` helpers. `details` (renamed `X` per local convention) is the template-tag for building diagnostic messages; `note` is the function that attaches the message to an Error as a note.

- **`hiddenCurrentEvent += 1`** — this `trackTurns` call is *another event* within the current turn. Two consecutive `trackTurns` calls in the same turn produce events `T.1` and `T.2`.

- **`sendingError = Error(\`Event: T.E\`)`** — allocate a regular `Error` object whose `.message` carries the turn-and-event address *as a label* and whose `.stack` (when read) shows where in the caller's code the `trackTurns` call originated. The stack is the *most diagnostically valuable* part — when a future rejection's annotation references this sendingError, the developer can follow the .stack to see *where the sending happened*.

- **`if (hiddenPriorError !== undefined) annotateError(sendingError, X\`Caused by: ${hiddenPriorError}\`)`** — if the calling code is *itself inside a wrapped TurnStarterFn* (so `hiddenPriorError` is set), annotate the new sendingError with `Caused by: <previous-turn's-sending-error>`. This builds the **causality chain**: trackTurns calls inside other trackTurns-instrumented turns get their sendingErrors *linked* to the outer cause.

The chain unrolls: a deeply-nested rejection's annotation can carry *Rejection from: T1.E1, Caused by: T0.E0, Caused by: T-1.E-1, ...* — the full causal lineage of *every sending-event that contributed* to the eventual rejection.

- **`funcs.map(func => func && wrapFunction(func, sendingError, X))`** — wrap each input function. The `func && ...` short-circuit handles `undefined` entries (a TurnStarterFn is the type `((...args) => any) | undefined`); undefined entries pass through unchanged so the array's structure is preserved.

The *one-sendingError-per-trackTurns-call* discipline is important: all functions returned by a single `trackTurns` call share the *same* sendingError. They are *causally co-emitted* from the same sending event. Multiple subsequent rejections will all reference *the same* sending event as their cause.

### §The TurnStarterFn typedef — *this*-free dispatch

The file closes with:

```js
/**
 * An optional function that is not this-sensitive, expected to be called at
 * bottom of stack to start a new turn.
 *
 * @typedef {((...args: any[]) => any) | undefined} TurnStarterFn
 */
```

Two structural constraints:

1. **`(...args: any[]) => any) | undefined`**: a TurnStarterFn is *either* a function of any arity returning anything *or* undefined. The `| undefined` allows trackTurns callers to pass *sparse* arrays (some slots filled, some not).

2. **Not this-sensitive**: the function's behavior must not depend on `this`. Why? Because TurnStarterFns are dispatched without a receiver — the JS engine calls them at *the bottom of the stack* (the microturn-top), and `this` is `undefined` (strict mode) or the global object (sloppy mode). A `this`-sensitive function would not work correctly.

3. **Called at bottom of stack to start a new turn**: each TurnStarterFn call is a microturn-top — there's no outer JavaScript stack frame between the engine's microtask scheduler and the TurnStarterFn. The wrap-function's `hiddenCurrentTurn += 1` is therefore *guaranteed* to coincide with the start of a new microturn.

The *this-free* constraint is structurally significant: it lets the JS engine optimize the dispatch (no this-binding to compute) and ensures the wrapped TurnStarterFn's behavior is independent of *how* the engine called it.

## Connection to the wider library

This section is the **canonical worked example of *runtime causal-event tracking via stack-located sending events and at-the-bottom-of-a-new-stack receiving events*** at the @endo/eventual-send level. Three threads:

1. **The sending-event-causes-receiving-events model** generalizes beyond track-turns. Any pipeline where *some code in a stack causes some code at the bottom of a future stack to run* can be modeled with this DAG. The library can cite this section whenever a design needs to reason about *causality across asynchronous boundaries*.

2. **The inert-fallback guard pattern**. Three-condition fallback (feature-flag off OR environment incomplete OR SES not installed) returns the input unchanged. Reusable for any instrumentation module that should disappear when preconditions don't hold.

3. **The Caused-by chain construction**. Eagerly link new sending-events to prior-error references via `annotateError(newError, X\`Caused by: ${priorError}\`)`. Builds an unbounded-depth causal chain that the causal-console traverses on display.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Sending event in a stack at T.E | The standard runtime address for a stack-frame's emission of an async send. |
| Receiving event at the bottom of a new turn | The microtask-top callback location; `this`-free. |
| `Caused by:` chain via assert.note | Multi-level diagnostic causality linkage; the causal console renders the chain on log. |
| Inert-fallback guard | When the instrumentation cannot run, return the input unchanged; caller behavior is unaffected. |
| `funcs.map(func => func && wrap(...))` | Sparse-array handling: undefined entries pass through. |
| TurnStarterFn this-free constraint | Engine-optimization-friendly + dispatch-independent constraint for microturn-top callbacks. |

## See also

- [[eventual-send]] (topic) — the pipeline this instruments; `E(target).method(...args)` produces a sending event that schedules a receiving event in the target's vat.
- [[errors]] (topic) — the causal console + assert.note machinery this section feeds.
- [[capability-theory]] (topic) — the sending-event-causes-receiving-events DAG is the runtime instance of the Drossopoulou-Noble-Miller-Murray 2015 paper's *only-connectivity-begets-connectivity* axiom.
- `endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates` — the first section: the disclaimers and gates that determine when this section's instrumentation runs.
- `endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation` — the second section: the wrapFunction / addRejectionNote machinery that the returned TurnStarterFns invoke.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining` — eventual-send + promise-pipelining; this section's causal model is what makes the diagnostic surface track the pipelined chain.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — partial-failure + when-catch; broken-reference rejections carry the causality chain when the call site is many turns away.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--hoare-four-tuples-and-code-agnostic-rules` — the formal Hoare logic; track-turns' runtime causal-event DAG is the operational counterpart to the *METH-CALL-2* postcondition that bounds reachability after a method call.

## Common confusions

- **"`Caused by:` is a logging mechanism."** It is also a *structural-causality assertion*: the new sending event is *causally downstream* of the prior error's sending event. The annotation captures *what caused this code to run*, not merely *what logs to print*.
- **"Each `trackTurns` call wraps a single function."** It wraps a *list* of functions (`funcs`). All functions in one call share the *same* sendingError. They are *co-emitted from one sending event*.
- **"The TurnStarterFn typedef is just documentation."** It is also a *contract*: callers of `trackTurns` should pass only `this`-free functions, and the wrapped functions should be called from the microturn-top. Violating either invariant breaks the model.
- **"sendingError needs a real call site."** `Error(...)` allocates a fresh Error with its `.stack` populated by the engine — the stack identifies *where in the caller's code the `trackTurns` call originated*. This is *real call-site information* even though the Error is allocated programmatically rather than thrown.
- **"The fallback returns funcs unchanged but the type changes."** No — the fallback returns the input as-is, so the type is preserved exactly. The `/** @type {T} */` cast in the wrapped-return path is needed because `funcs.map(...)` returns the same shape but TypeScript can't infer the identity; the cast asserts type-equivalence.
- **"`hiddenCurrentEvent` rolls over forever."** It is a JavaScript Number, which can grow to `Number.MAX_SAFE_INTEGER` (~9e15) before precision loss. For practical purposes, this never rolls over within a process lifetime.
- **"Inside a `trackTurns` call, you can re-enter `trackTurns`."** Yes — and that's how the causality chain forms. A wrapped TurnStarterFn that calls trackTurns synchronously *during its receiving-event's turn* will see `hiddenPriorError` set to its own sending-event, and the new trackTurns call will link its new sendingError as `Caused by: <previous-turn's-sending-error>`.
