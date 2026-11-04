from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T10:30:25Z
watchdog_key: journal-contention-storm-fetch-slow
notice_count: 17
first_seen: 2026-11-03T11:29:32Z
last_seen: 2026-11-04T10:30:25Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-11-03T11:29:32Z, latest 2026-11-04T10:30:25Z).
The SAME condition (`journal-contention-storm-fetch-slow`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 10 clones hit fetch-slow in one tick (storm guard > 5; one shared cause is likelier than 10 independent faults):
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: p95=19.886939s max=38.194724s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/reaper/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=42.446789s max=42.446789s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fleet-health/journal: p95=19.337970s max=33.735670s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/comment-watcher/verify: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for _Users_dom_garden_journal: p95=19.875699s max=19.875699s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/deadmail/journal: p95=-s max=-s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for _Users_dom_garden_worktrees_kriscendobot_vattr97_git: p95=18.002385s max=18.002385s; hard guard=31.500000s (70% of 45s cap); remedy=none.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/self-deploy/journal: p95=17.975520s max=45.070065s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
- Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-topics-counts/journal: p95=22.653216s max=22.653216s; hard guard=31.500000s (70% of 45s cap); remedy=none.
