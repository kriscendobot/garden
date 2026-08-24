from_host: endolin-garden-ece02cb4
from: watchdog:scheduler
sent_at: 2026-08-24T01:05:07Z
watchdog_key: scheduler-preflight-missing-minion-town-agenda-review.md
notice_count: 1
first_seen: 2026-08-24T01:05:07Z
last_seen: 2026-08-24T01:05:07Z
---
Scheduler preflight gate for schedule "minion-town-agenda-review.md" is a DEPLOY-LAG symptom, not a typo.

The gate script "scripts/jobs/minion-town-press-preflight.sh" exists on origin/main2 but is ABSENT from this host's
deployed root (deployed 745fa90891f8692c12b6b14a06b4a5dbdcbbf503, behind by 42 commit(s)). The schedule is failing open and re-dispatching every cadence until this host is deployed.

Fix: scripts/jobs/deploy-garden.sh on endolin-garden-ece02cb4. One-time signal per breakage.
