from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-05T16:51:11Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 103
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-05T16:51:11Z
---
WATCHDOG notice — occurrence #103 (first seen 2026-11-01T04:46:54Z, latest 2026-11-05T16:51:11Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 103 times; this is ONE
coalesced notice that updates in place, not 103 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.045650s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: p95=0.053444s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.049971s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/design-pr-gauntlet-audit/journal: p95=0.054199s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.068537s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.050125s, giveups=1, steals=0 (max 3/window), wait floor=60s.
