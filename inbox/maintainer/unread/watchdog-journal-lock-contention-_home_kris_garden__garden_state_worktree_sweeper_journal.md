from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-03T22:48:49Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal
notice_count: 3
first_seen: 2026-11-01T22:47:38Z
last_seen: 2026-11-03T22:48:49Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-01T22:47:38Z, latest 2026-11-03T22:48:49Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.030583s, giveups=1, steals=0 (max 3/window), wait floor=60s.
