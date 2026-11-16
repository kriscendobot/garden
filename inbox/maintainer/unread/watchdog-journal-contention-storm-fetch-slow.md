from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-16T16:32:52Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 4
first_seen: 2026-11-13T22:23:28Z
last_seen: 2026-11-16T16:32:52Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-11-13T22:23:28Z, latest 2026-11-16T16:32:52Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/mentor/journal: p95=18.002358s max=18.002358s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/retire-kriscendobot-minion.town: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-control/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/orch/journal: p95=1.654408s max=31.678144s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-delegation/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
