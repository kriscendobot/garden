from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T13:58:46Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 16
first_seen: 2026-10-18T10:57:22Z
last_seen: 2026-10-29T13:58:46Z
---
WATCHDOG notice — occurrence #16 (first seen 2026-10-18T10:57:22Z, latest 2026-10-29T13:58:46Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 16 times; this is ONE
coalesced notice that updates in place, not 16 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: p95=2.567695s max=38.106487s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/clerics/1/journal: p95=2.331626s max=34.040022s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monks/3/journal: p95=2.361426s max=31.631043s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: p95=2.728105s max=31.541537s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=2.893020s max=34.065851s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-endo-but-for-bots: p95=2.112446s max=35.309665s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
