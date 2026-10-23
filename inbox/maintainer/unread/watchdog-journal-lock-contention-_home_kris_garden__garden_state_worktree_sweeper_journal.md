from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-23T22:46:30Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal
notice_count: 9
first_seen: 2026-10-18T02:49:32Z
last_seen: 2026-10-23T22:46:30Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-10-18T02:49:32Z, latest 2026-10-23T22:46:30Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.028511s, giveups=1, steals=0 (max 3/window), wait floor=60s.
