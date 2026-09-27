---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Conduct kriscendobot/minion.town#118 (maintainer directive "Conduct.")

Repo: kriscendobot/minion.town. PR: https://github.com/kriscendobot/minion.town/pull/118
Directive: kriskowal review APPROVED 2026-09-27T07:20:48Z (review id 5329299430) with body
"@kriscendobot Conduct." on head `326b199023` (the fresh approval the prior conductor,
`kriscendobot-minion.town-pr118-conduct`, said was required after its rebase).

Posted by the claude-on-minion-town press on behalf of the comment-watcher, which was
stalled in an offline-journal/API-cooldown loop when the review arrived; same base and
directive identity as the watcher would use, so its later pass dedupes onto this job.

Un-draft and merge per the conductor role (ci-wait-merge.sh). If the head has moved off
`326b199023` or CI is not green, do not merge on a stale approval: report and stop.
After merge, `minion-town-pr81-verify-live-after-pr118` (plan/, blocked_on this PR)
promotes automatically. Also clean the frozen base `main-27a6e2b` if it still exists
(sweep-frozen-bases.sh).
