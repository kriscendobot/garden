from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T15:23:38Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal
notice_count: 7
first_seen: 2026-09-24T07:01:46Z
last_seen: 2026-09-25T15:23:38Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-09-24T07:01:46Z, latest 2026-09-25T15:23:38Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: packs 1018 >= 1000; size=203516928B packs=1018 gc.log=0; automatic remedy=backoff.
