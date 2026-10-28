from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T13:32:51Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_screening_journal
notice_count: 4
first_seen: 2026-10-16T22:47:42Z
last_seen: 2026-10-28T13:32:51Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-16T22:47:42Z, latest 2026-10-28T13:32:51Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_screening_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.030244s, giveups=1, steals=0 (max 3/window), wait floor=60s.
