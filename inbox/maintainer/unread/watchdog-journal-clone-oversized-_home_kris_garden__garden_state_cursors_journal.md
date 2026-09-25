from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T04:22:52Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal
notice_count: 4
first_seen: 2026-09-24T07:01:46Z
last_seen: 2026-09-25T04:22:52Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-24T07:01:46Z, latest 2026-09-25T04:22:52Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: packs 1005 >= 1000; size=159394816B packs=1005 gc.log=0; automatic remedy=backoff.
