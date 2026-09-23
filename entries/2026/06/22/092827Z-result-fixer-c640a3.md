---
ts: 2026-06-22T09:28:02Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/22/084812Z-result-fixer-2b194d.md
---

PR #125 daemon-side regression fixed (feat/edit-message, new HEAD e0d608406).

Root cause: the three new editMessage tests in
`packages/daemon/test/endo.test.js` called `E(hostMessages).next()`
directly on the ERef returned by `E(host).followMessages()`.
The host and guest exo facets wrap the internal async generator with
`readerFromIterator` before returning, producing a PassableReader
(interface: stream, readPattern, readReturnPattern) rather than an async
iterator with next().
Every other followMessages caller in endo.test.js wraps with
iterateReader() first; the new editMessage tests were written without
that wrapper.

Fix: three tests updated to use `iterateReader(E(…).followMessages())`
and call `.next()` locally, matching the established pattern.

Files touched: packages/daemon/test/endo.test.js (one commit).

Tests passing by name:
- endo > editMessage replaces payload and preserves history
- endo > editMessage rejects edits from non-senders
- endo > editMessage accepts edits after done and records them

@endo/chat: 651 tests passed.
Pre-push gates: yarn format (no drift), yarn lint (0 errors).

PR comment posted:
https://github.com/endojs/endo-but-for-bots/pull/125#issuecomment-4766834322

Self-improvement: nothing this time.
