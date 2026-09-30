from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-30T23:36:06Z
watchdog_key: rolling-deploy-no-canary-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-09-30T23:36:06Z
last_seen: 2026-09-30T23:36:06Z
---
Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
operator-drained, so there is no canary to validate d259a24e6f9a. The leader will
not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
or lift an operator drain. An archived host additionally needs a separate operator
unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=1)
