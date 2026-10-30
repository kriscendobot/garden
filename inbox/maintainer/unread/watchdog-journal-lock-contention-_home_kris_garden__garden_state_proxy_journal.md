from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-30T00:38:56Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_proxy_journal
notice_count: 10
first_seen: 2026-10-16T22:47:31Z
last_seen: 2026-10-30T00:38:56Z
---
WATCHDOG notice — occurrence #10 (first seen 2026-10-16T22:47:31Z, latest 2026-10-30T00:38:56Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_proxy_journal`) has now been observed 10 times; this is ONE
coalesced notice that updates in place, not 10 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.013581s, giveups=1, steals=0 (max 3/window), wait floor=60s.
