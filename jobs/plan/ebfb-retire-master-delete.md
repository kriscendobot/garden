---
gate: orchestrated
orchestrated_by: ebfb-retire-master-branch-sweep-orchestration
priority: normal
role: conductor
posted_by: gardener
posted_at: 2026-07-17T00:27:19Z
---

Final deletion stage for the 2026-07-16 maintainer directive on endojs/endo-but-for-bots. Immediately before deletion, list open PRs whose base is master. If any remain, do not delete master: report the exact remaining PR URLs and include orchestration-failed: true in the completion report so the serial orchestration halts and alerts the maintainer. Only if the query returns zero, delete refs/heads/master from endojs/endo-but-for-bots, then re-query the branch ref and open master-base PR count to confirm deletion. The maintainer directive explicitly authorizes this deletion. Do not merge any PR to the fork master.
