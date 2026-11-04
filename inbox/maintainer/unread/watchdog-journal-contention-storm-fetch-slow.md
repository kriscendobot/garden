from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T09:50:36Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 15
first_seen: 2026-11-03T11:29:32Z
last_seen: 2026-11-04T09:50:36Z
---
WATCHDOG notice — occurrence #15 (first seen 2026-11-03T11:29:32Z, latest 2026-11-04T09:50:36Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 15 times; this is ONE
coalesced notice that updates in place, not 15 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 11 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 11 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/dependabot-watcher/verify: p95=16.607412s max=16.607412s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: p95=16.458034s max=16.577694s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/retire-kriscendobot-minion.town: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-minion.town: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/repo-watcher/journal: p95=7.233463s max=45.001202s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-finbot: p95=16.396076s max=16.605934s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: p95=16.370304s max=16.415437s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-control/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ratchet-delegation/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-oros-ckm-data-readiness: p95=45.001521s max=45.001521s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
