from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T16:02:31Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal
notice_count: 6
first_seen: 2026-09-25T19:44:39Z
last_seen: 2026-09-27T16:02:31Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-25T19:44:39Z, latest 2026-09-27T16:02:31Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1001 >= 1000; size=285477888B packs=1001 gc.log=0; automatic remedy=deferred.
