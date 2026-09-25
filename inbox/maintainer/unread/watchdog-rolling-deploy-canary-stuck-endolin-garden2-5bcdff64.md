from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-25T00:38:02Z
watchdog_key: rolling-deploy-canary-stuck-endolin-garden2-5bcdff64
notice_count: 9
first_seen: 2026-09-24T22:35:02Z
last_seen: 2026-09-25T00:38:02Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-09-24T22:35:02Z, latest 2026-09-25T00:38:02Z).
The SAME condition (`rolling-deploy-canary-stuck-endolin-garden2-5bcdff64`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Rolling-deploy canary endolin-garden2-5bcdff64 is STUCK: it was released to 23dcd50219f0 21 min ago
but still reports deployed_sha a7c06dd8217590c6fd6b78b6d9de839d0bf7a8b0. Check garden-self-deploy on endolin-garden2-5bcdff64
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
