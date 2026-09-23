---
title: Common confusions
source: packages/eventual-send/src/track-turns.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
source_lines: "78-117 (trackTurns JSDoc + body + TurnStarterFn typedef)"
topics: [eventual-send, errors, capability-theory]
status: current
parent: endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model
---

- **"`Caused by:` is a logging mechanism."** It is also a *structural-causality assertion*: the new sending event is *causally downstream* of the prior error's sending event. The annotation captures *what caused this code to run*, not merely *what logs to print*.
- **"Each `trackTurns` call wraps a single function."** It wraps a *list* of functions (`funcs`). All functions in one call share the *same* sendingError. They are *co-emitted from one sending event*.
- **"The TurnStarterFn typedef is just documentation."** It is also a *contract*: callers of `trackTurns` should pass only `this`-free functions, and the wrapped functions should be called from the microturn-top. Violating either invariant breaks the model.
- **"sendingError needs a real call site."** `Error(...)` allocates a fresh Error with its `.stack` populated by the engine — the stack identifies *where in the caller's code the `trackTurns` call originated*. This is *real call-site information* even though the Error is allocated programmatically rather than thrown.
- **"The fallback returns funcs unchanged but the type changes."** No — the fallback returns the input as-is, so the type is preserved exactly. The `/** @type {T} */` cast in the wrapped-return path is needed because `funcs.map(...)` returns the same shape but TypeScript can't infer the identity; the cast asserts type-equivalence.
- **"`hiddenCurrentEvent` rolls over forever."** It is a JavaScript Number, which can grow to `Number.MAX_SAFE_INTEGER` (~9e15) before precision loss. For practical purposes, this never rolls over within a process lifetime.
- **"Inside a `trackTurns` call, you can re-enter `trackTurns`."** Yes — and that's how the causality chain forms. A wrapped TurnStarterFn that calls trackTurns synchronously *during its receiving-event's turn* will see `hiddenPriorError` set to its own sending-event, and the new trackTurns call will link its new sendingError as `Caused by: <previous-turn's-sending-error>`.
