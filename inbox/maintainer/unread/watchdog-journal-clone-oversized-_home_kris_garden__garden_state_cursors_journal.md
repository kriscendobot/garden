from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T07:26:51Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal
notice_count: 4
first_seen: 2026-09-25T22:04:03Z
last_seen: 2026-09-27T07:26:51Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-25T22:04:03Z, latest 2026-09-27T07:26:51Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: packs 1002 >= 1000; size=303381504B packs=1002 gc.log=0; automatic remedy=deferred.
