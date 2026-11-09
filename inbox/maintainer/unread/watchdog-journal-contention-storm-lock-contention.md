from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-09T20:50:42Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 38
first_seen: 2026-11-06T06:47:25Z
last_seen: 2026-11-09T20:50:42Z
---
WATCHDOG notice — occurrence #38 (first seen 2026-11-06T06:47:25Z, latest 2026-11-09T20:50:42Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 38 times; this is ONE
coalesced notice that updates in place, not 38 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: p95=0.059832s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=0.059295s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.051588s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.062750s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.058243s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.054331s, giveups=1, steals=0 (max 3/window), wait floor=60s.
