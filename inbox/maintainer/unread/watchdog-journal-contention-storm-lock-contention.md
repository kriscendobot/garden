from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-31T11:15:49Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 268
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-31T11:15:49Z
---
WATCHDOG notice — occurrence #268 (first seen 2026-10-16T17:37:14Z, latest 2026-10-31T11:15:49Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 268 times; this is ONE
coalesced notice that updates in place, not 268 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: p95=0.030253s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.025499s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.025275s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/foreman/journal: p95=0.025417s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/fork-watch/journal: p95=0.032724s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.051336s, giveups=1, steals=0 (max 3/window), wait floor=60s.
