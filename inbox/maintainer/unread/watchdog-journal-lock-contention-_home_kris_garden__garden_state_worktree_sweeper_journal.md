from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-27T16:45:58Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal
notice_count: 14
first_seen: 2026-10-18T02:49:32Z
last_seen: 2026-10-27T16:45:58Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-10-18T02:49:32Z, latest 2026-10-27T16:45:58Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.043065s, giveups=1, steals=0 (max 3/window), wait floor=60s.
