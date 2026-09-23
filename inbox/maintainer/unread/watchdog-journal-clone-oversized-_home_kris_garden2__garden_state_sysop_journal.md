from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-09-23T20:01:41Z
watchdog_key: journal-clone-oversized-_home_kris_garden2__garden_state_sysop_journal
notice_count: 2
first_seen: 2026-09-23T19:40:07Z
last_seen: 2026-09-23T20:01:41Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-23T19:40:07Z, latest 2026-09-23T20:01:41Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden2__garden_state_sysop_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/sysop/journal: packs 50 >= 50; size=50202624B packs=50 gc.log=0; automatic remedy=backoff.
