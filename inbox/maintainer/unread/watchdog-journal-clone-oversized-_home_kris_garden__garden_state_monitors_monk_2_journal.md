from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-23T22:10:58Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_monitors_monk_2_journal
notice_count: 2
first_seen: 2026-09-23T20:11:07Z
last_seen: 2026-09-23T22:10:58Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-23T20:11:07Z, latest 2026-09-23T22:10:58Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_monitors_monk_2_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monitors/monk-2/journal: packs 50 >= 50; size=50608128B packs=50 gc.log=0; automatic remedy=backoff.
