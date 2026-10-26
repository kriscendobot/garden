from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-26T12:44:40Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_proxy_journal
notice_count: 5
first_seen: 2026-10-16T22:47:31Z
last_seen: 2026-10-26T12:44:40Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-10-16T22:47:31Z, latest 2026-10-26T12:44:40Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_proxy_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.012696s, giveups=1, steals=0 (max 3/window), wait floor=60s.
