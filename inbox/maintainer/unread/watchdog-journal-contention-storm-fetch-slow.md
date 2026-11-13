from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-13T22:23:28Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 1
first_seen: 2026-11-13T22:23:28Z
last_seen: 2026-11-13T22:23:28Z
---
Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/issue-inbox/verify: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/reaper/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/comment-watcher/verify: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/deadmail/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/self-deploy/journal: p95=23.150899s max=23.150899s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-topics-counts/journal: p95=17.959745s max=17.959745s; hard guard=31.500000s (70% of 45s cap); remedy=none.
