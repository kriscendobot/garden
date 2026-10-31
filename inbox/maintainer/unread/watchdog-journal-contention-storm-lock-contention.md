from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-31T12:35:46Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 271
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-31T12:35:46Z
---
WATCHDOG notice — occurrence #271 (first seen 2026-10-16T17:37:14Z, latest 2026-10-31T12:35:46Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 271 times; this is ONE
coalesced notice that updates in place, not 271 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.028420s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: p95=0.021073s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.027821s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.032526s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/foreman/journal: p95=0.029278s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/fork-watch/journal: p95=0.036565s, giveups=1, steals=0 (max 3/window), wait floor=60s.
