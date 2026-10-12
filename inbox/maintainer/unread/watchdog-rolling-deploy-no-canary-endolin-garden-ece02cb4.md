from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-12T04:14:23Z
watchdog_key: rolling-deploy-no-canary-endolin-garden-ece02cb4
notice_count: 36
first_seen: 2026-09-30T23:36:06Z
last_seen: 2026-10-12T04:14:23Z
---
WATCHDOG notice — occurrence #36 (first seen 2026-09-30T23:36:06Z, latest 2026-10-12T04:14:23Z).
The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 36 times; this is ONE
coalesced notice that updates in place, not 36 messages. Latest detail:

Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
operator-drained, so there is no canary to validate 75b15068edc8. The leader will
not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
or lift an operator drain. An archived host additionally needs a separate operator
unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=2)
