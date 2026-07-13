---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: requeue-exhausted
poison_count: 1
requeue_cycles: 5
deadline_overruns: 1
poisoned_at: 2026-07-13T19:03:25Z
poisoned_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-07-13T19:03:25Z
---

Run the gauntlet (clean → panel review → fix-loop → un-draft) on endojs/endo-but-for-bots#707, the git-capability stack Phase 3 that delivers the worked version-controlled-filesystem loop named as milestone M3's exit criterion. The PR is green on CI but still DRAFT; drive it to review-passed and un-drafted so it joins the merge-ready stack (#705/#706/#708) alongside it.


<!-- garden-deadline-overrun: 1 -->
