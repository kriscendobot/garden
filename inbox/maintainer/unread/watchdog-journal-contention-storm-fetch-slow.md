from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-08T22:55:10Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 3
first_seen: 2026-11-07T11:17:36Z
last_seen: 2026-11-08T22:55:10Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-07T11:17:36Z, latest 2026-11-08T22:55:10Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/dependabot-watcher/verify: p95=1.922253s max=107381794.178249s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: p95=1.623537s max=126661794.177946s; hard guard=31.500000s (70% of 45s cap); remedy=lock-backoff.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/retire-kriscendobot-minion.town: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-control/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-delegation/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
