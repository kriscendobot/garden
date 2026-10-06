from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T05:15:34Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 2
first_seen: 2026-10-06T04:42:26Z
last_seen: 2026-10-06T05:15:34Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-06T04:42:26Z, latest 2026-10-06T05:15:34Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention storm on endolin-garden2-5bcdff64: 14 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 14 independent faults):
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-ymax-e2e: p95=45.001675s max=45.002149s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-oros-ckm-data-readiness: p95=45.001845s max=45.003324s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-proposal-compartments: p95=45.002061s max=45.002181s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/scheduler/journal: p95=45.001135s max=45.004031s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-minion.town: p95=45.001576s max=45.002388s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/approval-reconciler/verify: p95=45.001574s max=45.001905s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/reducer/journal: p95=13.974518s max=45.001348s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-ocapn: p95=45.001783s max=45.003254s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-moddable: p95=45.001837s max=45.001883s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-test262: p95=45.001749s max=45.002100s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-vattr97: p95=45.001599s max=45.001832s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-ymax-stdio-mcp: p95=45.001614s max=45.001846s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-list: p95=45.001632s max=45.001633s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/requirements-watch/journal: p95=45.001325s max=45.001678s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
