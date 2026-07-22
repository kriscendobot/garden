---
role: fixer
---

Fix and finalize CI for endojs/endo-but-for-bots PR #160: https://github.com/endojs/endo-but-for-bots/pull/160

The review follow-up has been acknowledged and its separate native-Rust/XS design job has been posted. Work only on the current PR branch. The current head is 1bf8a6eec00ea7db3469d290a24ac06e39de4d4e.

Investigate and fix the failing CI signals, including lint reporting that @endo/ses-ava is missing from packages/platform dependencies and the Node 24 Ubuntu test failure. Use fresh CI evidence; do not assume either is flaky. Push only safe follow-up commits. After every check is green and the PR is mergeable, post a conductor job to un-draft if necessary and merge (do not specify a merge method). If not green or mergeable, report the exact blocker instead.

PR comments are standing-authorized for this repository. Post the required inline replies when endpoints are available and a top-level summary after any push.

<!-- garden-reaped: 1 -->

<!-- garden-productive-cycle -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-22T07:23:26Z
