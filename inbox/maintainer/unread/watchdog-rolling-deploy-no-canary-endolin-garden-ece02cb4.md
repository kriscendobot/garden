from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-10T23:35:33Z
watchdog_key: rolling-deploy-no-canary-endolin-garden-ece02cb4
notice_count: 9
first_seen: 2026-09-30T23:36:06Z
last_seen: 2026-10-10T23:35:33Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-09-30T23:36:06Z, latest 2026-10-10T23:35:33Z).
The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
operator-drained, so there is no canary to validate 592f66b2a04f. The leader will
not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
or lift an operator drain. An archived host additionally needs a separate operator
unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=2)
