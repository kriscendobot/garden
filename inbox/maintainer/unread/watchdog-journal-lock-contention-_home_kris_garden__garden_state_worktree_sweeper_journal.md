from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-22T10:49:47Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal
notice_count: 6
first_seen: 2026-10-18T02:49:32Z
last_seen: 2026-10-22T10:49:47Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-10-18T02:49:32Z, latest 2026-10-22T10:49:47Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.013384s, giveups=1, steals=0 (max 3/window), wait floor=60s.
