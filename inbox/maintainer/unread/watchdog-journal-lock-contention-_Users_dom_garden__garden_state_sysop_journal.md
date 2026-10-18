from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-18T23:21:32Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal
notice_count: 3
first_seen: 2026-10-17T06:49:11Z
last_seen: 2026-10-18T23:21:32Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-17T06:49:11Z, latest 2026-10-18T23:21:32Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.018766s, giveups=1, steals=0 (max 3/window), wait floor=60s.
