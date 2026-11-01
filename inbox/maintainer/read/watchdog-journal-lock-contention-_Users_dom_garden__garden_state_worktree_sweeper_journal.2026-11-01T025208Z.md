from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-01T02:52:08Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_worktree_sweeper_journal
notice_count: 16
first_seen: 2026-10-18T06:45:14Z
last_seen: 2026-11-01T02:52:08Z
---
WATCHDOG notice — occurrence #16 (first seen 2026-10-18T06:45:14Z, latest 2026-11-01T02:52:08Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_worktree_sweeper_journal`) has now been observed 16 times; this is ONE
coalesced notice that updates in place, not 16 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.083925s, giveups=1, steals=0 (max 3/window), wait floor=60s.
