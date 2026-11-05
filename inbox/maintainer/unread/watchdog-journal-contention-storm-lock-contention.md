from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-05T00:16:03Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 86
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-05T00:16:03Z
---
WATCHDOG notice — occurrence #86 (first seen 2026-11-01T04:46:54Z, latest 2026-11-05T00:16:03Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 86 times; this is ONE
coalesced notice that updates in place, not 86 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.024604s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.022862s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.026164s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=5.273001s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.025969s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.029095s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.029208s, giveups=1, steals=0 (max 3/window), wait floor=60s.
