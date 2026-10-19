from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-19T14:57:21Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal
notice_count: 4
first_seen: 2026-10-17T06:49:11Z
last_seen: 2026-10-19T14:57:21Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-17T06:49:11Z, latest 2026-10-19T14:57:21Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.029131s, giveups=1, steals=0 (max 3/window), wait floor=60s.
