from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T13:23:46Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 15
first_seen: 2026-10-18T10:57:22Z
last_seen: 2026-10-29T13:23:46Z
---
WATCHDOG notice — occurrence #15 (first seen 2026-10-18T10:57:22Z, latest 2026-10-29T13:23:46Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 15 times; this is ONE
coalesced notice that updates in place, not 15 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: p95=2.241411s max=33.263843s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/clerics/1/journal: p95=2.419477s max=45.001191s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: p95=2.633971s max=32.103215s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-endo-but-for-bots: p95=2.630489s max=35.309665s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-moddable: p95=2.105692s max=41.200367s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
