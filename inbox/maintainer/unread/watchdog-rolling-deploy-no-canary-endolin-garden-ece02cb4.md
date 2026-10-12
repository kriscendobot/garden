from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-12T02:50:05Z
watchdog_key: rolling-deploy-no-canary-endolin-garden-ece02cb4
notice_count: 27
first_seen: 2026-09-30T23:36:06Z
last_seen: 2026-10-12T02:50:05Z
---
WATCHDOG notice — occurrence #27 (first seen 2026-09-30T23:36:06Z, latest 2026-10-12T02:50:05Z).
The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 27 times; this is ONE
coalesced notice that updates in place, not 27 messages. Latest detail:

Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
operator-drained, so there is no canary to validate c60e4758960c. The leader will
not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
or lift an operator drain. An archived host additionally needs a separate operator
unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=2)
