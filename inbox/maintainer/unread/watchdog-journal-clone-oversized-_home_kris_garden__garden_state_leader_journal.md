from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T12:43:55Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_leader_journal
notice_count: 3
first_seen: 2026-09-24T09:11:52Z
last_seen: 2026-09-25T12:43:55Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-24T09:11:52Z, latest 2026-09-25T12:43:55Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_leader_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: packs 1003 >= 1000; size=279122944B packs=1003 gc.log=0; automatic remedy=applied.
