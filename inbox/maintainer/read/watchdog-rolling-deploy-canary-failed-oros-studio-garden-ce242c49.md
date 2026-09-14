from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-14T23:05:11Z
watchdog_key: rolling-deploy-canary-failed-oros-studio-garden-ce242c49
notice_count: 1
first_seen: 2026-09-14T23:05:11Z
last_seen: 2026-09-14T23:05:11Z
---
Rolling deploy HALTED on a failed canary.
canary host: oros-studio-garden-ce242c49
target sha:  4d51ea7f4375ee42d1428dbbb0786cbe3683d3ea
failing signal: released 1500s ago but never advanced to the target sha (deploy stuck/failed on the canary)
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign drain op) pending your decision; auto-rollback is deliberately not performed
(designs/follower-self-deploy.md § Failure handling). Investigate the target on oros-studio-garden-ce242c49,
then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)
