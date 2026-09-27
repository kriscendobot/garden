from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T07:57:45Z
watchdog_key: comment-latency-storm-dead
notice_count: 5
first_seen: 2026-09-26T16:35:32Z
last_seen: 2026-09-27T07:57:45Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-09-26T16:35:32Z, latest 2026-09-27T07:57:45Z).
The SAME condition (`comment-latency-storm-dead`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Comment acknowledgment dead anomaly on 9 repos at once on endolin-garden-ece02cb4 (storm guard > 5; one shared cause is likelier than 9 independent faults):
- kriscendobot/ocapn: watcher heartbeat stale (age=274s > 270s; outcome=cooldown)
- kriscendobot/moddable: watcher heartbeat stale (age=277s > 270s; outcome=cooldown)
- kriscendobot/finbot: watcher heartbeat stale (age=289s > 270s; outcome=cooldown)
- kriscendobot/oros-ckm-data-readiness: watcher heartbeat stale (age=291s > 270s; outcome=cooldown)
- endojs/endo-but-for-bots: watcher heartbeat stale (age=286s > 270s; outcome=cooldown)
- kriscendobot/ymax-stdio-mcp: watcher heartbeat stale (age=274s > 270s; outcome=cooldown)
- kriscendobot/proposal-compartments: watcher heartbeat stale (age=271s > 270s; outcome=cooldown)
- kriscendobot/garden: watcher heartbeat stale (age=312s > 270s; outcome=cooldown)
- kriscendobot/endo-but-for-bots: watcher heartbeat stale (age=289s > 270s; outcome=cooldown)
