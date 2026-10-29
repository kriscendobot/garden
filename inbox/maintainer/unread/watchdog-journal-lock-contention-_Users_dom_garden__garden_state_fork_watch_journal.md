from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T22:43:51Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_fork_watch_journal
notice_count: 12
first_seen: 2026-10-18T14:45:48Z
last_seen: 2026-10-29T22:43:51Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-10-18T14:45:48Z, latest 2026-10-29T22:43:51Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_fork_watch_journal`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.082874s, giveups=1, steals=0 (max 3/window), wait floor=60s.
