from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-15T16:17:32Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 3
first_seen: 2026-11-13T22:23:28Z
last_seen: 2026-11-15T16:17:32Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-13T22:23:28Z, latest 2026-11-15T16:17:32Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=1.666231s max=45.008252s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monks/1/journal: p95=1.900244s max=45.009400s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/retire-kriscendobot-minion.town: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-control/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-delegation/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
