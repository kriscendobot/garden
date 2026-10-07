from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-07T22:13:18Z
watchdog_key: journal-push-contention-_home_kris_garden2__garden_state_cursors_journal
notice_count: 3
first_seen: 2026-10-07T15:15:39Z
last_seen: 2026-10-07T22:13:18Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-07T15:15:39Z, latest 2026-10-07T22:13:18Z).
The SAME condition (`journal-push-contention-_home_kris_garden2__garden_state_cursors_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal push contention on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/cursors/journal: attempts p95=5.000000 max=8.000000 (cap 50), classes cas=14 server-reject=0 definite-fail=0.
