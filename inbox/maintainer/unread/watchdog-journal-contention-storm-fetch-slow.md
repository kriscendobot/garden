from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-03T12:21:59Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 3
first_seen: 2026-11-03T11:29:32Z
last_seen: 2026-11-03T12:21:59Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-03T11:29:32Z, latest 2026-11-03T12:21:59Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 9 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 9 independent faults):
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: p95=11.214024s max=36.946054s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/reaper/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=15.318889s max=15.318889s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/comment-watcher/verify: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for _Users_dom_garden_journal: p95=24.943728s max=24.943728s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/deadmail/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/library-link-check/journal: p95=45.028712s max=45.028712s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/state-clone-keeper/journal: p95=45.019739s max=45.019739s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/transcripts/journal: p95=45.006582s max=45.006582s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
