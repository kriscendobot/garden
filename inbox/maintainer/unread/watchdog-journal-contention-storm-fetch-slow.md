from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T16:25:20Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 5
first_seen: 2026-10-18T10:57:22Z
last_seen: 2026-10-28T16:25:20Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-10-18T10:57:22Z, latest 2026-10-28T16:25:20Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-topics-counts/journal: p95=45.002188s max=45.002188s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden_journal: p95=25.478733s max=25.478733s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/clerics/1/journal: p95=4.512026s max=45.002539s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: p95=3.975945s max=36.403672s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: p95=3.589349s max=45.002225s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monks/2/journal: p95=4.089386s max=37.409456s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
