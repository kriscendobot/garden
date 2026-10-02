from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-02T11:04:38Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_orch_journal
notice_count: 9
first_seen: 2026-10-02T00:49:10Z
last_seen: 2026-10-02T11:04:38Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-10-02T00:49:10Z, latest 2026-10-02T11:04:38Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_orch_journal`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/orch/journal: packs 1886 >= 1000; size=277688320B packs=1886 gc.log=0; automatic remedy=applied.
