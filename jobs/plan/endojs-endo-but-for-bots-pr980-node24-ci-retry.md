---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/980
priority: normal
role: shepherd
posted_by: producer
posted_at: 2026-08-14T14:43:56Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Resume CI shepherding for https://github.com/endojs/endo-but-for-bots/pull/980 once its Node 24 infrastructure blocker is resolved. Current head is 37cbedff1e0b91d471d855bb24d93036b4271707. The only failed check is test (24.x, ubuntu-latest): https://github.com/endojs/endo-but-for-bots/actions/runs/31806755790/job/94794798016. Two reruns reproduced Node 24.19.0 and better-sqlite3 cleanup-hook assertions. Do not modify the feature branch unless new evidence ties the failure to its diff. After a repository CI Node 24.18 pin or an upstream patched Node release, rerun CI; when every check passes, request review from kriskowal with POST /repos/endojs/endo-but-for-bots/pulls/980/requested_reviewers using {"reviewers":["kriskowal"]}, then post the required SHA and green-run summary.
