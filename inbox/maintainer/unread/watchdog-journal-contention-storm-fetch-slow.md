from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T09:55:19Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 1
first_seen: 2026-10-03T09:55:19Z
last_seen: 2026-10-03T09:55:19Z
---
Journal contention storm on endolin-garden2-5bcdff64: 7 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/leader/journal: p95=2.768219s max=40.179628s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/monitors/cleric-1/journal: p95=5.612152s max=40.079665s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/self-deploy/journal: p95=2.335558s max=40.075322s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/gardener-scaler/journal: p95=2.134352s max=40.075255s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/reducer/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/fork-watch/journal: p95=2.392957s max=40.078370s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/sysop/journal: p95=2.282103s max=40.084015s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
