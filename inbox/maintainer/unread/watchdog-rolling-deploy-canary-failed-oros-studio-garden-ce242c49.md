from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-10T23:50:11Z
watchdog_key: rolling-deploy-canary-failed-oros-studio-garden-ce242c49
notice_count: 7
first_seen: 2026-10-09T07:56:09Z
last_seen: 2026-10-10T23:50:11Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-10-09T07:56:09Z, latest 2026-10-10T23:50:11Z).
The SAME condition (`rolling-deploy-canary-failed-oros-studio-garden-ce242c49`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Rolling deploy HALTED on a failed canary.
canary host: oros-studio-garden-ce242c49
target sha:  592f66b2a04fbb9c4c1905809f2a2172d0fa820c
failing signal: retries exhausted after re-validation kept failing
This canary was RETRIED 3 time(s) automatically and kept
failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
confirmed regression, not a transient blip — treat it as higher severity than a
first-tick halt.
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
on oros-studio-garden-ce242c49, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)
