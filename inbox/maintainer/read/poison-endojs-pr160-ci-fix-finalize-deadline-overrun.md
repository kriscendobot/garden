from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-22T08:23:09Z
poison_base: endojs-pr160-ci-fix-finalize
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-22T08:23:09Z
last_seen: 2026-07-22T08:23:09Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/endojs-pr160-ci-fix-finalize; it stays HELD until a human promotes it
(promote-plan.sh endojs-pr160-ci-fix-finalize) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: endojs-pr160-ci-fix-finalize

--- original job body ---
---
role: fixer
---

Fix and finalize CI for endojs/endo-but-for-bots PR #160: https://github.com/endojs/endo-but-for-bots/pull/160

The review follow-up has been acknowledged and its separate native-Rust/XS design job has been posted. Work only on the current PR branch. The current head is 1bf8a6eec00ea7db3469d290a24ac06e39de4d4e.

Investigate and fix the failing CI signals, including lint reporting that @endo/ses-ava is missing from packages/platform dependencies and the Node 24 Ubuntu test failure. Use fresh CI evidence; do not assume either is flaky. Push only safe follow-up commits. After every check is green and the PR is mergeable, post a conductor job to un-draft if necessary and merge (do not specify a merge method). If not green or mergeable, report the exact blocker instead.

PR comments are standing-authorized for this repository. Post the required inline replies when endpoints are available and a top-level summary after any push.


<!-- garden-deadline-overrun: 1 -->
