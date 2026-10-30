from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-30T05:22:02Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal
notice_count: 8
first_seen: 2026-10-17T00:47:40Z
last_seen: 2026-10-30T05:22:02Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-10-17T00:47:40Z, latest 2026-10-30T05:22:02Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.027945s, giveups=1, steals=0 (max 3/window), wait floor=60s.
