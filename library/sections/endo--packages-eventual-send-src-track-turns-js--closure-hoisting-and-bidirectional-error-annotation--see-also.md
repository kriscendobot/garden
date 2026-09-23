---
title: See also
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

- [[eventual-send]] (topic) — the broader pipeline; wrapped TurnStarterFn calls happen at the top of each microturn.
- [[errors]] (topic) — `assert.note` is the annotation mechanism this section's wrap/rejection-note machinery feeds.
- `endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates` — the prior section in this source: cyclic-dependency disclaimer + global mutable state + env-option gates.
- `endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model` — the next section: the trackTurns JSDoc model of sending-events-causing-receiving-events.
- `endo--packages-marshal-src-marshal-js--error-diagnostic-priority` — adjacent comment-fragment: why the stack is deliberately not put on the wire; the marshal-side complement to track-turns' diagnostic-only state.
- `endo--packages-eventual-send-readme--use-in-tests` — patterns for testing eventually-sent code; complementary infrastructure.
