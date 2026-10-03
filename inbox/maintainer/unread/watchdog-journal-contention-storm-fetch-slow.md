from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T10:19:22Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 2
first_seen: 2026-10-03T09:55:19Z
last_seen: 2026-10-03T10:19:22Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-03T09:55:19Z, latest 2026-10-03T10:19:22Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=45.001467s max=45.001467s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden__garden_state_bulletin_journal: p95=2.195336s max=40.076545s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/self-deploy/journal: p95=2.494746s max=40.076845s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=2.451571s max=40.081341s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: p95=4.426930s max=40.291717s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: p95=2.054983s max=40.083650s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/fork-watch/journal: p95=2.288438s max=40.080054s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
