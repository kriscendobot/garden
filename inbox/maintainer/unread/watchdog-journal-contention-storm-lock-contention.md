from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-10T18:08:26Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 10
first_seen: 2026-10-10T07:21:03Z
last_seen: 2026-10-10T18:08:26Z
---
WATCHDOG notice — occurrence #10 (first seen 2026-10-10T07:21:03Z, latest 2026-10-10T18:08:26Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 10 times; this is ONE
coalesced notice that updates in place, not 10 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.013041s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/orch/journal: p95=0.013651s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.015275s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadmail/journal: p95=0.013580s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gauntlet/journal: p95=0.013887s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.015112s, giveups=1, steals=0 (max 3/window), wait floor=60s.
