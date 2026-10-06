from_host: endolin-garden2-5bcdff64
from: watchdog:rolling-deploy
sent_at: 2026-10-06T19:35:02Z
watchdog_key: rolling-deploy-canary-stuck-endolin-garden-ece02cb4
notice_count: 11
first_seen: 2026-10-06T18:20:02Z
last_seen: 2026-10-06T19:35:02Z
---
WATCHDOG notice — occurrence #11 (first seen 2026-10-06T18:20:02Z, latest 2026-10-06T19:35:02Z).
The SAME condition (`rolling-deploy-canary-stuck-endolin-garden-ece02cb4`) has now been observed 11 times; this is ONE
coalesced notice that updates in place, not 11 messages. Latest detail:

Rolling-deploy canary endolin-garden-ece02cb4 is STUCK: it was released to 5305b5aed91a 21 min ago
but still reports deployed_sha de4f2eece5f746c23d8bac7b3634b8aecfeb7ef6. Check garden-self-deploy on endolin-garden-ece02cb4
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden2-5bcdff64)
