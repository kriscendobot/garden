from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-26T16:44:16Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_fork_watch_journal
notice_count: 10
first_seen: 2026-10-18T14:45:48Z
last_seen: 2026-10-26T16:44:16Z
---
WATCHDOG notice — occurrence #10 (first seen 2026-10-18T14:45:48Z, latest 2026-10-26T16:44:16Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_fork_watch_journal`) has now been observed 10 times; this is ONE
coalesced notice that updates in place, not 10 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.080316s, giveups=1, steals=0 (max 3/window), wait floor=60s.
