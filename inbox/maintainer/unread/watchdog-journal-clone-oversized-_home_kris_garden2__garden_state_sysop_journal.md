from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-09-23T20:47:02Z
watchdog_key: journal-clone-oversized-_home_kris_garden2__garden_state_sysop_journal
notice_count: 3
first_seen: 2026-09-23T19:40:07Z
last_seen: 2026-09-23T20:47:02Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-23T19:40:07Z, latest 2026-09-23T20:47:02Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden2__garden_state_sysop_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/sysop/journal: packs 57 >= 50; size=55468032B packs=57 gc.log=0; automatic remedy=backoff.
