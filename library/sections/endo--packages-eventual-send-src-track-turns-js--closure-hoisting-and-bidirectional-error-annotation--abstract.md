---
title: Abstract
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

§Closure-hoisting (lines 33-36) names a *retention hazard* the module's authors observed: *we hoist the following functions out of trackTurns() to discourage the closures from holding onto 'args' or 'func' longer than necessary, which we've seen cause HandledPromise arguments to be retained for a surprisingly long time*. The structural fix: hoist `addRejectionNote` and `wrapFunction` to module scope so the closures they create capture only the arguments explicitly passed (`func`, `sendingError`, `X`), not the whole `trackTurns` activation record. The §wrapFunction body (lines 47-76) implements *bidirectional error annotation*: when the wrapped TurnStarterFn is called, the module mutates the three hidden-counters (`hiddenPriorError = sendingError; hiddenCurrentTurn += 1; hiddenCurrentEvent = 0`), then runs `func(...args)` inside two nested try/catch blocks. **The inner try/catch handles synchronous throws**: any Error thrown synchronously by `func` is annotated with `X\`Thrown from: ${hiddenPriorError}:${hiddenCurrentTurn}.${hiddenCurrentEvent}\`` and re-thrown; the optional VERBOSE log writes `THROWN to top of event loop`. **The asynchronous-rejection annotation uses `Promise.resolve(result).catch(addRejectionNote(detailsNote))`**: the result is treated as a thenable; if it eventually rejects, `addRejectionNote` annotates the rejection reason with the captured detailsNote. The *must capture this now, not when the catch triggers* comment (line 69) names the timing subtlety: the detailsNote is *built immediately* in line 70 (just before `Promise.resolve(result)`), so the `hiddenCurrentTurn` and `hiddenCurrentEvent` values it interpolates are *the current ones*; if the detailsNote were built lazily *inside* the catch, the counters might have shifted by the time the rejection arrives, and the annotation would carry the wrong turn-and-event. The `finally` block clears `hiddenPriorError` to undefined so subsequent same-turn events don't inherit the prior error's annotation.
