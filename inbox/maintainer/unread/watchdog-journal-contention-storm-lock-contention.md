from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-23T16:46:05Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 120
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-23T16:46:05Z
---
WATCHDOG notice — occurrence #120 (first seen 2026-10-16T17:37:14Z, latest 2026-10-23T16:46:05Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 120 times; this is ONE
coalesced notice that updates in place, not 120 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: p95=0.013931s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=2.315786s, giveups=9, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.014808s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.013115s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadmail/journal: p95=0.014478s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.015342s, giveups=1, steals=0 (max 3/window), wait floor=60s.
