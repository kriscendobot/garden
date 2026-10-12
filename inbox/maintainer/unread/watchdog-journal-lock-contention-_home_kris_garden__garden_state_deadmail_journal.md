from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-12T02:45:55Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_deadmail_journal
notice_count: 2
first_seen: 2026-10-11T10:44:34Z
last_seen: 2026-10-12T02:45:55Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-11T10:44:34Z, latest 2026-10-12T02:45:55Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_deadmail_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadmail/journal: p95=0.015070s, giveups=1, steals=0 (max 3/window), wait floor=60s.
