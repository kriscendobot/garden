from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T14:11:12Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 3
first_seen: 2026-10-06T04:42:26Z
last_seen: 2026-10-06T14:11:12Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-06T04:42:26Z, latest 2026-10-06T14:11:12Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention storm on endolin-garden2-5bcdff64: 13 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 13 independent faults):
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-endo: p95=45.001452s max=45.001830s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-ymax-e2e: p95=45.001378s max=45.002318s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-oros-ckm-data-readiness: p95=45.001370s max=45.001831s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-proposal-compartments: p95=45.001380s max=45.002124s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-cosgov: p95=45.001443s max=45.001887s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-minion.town: p95=45.001503s max=45.001957s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-ocapn: p95=45.001346s max=45.001410s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-moddable: p95=45.001559s max=45.001880s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-test262: p95=45.001514s max=45.002816s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-vattr97: p95=45.001313s max=45.001711s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-kriscendobot-ymax-stdio-mcp: p95=45.001427s max=45.001609s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/receipt-watcher/journal-endojs-endo-but-for-bots: p95=45.001306s max=45.001611s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/requirements-watch/journal: p95=5.209930s max=38.588557s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
