from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T13:55:07Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_gardener_scaler_journal
notice_count: 2
first_seen: 2026-10-18T11:22:28Z
last_seen: 2026-10-28T13:55:07Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-18T11:22:28Z, latest 2026-10-28T13:55:07Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_gardener_scaler_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: p95=1.717010s max=36.174201s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
