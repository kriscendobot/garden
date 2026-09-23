---
title: Common confusions
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

- **"The closure-hoisting is premature optimization."** It is *practice-driven*: the comment says *we've seen cause HandledPromise arguments to be retained for a surprisingly long time*. The discipline came from a real observation, not from theoretical fear. Without the hoist, the closures held onto more than they needed; with the hoist, the retention shrinks.
- **"Synchronous throw and asynchronous rejection should be unified."** They cannot be from JavaScript's perspective: the synchronous throw bubbles up the call stack immediately; the asynchronous rejection arrives via a microtask. The two annotation channels (try/catch for sync; `.catch` for async) are *necessary*, not duplicative.
- **"The detailsNote should be lazy."** It cannot be: by the time the catch handler runs, the hidden-counters will have shifted. The eager-capture is *required by the timing*. The *Must capture this now, not when the catch triggers* comment names this directly.
- **"`Promise.resolve(result)` may double-wrap a promise."** It is *idempotent for thenables*: `Promise.resolve(p)` is identical to `p` when `p` is already a Promise. For non-thenables, `Promise.resolve(x)` wraps `x` in a resolved Promise. Both behaviors are what we want: thenables get `.catch` for rejection-annotation; non-thenables get no-op behavior (the `.catch` never fires).
- **"The `finally` clear is unnecessary."** It is necessary: without the clear, `hiddenPriorError` would *persist* across turn boundaries, and the next sending-event would be misattributed as *caused by* the stale prior error. The clear is the per-call hygiene.
- **"`assert.note` is a side effect."** It mutates the Error object's notes-list. The Error is being thrown or rejected; annotating it doesn't affect *what happens next*, only what the causal-console shows when the Error eventually lands somewhere that logs it. This is the meta-level-privilege framing from the prior section's discipline.
