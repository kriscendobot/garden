---
title: Abstract
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

§trackTurns (lines 78-110) is the module's *public* entry-point and its JSDoc is the most quotable statement of the *causal model* the entire module instruments: *the call to `trackTurns` is itself a sending event, that occurs in some call stack in some turn number at some event number within that turn. Each call to any of the returned `TurnStartFn`s is a receiving event that begins a new turn. This sending event caused each of those receiving events.* The structural model is a directed bipartite chain — sending events fan out to multiple receiving events; each receiving event begins a new turn that may itself contain new sending events. The trackTurns body opens with an *inert-fallback guard*: `if (!ENABLED || typeof globalThis === 'undefined' || !globalThis.assert) return funcs;` — three conditions for *no instrumentation*. When instrumented, the body bumps `hiddenCurrentEvent += 1` (this trackTurns call is an event *within the current turn*), allocates a `sendingError = Error(\`Event: ${hiddenCurrentTurn}.${hiddenCurrentEvent}\`)` whose stack trace identifies *where in the calling code the sending event occurred*, and — if a `hiddenPriorError` exists from a prior wrapping — annotates the new sendingError with `Caused by: ${hiddenPriorError}` to build a causality chain. The returned array is `funcs.map(func => func && wrapFunction(func, sendingError, X))` — each function in the input list is wrapped with the same `sendingError` as their shared causal source. The `func && wrapFunction(...)` shape preserves undefined / null entries (a `TurnStarterFn` is the type `((...args) => any) | undefined`); the wrapping skips undefined entries. The §TurnStarterFn typedef (lines 112-117) closes the file: *An optional function that is not this-sensitive, expected to be called at bottom of stack to start a new turn.* The *this-free* constraint is significant: TurnStarterFns are dispatched without a receiver, so they cannot rely on `this`-bound state to identify themselves.
