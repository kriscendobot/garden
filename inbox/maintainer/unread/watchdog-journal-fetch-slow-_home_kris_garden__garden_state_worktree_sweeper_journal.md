from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T05:58:14Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_worktree_sweeper_journal
notice_count: 2
first_seen: 2026-10-06T01:57:53Z
last_seen: 2026-10-06T05:58:14Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-06T01:57:53Z, latest 2026-10-06T05:58:14Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_worktree_sweeper_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=17.212321s max=17.212321s; hard guard=31.500000s (70% of 45s cap); remedy=none.
