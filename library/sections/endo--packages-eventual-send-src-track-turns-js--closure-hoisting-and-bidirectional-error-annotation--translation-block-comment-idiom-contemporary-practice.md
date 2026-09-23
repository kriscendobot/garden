---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Closure-hoisting to module scope | Minimize closure capture; hoist helper functions to module scope rather than nesting in hot-path callers. |
| HandledPromise argument retention | A specific instance of the closure-retention class; observed in practice, fixed by hoisting. |
| Bidirectional error annotation | Wrap a function to annotate *both* sync throws and async rejections; two separate handler-channels share the source-context. |
| Must capture this now, not when the catch triggers | Eager capture of mutable state at registration time; lazy reference inside handler. |
| `THROWN to top of event loop` vs `REJECTED at top of event loop` | Distinct log strings for distinct failure modes; developer can grep the log to find which path failed. |
| `finally` clear of per-call state | Don't leak per-call state across turn boundaries; clear deterministically on exit. |
