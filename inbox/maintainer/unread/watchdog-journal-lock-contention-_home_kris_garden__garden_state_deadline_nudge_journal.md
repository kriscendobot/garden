from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-13T17:08:39Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal
notice_count: 2
first_seen: 2026-10-13T01:16:48Z
last_seen: 2026-10-13T17:08:39Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-13T01:16:48Z, latest 2026-10-13T17:08:39Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.017200s, giveups=1, steals=0 (max 3/window), wait floor=60s.
