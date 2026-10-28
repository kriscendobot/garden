from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T15:24:58Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 3
first_seen: 2026-10-18T10:57:22Z
last_seen: 2026-10-28T15:24:58Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-18T10:57:22Z, latest 2026-10-28T15:24:58Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 15 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 15 independent faults):
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monitors/monk-2/journal: p95=2.536127s max=35.780351s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monitors/cleric-1/journal: p95=2.476471s max=45.001843s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: p95=2.331774s max=42.235498s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden_journal: p95=25.478733s max=25.478733s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: p95=2.501021s max=45.005496s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/maintainer-approval/verify: p95=2.597090s max=33.417683s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gauntlet/journal: p95=2.723106s max=32.856798s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monks/3/journal: p95=2.242595s max=32.561807s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: p95=11.547672s max=36.403672s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=2.785563s max=37.776571s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: p95=2.634059s max=45.002225s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/rolling-deploy/journal: p95=2.494274s max=40.441038s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-list: p95=1.941882s max=37.983881s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-endo: p95=2.306404s max=45.002769s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: p95=1.935005s max=43.434627s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
