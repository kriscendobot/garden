from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T17:40:37Z
watchdog_key: comment-latency-storm-dead
notice_count: 3
first_seen: 2026-09-26T16:35:32Z
last_seen: 2026-09-26T17:40:37Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-26T16:35:32Z, latest 2026-09-26T17:40:37Z).
The SAME condition (`comment-latency-storm-dead`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Comment acknowledgment dead anomaly on 8 repos at once on endolin-garden-ece02cb4 (storm guard > 5; one shared cause is likelier than 8 independent faults):
- kriscendobot/cosgov: watcher heartbeat stale (age=297s > 270s; outcome=cooldown)
- kriscendobot/test262: watcher heartbeat stale (age=301s > 270s; outcome=cooldown)
- kriscendobot/finbot: watcher heartbeat stale (age=326s > 270s; outcome=cooldown)
- kriscendobot/oros-ckm-data-readiness: watcher heartbeat stale (age=327s > 270s; outcome=cooldown)
- kriscendobot/ymax-e2e: watcher heartbeat stale (age=297s > 270s; outcome=cooldown)
- kriscendobot/endo: watcher heartbeat stale (age=287s > 270s; outcome=cooldown)
- kriscendobot/garden: watcher heartbeat stale (age=294s > 270s; outcome=cooldown)
- kriscendobot/minion.town: watcher heartbeat stale (age=279s > 270s; outcome=cooldown)
