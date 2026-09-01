---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr946-weave-20260901
priority: normal
posted_by: producer
posted_at: 2026-09-01T20:25:57Z
---

---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finalize (curate → merge) endojs/endo-but-for-bots#946

BLOCKED on `endojs-endo-but-for-bots-pr946-weave-20260901`. Do not start until
that weave has restored `#946` to mergeable with CI green.

This replaces the original `endojs-endo-but-for-bots-pr946-conduct`, which was
queued on 2026-08-23 while the PR was approved-and-mergeable, then doom-parked
after 5 requeue cycles; the PR went CONFLICTING while it waited.

The maintainer approval still stands (a rebase does not stale it in this fleet).
Confirm that remains true at the head you are merging — an intervening dismissal
or CHANGES_REQUESTED would change it — then perform the normal curation and merge.

If the approval no longer holds at the current head, STOP and report rather than
merging.
