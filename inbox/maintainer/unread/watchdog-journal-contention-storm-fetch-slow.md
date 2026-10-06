from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T04:42:26Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 1
first_seen: 2026-10-06T04:42:26Z
last_seen: 2026-10-06T04:42:26Z
---
Journal contention storm on endolin-garden2-5bcdff64: 8 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 8 independent faults):
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/issue-inbox/verify: p95=45.001730s max=45.010532s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/gardener-scaler/journal: p95=11.891840s max=44.512788s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/pages-watcher/verify: p95=45.001520s max=45.001619s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/foreman/journal: p95=45.001320s max=45.001389s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/deadmail/verify: p95=45.001093s max=45.001399s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/deadline-nudge/journal: p95=45.001094s max=45.002121s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/maintainer-approval/verify: p95=8.446985s max=35.810685s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/monitors/monk-1/journal: p95=8.374135s max=39.097298s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
