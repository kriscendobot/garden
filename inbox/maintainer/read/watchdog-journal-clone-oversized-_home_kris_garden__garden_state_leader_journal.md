from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-23T20:50:53Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_leader_journal
notice_count: 2
first_seen: 2026-09-23T19:45:14Z
last_seen: 2026-09-23T20:50:53Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-23T19:45:14Z, latest 2026-09-23T20:50:53Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_leader_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: packs 56 >= 50; size=53584896B packs=56 gc.log=0; automatic remedy=backoff.
