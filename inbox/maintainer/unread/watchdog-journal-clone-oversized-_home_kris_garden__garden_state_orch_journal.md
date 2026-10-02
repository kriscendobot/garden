from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-02T01:19:02Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_orch_journal
notice_count: 3
first_seen: 2026-10-02T00:49:10Z
last_seen: 2026-10-02T01:19:02Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-02T00:49:10Z, latest 2026-10-02T01:19:02Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_orch_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/orch/journal: packs 1083 >= 1000; size=238475264B packs=1083 gc.log=0; automatic remedy=deferred-deadline.
