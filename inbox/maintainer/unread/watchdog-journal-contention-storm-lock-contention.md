from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-01T00:11:33Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 291
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-11-01T00:11:33Z
---
WATCHDOG notice — occurrence #291 (first seen 2026-10-16T17:37:14Z, latest 2026-11-01T00:11:33Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 291 times; this is ONE
coalesced notice that updates in place, not 291 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: p95=0.027364s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.034950s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/fork-watch/journal: p95=0.036161s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.054315s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.042518s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.062227s, giveups=1, steals=0 (max 3/window), wait floor=60s.
