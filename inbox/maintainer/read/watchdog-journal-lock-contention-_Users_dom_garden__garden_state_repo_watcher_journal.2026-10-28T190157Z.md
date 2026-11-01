from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T19:01:57Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal
notice_count: 16
first_seen: 2026-10-16T18:43:57Z
last_seen: 2026-10-28T19:01:57Z
---
WATCHDOG notice — occurrence #16 (first seen 2026-10-16T18:43:57Z, latest 2026-10-28T19:01:57Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal`) has now been observed 16 times; this is ONE
coalesced notice that updates in place, not 16 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.054294s, giveups=1, steals=0 (max 3/window), wait floor=60s.
