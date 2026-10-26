from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-26T00:52:57Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_worktree_sweeper_journal
notice_count: 8
first_seen: 2026-10-18T06:45:14Z
last_seen: 2026-10-26T00:52:57Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-10-18T06:45:14Z, latest 2026-10-26T00:52:57Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_worktree_sweeper_journal`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.082082s, giveups=1, steals=0 (max 3/window), wait floor=60s.
