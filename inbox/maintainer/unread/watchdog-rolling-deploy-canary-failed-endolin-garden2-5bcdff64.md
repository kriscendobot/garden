from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-20T16:50:20Z
watchdog_key: rolling-deploy-canary-failed-endolin-garden2-5bcdff64
notice_count: 4
first_seen: 2026-09-17T05:26:11Z
last_seen: 2026-09-20T16:50:20Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-17T05:26:11Z, latest 2026-09-20T16:50:20Z).
The SAME condition (`rolling-deploy-canary-failed-endolin-garden2-5bcdff64`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Rolling deploy HALTED on a failed canary.
canary host: endolin-garden2-5bcdff64
target sha:  8ed2e2e7f290c51fd3aca1d462dac1c673b40ee6
failing signal: retries exhausted after re-validation kept failing
This canary was RETRIED 3 time(s) automatically and kept
failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
confirmed regression, not a transient blip — treat it as higher severity than a
first-tick halt.
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
on endolin-garden2-5bcdff64, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)
