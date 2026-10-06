from_host: endolin-garden2-5bcdff64
from: watchdog:rolling-deploy
sent_at: 2026-10-06T21:26:11Z
watchdog_key: rolling-deploy-canary-failed-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-10-06T21:26:11Z
last_seen: 2026-10-06T21:26:11Z
---
Rolling deploy HALTED on a failed canary.
canary host: endolin-garden-ece02cb4
target sha:  05b29b3e8fa29919ae5024586f91c84e34fc9a08
failing signal: retries exhausted after re-validation kept failing
This canary was RETRIED 3 time(s) automatically and kept
failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
confirmed regression, not a transient blip — treat it as higher severity than a
first-tick halt.
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
on endolin-garden-ece02cb4, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden2-5bcdff64)
