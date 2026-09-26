from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T17:10:29Z
watchdog_key: comment-latency-storm-dead
notice_count: 2
first_seen: 2026-09-26T16:35:32Z
last_seen: 2026-09-26T17:10:29Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-26T16:35:32Z, latest 2026-09-26T17:10:29Z).
The SAME condition (`comment-latency-storm-dead`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Comment acknowledgment dead anomaly on 7 repos at once on endolin-garden-ece02cb4 (storm guard > 5; one shared cause is likelier than 7 independent faults):
- kriscendobot/cosgov: watcher heartbeat stale (age=392s > 270s; outcome=offline-journal)
- kriscendobot/ocapn: watcher heartbeat stale (age=395s > 270s; outcome=offline-journal)
- kriscendobot/proposal-compartments: watcher heartbeat stale (age=401s > 270s; outcome=offline-journal)
- kriscendobot/endo: watcher heartbeat stale (age=326s > 270s; outcome=offline-journal)
- kriscendobot/garden: watcher heartbeat stale (age=402s > 270s; outcome=offline-journal)
- kriscendobot/minion.town: watcher heartbeat stale (age=389s > 270s; outcome=offline-journal)
- kriscendobot/vattr97: watcher heartbeat stale (age=398s > 270s; outcome=offline-journal)
