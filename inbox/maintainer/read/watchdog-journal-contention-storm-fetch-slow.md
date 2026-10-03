from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T09:54:31Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 1
first_seen: 2026-10-03T09:54:31Z
last_seen: 2026-10-03T09:54:31Z
---
Journal contention storm on endolin-garden-ece02cb4: 9 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 9 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=45.001467s max=45.001467s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/clerics/1/journal: p95=1.523621s max=40.075385s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden__garden_state_bulletin_journal: p95=2.075014s max=40.076545s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/self-deploy/journal: p95=2.494746s max=40.076845s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=2.428333s max=40.081341s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: p95=2.732610s max=40.291717s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: p95=2.067992s max=40.083650s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/fork-watch/journal: p95=2.288438s max=40.080054s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden__garden_state_orch_journal: p95=1.592175s max=42.656915s; hard guard=31.500000s (70% of 45s cap); remedy=none.
