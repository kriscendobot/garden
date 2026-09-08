from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-08T20:17:16Z
watchdog_key: rolling-deploy-canary-failed-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-08T20:17:16Z
last_seen: 2026-09-08T20:17:16Z
---
Rolling deploy HALTED on a failed canary.
canary host: endolin-garden2-5bcdff64
target sha:  171dd3c1bc21556e1275880fc49ba3456324cae1
failing signal: released 1500s ago but never advanced to the target sha (deploy stuck/failed on the canary)
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign drain op) pending your decision; auto-rollback is deliberately not performed
(designs/follower-self-deploy.md § Failure handling). Investigate the target on endolin-garden2-5bcdff64,
then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)
