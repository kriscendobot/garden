from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T04:43:58Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 56
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-04T04:43:58Z
---
WATCHDOG notice — occurrence #56 (first seen 2026-11-01T04:46:54Z, latest 2026-11-04T04:43:58Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 56 times; this is ONE
coalesced notice that updates in place, not 56 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 8 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 8 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.045536s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.046777s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.040233s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/design-pr-gauntlet-audit/journal: p95=0.049911s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.057276s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.048404s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.042797s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.038232s, giveups=3, steals=0 (max 3/window), wait floor=60s.
