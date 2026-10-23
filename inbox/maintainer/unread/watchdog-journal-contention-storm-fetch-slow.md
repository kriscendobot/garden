from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-23T13:28:51Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 2
first_seen: 2026-10-18T10:57:22Z
last_seen: 2026-10-23T13:28:51Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-18T10:57:22Z, latest 2026-10-23T13:28:51Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 9 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 9 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-garden-book: p95=3.284083s max=33.065852s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-oros-ckm-data-readiness: p95=3.857218s max=45.000893s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: p95=10.628367s max=41.703258s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/maintainer-approval/verify: p95=7.948372s max=44.753427s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=6.296184s max=45.001332s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/approval-reconciler/verify: p95=3.125257s max=35.003418s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/repo-watcher/journal: p95=2.997130s max=33.562403s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: p95=3.721769s max=45.001259s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=20.383160s max=20.383160s; hard guard=31.500000s (70% of 45s cap); remedy=none.
