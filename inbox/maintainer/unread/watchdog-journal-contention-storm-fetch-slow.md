from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T14:33:33Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 17
first_seen: 2026-10-18T10:57:22Z
last_seen: 2026-10-29T14:33:33Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-10-18T10:57:22Z, latest 2026-10-29T14:33:33Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/clerics/1/journal: p95=1.873758s max=34.040022s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monks/3/journal: p95=2.128796s max=31.631043s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=2.697208s max=41.786590s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-ymax-e2e: p95=2.631976s max=40.648915s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-endo-but-for-bots: p95=2.112446s max=35.309665s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
