from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T19:25:09Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 13
first_seen: 2026-10-18T10:57:22Z
last_seen: 2026-10-28T19:25:09Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-10-18T10:57:22Z, latest 2026-10-28T19:25:09Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden_journal: p95=25.478733s max=25.478733s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: p95=3.293801s max=36.403672s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: p95=3.548966s max=39.607817s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-list: p95=3.146418s max=31.991205s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: p95=3.500941s max=45.001662s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
