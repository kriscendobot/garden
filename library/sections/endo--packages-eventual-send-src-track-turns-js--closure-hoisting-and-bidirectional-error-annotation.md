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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation--abstract.md)
- [Body](endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation--body.md)
- [Connection to the wider library](endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation--see-also.md)
- [Common confusions](endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation--common-confusions.md)
