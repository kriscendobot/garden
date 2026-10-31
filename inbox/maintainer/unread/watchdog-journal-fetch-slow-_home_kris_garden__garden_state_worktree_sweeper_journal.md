from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-31T18:01:37Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_worktree_sweeper_journal
notice_count: 3
first_seen: 2026-10-20T03:59:33Z
last_seen: 2026-10-31T18:01:37Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-20T03:59:33Z, latest 2026-10-31T18:01:37Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_worktree_sweeper_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=16.796674s max=16.796674s; hard guard=31.500000s (70% of 45s cap); remedy=none.
