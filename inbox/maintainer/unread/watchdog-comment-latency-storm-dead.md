from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T18:05:42Z
watchdog_key: comment-latency-storm-dead
notice_count: 4
first_seen: 2026-09-26T16:35:32Z
last_seen: 2026-09-26T18:05:42Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-26T16:35:32Z, latest 2026-09-26T18:05:42Z).
The SAME condition (`comment-latency-storm-dead`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Comment acknowledgment dead anomaly on 11 repos at once on endolin-garden-ece02cb4 (storm guard > 5; one shared cause is likelier than 11 independent faults):
- kriscendobot/cosgov: watcher heartbeat stale (age=317s > 270s; outcome=offline-journal)
- kriscendobot/moddable: watcher heartbeat stale (age=301s > 270s; outcome=offline-journal)
- kriscendobot/finbot: watcher heartbeat stale (age=283s > 270s; outcome=offline-journal)
- kriscendobot/oros-ckm-data-readiness: watcher heartbeat stale (age=306s > 270s; outcome=offline-journal)
- kriscendobot/ymax-e2e: watcher heartbeat stale (age=314s > 270s; outcome=offline-journal)
- endojs/endo-but-for-bots: watcher heartbeat stale (age=321s > 270s; outcome=offline-journal)
- kriscendobot/ymax-stdio-mcp: watcher heartbeat stale (age=286s > 270s; outcome=offline-journal)
- kriscendobot/list: watcher heartbeat stale (age=320s > 270s; outcome=offline-journal)
- kriscendobot/endo: watcher heartbeat stale (age=332s > 270s; outcome=offline-journal)
- kriscendobot/garden: watcher heartbeat stale (age=272s > 270s; outcome=offline-journal)
- kriscendobot/endo-but-for-bots: watcher heartbeat stale (age=296s > 270s; outcome=offline-journal)
