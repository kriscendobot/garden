from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-26T07:24:22Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 167
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-26T07:24:22Z
---
WATCHDOG notice — occurrence #167 (first seen 2026-10-16T17:37:14Z, latest 2026-10-26T07:24:22Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 167 times; this is ONE
coalesced notice that updates in place, not 167 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/repo-watcher/journal: p95=0.014501s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/foreman/journal: p95=0.014268s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.016089s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.014392s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.013968s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.015832s, giveups=1, steals=0 (max 3/window), wait floor=60s.
