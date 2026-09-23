---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Sending event in a stack at T.E | The standard runtime address for a stack-frame's emission of an async send. |
| Receiving event at the bottom of a new turn | The microtask-top callback location; `this`-free. |
| `Caused by:` chain via assert.note | Multi-level diagnostic causality linkage; the causal console renders the chain on log. |
| Inert-fallback guard | When the instrumentation cannot run, return the input unchanged; caller behavior is unaffected. |
| `funcs.map(func => func && wrap(...))` | Sparse-array handling: undefined entries pass through. |
| TurnStarterFn this-free constraint | Engine-optimization-friendly + dispatch-independent constraint for microturn-top callbacks. |
