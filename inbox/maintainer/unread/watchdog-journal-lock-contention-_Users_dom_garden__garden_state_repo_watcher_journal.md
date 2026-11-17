from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-17T06:42:45Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal
notice_count: 3
first_seen: 2026-11-14T12:44:26Z
last_seen: 2026-11-17T06:42:45Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-14T12:44:26Z, latest 2026-11-17T06:42:45Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.022517s, giveups=1, steals=0 (max 3/window), wait floor=60s.
