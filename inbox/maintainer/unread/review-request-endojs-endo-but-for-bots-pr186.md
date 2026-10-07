from_host: endolin-garden-ece02cb4
from: gardener:pr-readiness-verify-changes-requested-20261007
reply_to: pr-readiness-verify-changes-requested-20261007
msg_key: review-request-endojs-endo-but-for-bots-pr186
notice_count: 1
first_seen: 2026-10-07T16:48:06Z
last_seen: 2026-10-07T16:48:08Z
sent_at: 2026-10-07T16:48:08Z
---
Review request: endojs/endo-but-for-bots PR 186
https://github.com/endojs/endo-but-for-bots/pull/186
Arc: unallocated. Milestone: -.

Latest CHANGES_REQUESTED checklist:
- Applied in `59e90c85d07b`: replaced the design narrative with state documentation in `packages/eventual-send/README.md`, rebased to `actual/master`, removed bots-repo issue references, and closed the superseded design issue as directed.
- Applied in `59e90c85d07b`: renamed `install-delegate.js`/`make-delegate.js` to `install.js`/`make.js` and replaced the old install name with `installOrAdoptOne`/`installOrAdoptAll`.
- Applied in `59e90c85d07b`: made the delegate operations peer symbol-named properties on `Promise`, had `make.js` return the bank, and exported lexical ponyfill thunks from `src/no-shim.js`, with regression tests.
- Applied follow-ups: formatting in `b1bd5be0db2d` and the `Bank.delegate` type correction in `3ffb8a8f0cae`.

Current head: `3ffb8a8f0cae`. CI: 26 checks, all successful. No requested item was declined.
