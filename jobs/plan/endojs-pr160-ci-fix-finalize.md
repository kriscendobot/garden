---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
doomed_at: 2026-07-22T08:23:06Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-22T08:23:06Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200
<!-- liaison 2026-08-06: this job was DOOMED by the reaper after a
     deterministic deadline overrun at the 2400s default. It carried no
     handler-timeout: header and its role does not qualify for the 7200s
     builder default (landed 2026-08-01), so it was SIGTERM-killed at the
     wall on every requeue. The budget is the fix; the work is wanted.
     If it overruns 7200s too, that is a REAL overrun -- diagnose it, do
     not raise the budget again. -->

---
role: fixer
---

Fix and finalize CI for endojs/endo-but-for-bots PR #160: https://github.com/endojs/endo-but-for-bots/pull/160

The review follow-up has been acknowledged and its separate native-Rust/XS design job has been posted. Work only on the current PR branch. The current head is 1bf8a6eec00ea7db3469d290a24ac06e39de4d4e.

Investigate and fix the failing CI signals, including lint reporting that @endo/ses-ava is missing from packages/platform dependencies and the Node 24 Ubuntu test failure. Use fresh CI evidence; do not assume either is flaky. Push only safe follow-up commits. After every check is green and the PR is mergeable, post a conductor job to un-draft if necessary and merge (do not specify a merge method). If not green or mergeable, report the exact blocker instead.

PR comments are standing-authorized for this repository. Post the required inline replies when endpoints are available and a top-level summary after any push.


<!-- garden-deadline-overrun: 1 -->
