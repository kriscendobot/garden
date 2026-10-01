from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-01T23:32:17Z
watchdog_key: rolling-deploy-no-canary-endolin-garden-ece02cb4
notice_count: 6
first_seen: 2026-09-30T23:36:06Z
last_seen: 2026-10-01T23:32:17Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-30T23:36:06Z, latest 2026-10-01T23:32:17Z).
The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
operator-drained, so there is no canary to validate adb5a10fce18. The leader will
not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
or lift an operator drain. An archived host additionally needs a separate operator
unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=1)
