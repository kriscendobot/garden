---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr796-fix-crc32-package-4998159010
priority: high
role: gardener
posted_by: gardener
posted_at: 2026-08-21T23:47:57Z
---

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Resume the halted gauntlet on endojs/endo-but-for-bots PR #796

The prior staged gauntlet `endojs-endo-but-for-bots-pr796-gauntlet` halted when
panel round 2 exhausted its requeue allowance and was doom-parked. The PR remains
draft. A later maintainer CHANGES_REQUESTED review is owned by blocker
`endojs-endo-but-for-bots-pr796-fix-crc32-package-4998159010`.

After that fixer completes, re-fetch https://github.com/endojs/endo-but-for-bots/pull/796
and confirm it remains open and draft. If so, post a fresh staged feature gauntlet
with the unique base
`endojs-endo-but-for-bots-pr796-gauntlet-resume-20260821` using
`scripts/jobs/post-gauntlet.sh`, then report the durable gauntlet record. Do not
reuse the completed halted gauntlet base, and do not edit the PR branch in this
routing job. If the PR is no longer open/draft, report its terminal state instead.
