from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-25T12:43:21Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_proxy_journal
notice_count: 4
first_seen: 2026-10-16T22:47:31Z
last_seen: 2026-10-25T12:43:21Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-16T22:47:31Z, latest 2026-10-25T12:43:21Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_proxy_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.013097s, giveups=1, steals=0 (max 3/window), wait floor=60s.
