from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-07T15:57:09Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 2
first_seen: 2026-11-07T11:17:36Z
last_seen: 2026-11-07T15:57:09Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-07T11:17:36Z, latest 2026-11-07T15:57:09Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monitors/monk-2/journal: p95=1.717961s max=31.808793s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden_journal: p95=17.689752s max=17.689752s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/retire-kriscendobot-minion.town: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-control/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-delegation/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
