from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-01T04:44:12Z
watchdog_key: rolling-deploy-no-canary-endolin-garden-ece02cb4
notice_count: 25
first_seen: 2026-09-30T23:36:06Z
last_seen: 2026-10-01T04:44:12Z
---
WATCHDOG notice — occurrence #25 (first seen 2026-09-30T23:36:06Z, latest 2026-10-01T04:44:12Z).
The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 25 times; this is ONE
coalesced notice that updates in place, not 25 messages. Latest detail:

Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
operator-drained, so there is no canary to validate c5416eb373bc. The leader will
not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
or lift an operator drain. An archived host additionally needs a separate operator
unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=1)
