from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-05T11:50:34Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_screening_journal
notice_count: 4
first_seen: 2026-11-02T14:48:33Z
last_seen: 2026-11-05T11:50:34Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-11-02T14:48:33Z, latest 2026-11-05T11:50:34Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_screening_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.056790s, giveups=1, steals=0 (max 3/window), wait floor=60s.
