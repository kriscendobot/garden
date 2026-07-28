---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: deadline-overrun
poison_count: 1
requeue_cycles: 3
deadline_overruns: 1
poisoned_at: 2026-07-28T12:43:07Z
poisoned_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-28T12:43:07Z
---

In endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/825 is open, non-draft, and mergeable, but its CI green record predates the final comment-only commit `74f71d55b`. Shepherd the PR: re-run/await CI on the current head so a green record exists on `74f71d55b`, and report the result on the PR.



<!-- garden-unpoisoned: fu-endojs-endo-but-for-bots-pr825-8840fcdb-2; spurious elapsed-constancy self-sample poison (fixed in main2 4a87fc7729); no real deadline overrun ever occurred -->
