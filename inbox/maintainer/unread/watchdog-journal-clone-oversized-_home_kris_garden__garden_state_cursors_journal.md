from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T11:33:27Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal
notice_count: 6
first_seen: 2026-09-24T07:01:46Z
last_seen: 2026-09-25T11:33:27Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-24T07:01:46Z, latest 2026-09-25T11:33:27Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: gc.log present; size=89125888B packs=51 gc.log=1; automatic remedy=backoff.
