from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T14:23:20Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 219
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-29T14:23:20Z
---
WATCHDOG notice — occurrence #219 (first seen 2026-10-16T17:37:14Z, latest 2026-10-29T14:23:20Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 219 times; this is ONE
coalesced notice that updates in place, not 219 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.013435s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/foreman/journal: p95=0.013490s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.014342s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gauntlet/journal: p95=0.014852s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.013298s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.014269s, giveups=3, steals=0 (max 3/window), wait floor=60s.
