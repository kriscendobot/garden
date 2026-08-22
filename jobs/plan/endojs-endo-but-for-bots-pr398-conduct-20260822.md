---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr398-shepherd-conduct-20260822
priority: urgent
role: conductor
posted_by: gardener
posted_at: 2026-08-22T01:05:09Z
---

---
role: conductor
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Conduct endojs/endo-but-for-bots PR #398

After the preceding shepherd child succeeds, conduct endojs/endo-but-for-bots PR #398
through the conductor's deterministic merge spine and carry the merge to completion.

Maintainer authorization and ordering directive:
https://github.com/endojs/endo-but-for-bots/pull/398#issuecomment-5376587229

Current exact-head approval observed while routing:
https://github.com/endojs/endo-but-for-bots/pull/398#pullrequestreview-4968635368
(APPROVED by kriskowal on `fdc01f30d6bf803456505c2529534d860b6d7fd7`).

Re-fetch all state. Merge only if the live head has terminal green CI, is mergeable, and
still has a current maintainer approval satisfying the conductor's exact-head guard. If the
spine rewrites the head and invalidates approval, report the genuine approval blocker rather
than bypassing it. Verify the final PR state before reporting.
