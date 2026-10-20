from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-20T08:49:16Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal
notice_count: 8
first_seen: 2026-10-16T18:43:57Z
last_seen: 2026-10-20T08:49:16Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-10-16T18:43:57Z, latest 2026-10-20T08:49:16Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.057230s, giveups=1, steals=0 (max 3/window), wait floor=60s.
