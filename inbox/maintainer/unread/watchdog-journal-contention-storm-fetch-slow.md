from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T02:30:51Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 13
first_seen: 2026-11-03T11:29:32Z
last_seen: 2026-11-04T02:30:51Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-11-03T11:29:32Z, latest 2026-11-04T02:30:51Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 7 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/reaper/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=16.332394s max=16.332394s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/comment-watcher/verify: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for _Users_dom_garden_journal: p95=20.406769s max=20.406769s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/deadmail/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/library-link-check/journal: p95=19.087712s max=19.087712s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/state-clone-keeper/journal: p95=19.308618s max=19.308618s; hard guard=31.500000s (70% of 45s cap); remedy=none.
