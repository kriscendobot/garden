from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-14T04:17:02Z
watchdog_key: rolling-deploy-all-followers-drained-endolin-garden-ece02cb4
notice_count: 1187
first_seen: 2026-09-05T15:44:01Z
last_seen: 2026-09-14T04:17:02Z
---
WATCHDOG notice — occurrence #1187 (first seen 2026-09-05T15:44:01Z, latest 2026-09-14T04:17:02Z).
The SAME condition (`rolling-deploy-all-followers-drained-endolin-garden-ece02cb4`) has now been observed 1187 times; this is ONE
coalesced notice that updates in place, not 1187 messages. Latest detail:

Rolling deploy is HOLDING the leader: every follower is operator-drained, so there
is no available canary to validate 12fcaa50c440. Per designs/follower-self-deploy.md
this is treated as a signal to wait for you, not to advance the leader unvalidated.
Lift a follower's drain to give the roll a canary, or deploy the leader by hand if you
accept an unvalidated advance. (leader=endolin-garden-ece02cb4)
