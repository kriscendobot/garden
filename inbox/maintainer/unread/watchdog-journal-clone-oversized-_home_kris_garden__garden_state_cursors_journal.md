from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-24T22:12:30Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal
notice_count: 3
first_seen: 2026-09-24T07:01:46Z
last_seen: 2026-09-24T22:12:30Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-24T07:01:46Z, latest 2026-09-24T22:12:30Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: packs 1001 >= 1000; size=155181056B packs=1001 gc.log=0; automatic remedy=backoff.
