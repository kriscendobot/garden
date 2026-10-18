from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-18T12:10:15Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 44
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-18T12:10:15Z
---
WATCHDOG notice — occurrence #44 (first seen 2026-10-16T17:37:14Z, latest 2026-10-18T12:10:15Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 44 times; this is ONE
coalesced notice that updates in place, not 44 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.013665s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.013130s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=39.040353s, giveups=53, steals=29 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.013893s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monitors/cleric-1/journal: p95=93.472323s, giveups=0, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.012412s, giveups=1, steals=0 (max 3/window), wait floor=60s.
