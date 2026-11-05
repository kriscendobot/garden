from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-05T11:30:47Z
watchdog_key: journal-push-contention-_home_kris_garden__garden_state_reaper_journal
notice_count: 2
first_seen: 2026-11-01T22:32:26Z
last_seen: 2026-11-05T11:30:47Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-01T22:32:26Z, latest 2026-11-05T11:30:47Z).
The SAME condition (`journal-push-contention-_home_kris_garden__garden_state_reaper_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reaper/journal: attempts p95=3.000000 max=3.000000 (cap 50), classes cas=4 server-reject=0 definite-fail=0.
