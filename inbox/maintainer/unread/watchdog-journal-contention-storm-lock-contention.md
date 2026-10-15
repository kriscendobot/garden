from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T23:46:06Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 8
first_seen: 2026-10-15T22:51:05Z
last_seen: 2026-10-15T23:46:06Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-10-15T22:51:05Z, latest 2026-10-15T23:46:06Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.012453s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.011900s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.013447s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.012387s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadmail/journal: p95=0.012956s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.012404s, giveups=1, steals=0 (max 3/window), wait floor=60s.
