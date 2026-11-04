from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T01:55:49Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 12
first_seen: 2026-11-03T11:29:32Z
last_seen: 2026-11-04T01:55:49Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-11-03T11:29:32Z, latest 2026-11-04T01:55:49Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/reaper/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=16.332394s max=16.332394s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/comment-watcher/verify: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for _Users_dom_garden_journal: p95=20.406769s max=20.406769s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/deadmail/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=6.368955s max=38.450899s; hard guard=31.500000s (70% of 45s cap); remedy=fail-backoff.
