from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-10T02:50:52Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal
notice_count: 6
first_seen: 2026-11-07T04:46:32Z
last_seen: 2026-11-10T02:50:52Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-11-07T04:46:32Z, latest 2026-11-10T02:50:52Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.031119s, giveups=2, steals=0 (max 3/window), wait floor=60s.
