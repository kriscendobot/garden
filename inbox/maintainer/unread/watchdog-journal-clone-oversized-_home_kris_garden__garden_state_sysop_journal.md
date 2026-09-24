from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-24T12:42:04Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal
notice_count: 2
first_seen: 2026-09-24T06:31:43Z
last_seen: 2026-09-24T12:42:04Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-24T06:31:43Z, latest 2026-09-24T12:42:04Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1013 >= 1000; size=193350656B packs=1013 gc.log=0; automatic remedy=applied.
