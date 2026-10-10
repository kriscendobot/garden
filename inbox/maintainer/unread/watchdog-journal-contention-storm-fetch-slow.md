from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-10T03:52:48Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 1
first_seen: 2026-10-10T03:52:48Z
last_seen: 2026-10-10T03:52:48Z
---
Journal contention storm on endolin-garden-ece02cb4: 8 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 8 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/progress/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/issue-inbox/verify: p95=28.788312s max=28.788312s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-proposal-compartments: p95=24.715810s max=24.715810s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-finbot: p95=19.676996s max=19.676996s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-stdio-mcp: p95=25.214941s max=25.214941s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-endo: p95=28.936426s max=28.936426s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: p95=32.224762s max=32.224762s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-watcher/verify: p95=15.531352s max=15.531352s; hard guard=31.500000s (70% of 45s cap); remedy=none.
