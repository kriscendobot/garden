from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-31T02:55:14Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_worktree_sweeper_journal
notice_count: 14
first_seen: 2026-10-18T06:45:14Z
last_seen: 2026-10-31T02:55:14Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-10-18T06:45:14Z, latest 2026-10-31T02:55:14Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_worktree_sweeper_journal`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.109025s, giveups=1, steals=0 (max 3/window), wait floor=60s.
