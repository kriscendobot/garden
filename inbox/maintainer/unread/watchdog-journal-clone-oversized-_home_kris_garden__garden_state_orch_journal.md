from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-02T01:04:16Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_orch_journal
notice_count: 2
first_seen: 2026-10-02T00:49:10Z
last_seen: 2026-10-02T01:04:16Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-02T00:49:10Z, latest 2026-10-02T01:04:16Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_orch_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/orch/journal: packs 1060 >= 1000; size=237820928B packs=1060 gc.log=0; automatic remedy=deferred-deadline.
