from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-26T08:05:22Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal
notice_count: 3
first_seen: 2026-09-25T19:44:39Z
last_seen: 2026-09-26T08:05:22Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-25T19:44:39Z, latest 2026-09-26T08:05:22Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1007 >= 1000; size=358167552B packs=1007 gc.log=0; automatic remedy=applied.
