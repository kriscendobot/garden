from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-25T06:39:15Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal
notice_count: 14
first_seen: 2026-11-13T12:42:09Z
last_seen: 2026-11-25T06:39:15Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-11-13T12:42:09Z, latest 2026-11-25T06:39:15Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.028649s, giveups=1, steals=0 (max 3/window), wait floor=60s.
