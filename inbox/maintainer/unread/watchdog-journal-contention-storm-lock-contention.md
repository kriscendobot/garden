from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T12:10:48Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 17
first_seen: 2026-10-14T08:23:55Z
last_seen: 2026-10-15T12:10:48Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-10-14T08:23:55Z, latest 2026-10-15T12:10:48Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.012941s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.014347s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.013076s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=2.132377s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.016771s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadmail/journal: p95=0.014417s, giveups=2, steals=0 (max 3/window), wait floor=60s.
