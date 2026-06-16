---
title: Connection to the wider library
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

This section is the **canonical worked example of *bidirectional-error-annotation-with-must-capture-this-now-timing*** at the @endo/eventual-send pipeline level. Three threads:

1. **The closure-hoisting discipline as retention mitigation.** A *known-hazard-from-practice* observation — HandledPromise arguments retained for a surprisingly long time — that hoisting closures out of frequently-called functions can mitigate. Generalizes to any module that creates closures in hot paths.

2. **The bidirectional-error-annotation pattern.** Wrap a function and annotate *both* synchronous throws *and* asynchronous rejections with the same source-context. The two-channel-handling shape (try/catch for sync; `.catch` for async) is reusable for any annotation framework.

3. **The must-capture-this-now timing discipline.** When mutable state evolves between *handler-registration time* and *handler-invocation time*, the handler must capture the relevant state *eagerly* at registration time and refer to the capture, not the live state. Reusable for any deferred-execution pattern.
