from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-24T01:34:34Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal
notice_count: 7
first_seen: 2026-10-17T06:44:40Z
last_seen: 2026-10-24T01:34:34Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-10-17T06:44:40Z, latest 2026-10-24T01:34:34Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.034476s, giveups=1, steals=0 (max 3/window), wait floor=60s.
