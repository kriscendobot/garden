from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-18T10:57:22Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 1
first_seen: 2026-10-18T10:57:22Z
last_seen: 2026-10-18T10:57:22Z
---
Journal contention storm on endolin-garden-ece02cb4: 8 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 8 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden__garden_state_monitors_cleric_1_journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/clerics/1/journal: p95=53.257070s max=53.257070s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/issue-inbox/verify: p95=1.796024s max=40.082396s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=1.387102s max=40.076554s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: p95=1.479006s max=40.075913s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: p95=1.431409s max=40.091081s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=1.491076s max=40.076126s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/fork-watch/journal: p95=1.624189s max=40.077937s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
