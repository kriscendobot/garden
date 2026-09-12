from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-12T05:38:07Z
watchdog_key: rolling-deploy-canary-failed-endolin-garden2-5bcdff64
notice_count: 2
first_seen: 2026-09-08T20:17:16Z
last_seen: 2026-09-12T05:38:07Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-08T20:17:16Z, latest 2026-09-12T05:38:07Z).
The SAME condition (`rolling-deploy-canary-failed-endolin-garden2-5bcdff64`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Rolling deploy HALTED on a failed canary.
canary host: endolin-garden2-5bcdff64
target sha:  343af39b2801b5a4653fb28481777b5547959ad6
failing signal: released 1500s ago but never advanced to the target sha (deploy stuck/failed on the canary)
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign drain op) pending your decision; auto-rollback is deliberately not performed
(designs/follower-self-deploy.md § Failure handling). Investigate the target on endolin-garden2-5bcdff64,
then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)
