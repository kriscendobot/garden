from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-23T21:10:57Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal
notice_count: 3
first_seen: 2026-09-23T19:48:28Z
last_seen: 2026-09-23T21:10:57Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-23T19:48:28Z, latest 2026-09-23T21:10:57Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: packs 55 >= 50; size=138047488B packs=55 gc.log=0; automatic remedy=backoff.
