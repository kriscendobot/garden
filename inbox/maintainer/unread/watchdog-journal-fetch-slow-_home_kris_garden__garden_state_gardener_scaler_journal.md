from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T16:00:14Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_gardener_scaler_journal
notice_count: 3
first_seen: 2026-10-18T11:22:28Z
last_seen: 2026-10-28T16:00:14Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-18T11:22:28Z, latest 2026-10-28T16:00:14Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_gardener_scaler_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: p95=3.132436s max=45.002225s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
