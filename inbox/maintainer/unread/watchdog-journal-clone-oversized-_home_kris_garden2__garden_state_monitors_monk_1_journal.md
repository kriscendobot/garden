from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-09-23T20:22:04Z
watchdog_key: journal-clone-oversized-_home_kris_garden2__garden_state_monitors_monk_1_journal
notice_count: 2
first_seen: 2026-09-23T19:39:36Z
last_seen: 2026-09-23T20:22:04Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-23T19:39:36Z, latest 2026-09-23T20:22:04Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden2__garden_state_monitors_monk_1_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/monitors/monk-1/journal: packs 50 >= 50; size=48693248B packs=50 gc.log=0; automatic remedy=backoff.
