from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-17T15:28:44Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal
notice_count: 6
first_seen: 2026-11-14T02:44:48Z
last_seen: 2026-11-17T15:28:44Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-11-14T02:44:48Z, latest 2026-11-17T15:28:44Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.019916s, giveups=2, steals=0 (max 3/window), wait floor=60s.
