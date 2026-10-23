from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-23T13:38:39Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal
notice_count: 7
first_seen: 2026-10-17T06:49:11Z
last_seen: 2026-10-23T13:38:39Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-10-17T06:49:11Z, latest 2026-10-23T13:38:39Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.037560s, giveups=2, steals=0 (max 3/window), wait floor=60s.
