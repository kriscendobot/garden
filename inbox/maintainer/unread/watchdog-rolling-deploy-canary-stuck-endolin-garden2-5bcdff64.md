from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-27T08:08:03Z
watchdog_key: rolling-deploy-canary-stuck-endolin-garden2-5bcdff64
notice_count: 7
first_seen: 2026-09-27T03:15:38Z
last_seen: 2026-09-27T08:08:03Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-09-27T03:15:38Z, latest 2026-09-27T08:08:03Z).
The SAME condition (`rolling-deploy-canary-stuck-endolin-garden2-5bcdff64`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Rolling-deploy canary endolin-garden2-5bcdff64 is STUCK: it was released to 0350fdd5bda4 21 min ago
but still reports deployed_sha 586aee8196b4c03fdb68c7d2368856cb756de4eb. Check garden-self-deploy on endolin-garden2-5bcdff64
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
