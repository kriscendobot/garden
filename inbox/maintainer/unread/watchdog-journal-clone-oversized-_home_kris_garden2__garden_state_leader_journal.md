from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-09-23T20:11:39Z
watchdog_key: journal-clone-oversized-_home_kris_garden2__garden_state_leader_journal
notice_count: 2
first_seen: 2026-09-23T19:39:21Z
last_seen: 2026-09-23T20:11:39Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-23T19:39:21Z, latest 2026-09-23T20:11:39Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden2__garden_state_leader_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/leader/journal: packs 51 >= 50; size=50398208B packs=51 gc.log=0; automatic remedy=backoff.
