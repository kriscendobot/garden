from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T14:46:47Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_worktree_sweeper_journal
notice_count: 5
first_seen: 2026-10-10T19:39:57Z
last_seen: 2026-10-15T14:46:47Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-10-10T19:39:57Z, latest 2026-10-15T14:46:47Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_worktree_sweeper_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.152747s, giveups=1, steals=0 (max 3/window), wait floor=60s.
