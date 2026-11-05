from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-05T16:32:14Z
watchdog_key: journal-push-contention-_Users_dom_garden__garden_state_producer_journal
notice_count: 2
first_seen: 2026-11-04T12:10:32Z
last_seen: 2026-11-05T16:32:14Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-04T12:10:32Z, latest 2026-11-05T16:32:14Z).
The SAME condition (`journal-push-contention-_Users_dom_garden__garden_state_producer_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal push contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: attempts p95=7.000000 max=7.000000 (cap 50), classes cas=10 server-reject=8 definite-fail=0.
