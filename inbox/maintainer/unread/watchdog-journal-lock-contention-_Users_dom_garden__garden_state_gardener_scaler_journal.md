from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-11T04:44:07Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal
notice_count: 6
first_seen: 2026-11-05T22:52:21Z
last_seen: 2026-11-11T04:44:07Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-11-05T22:52:21Z, latest 2026-11-11T04:44:07Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.041889s, giveups=1, steals=0 (max 3/window), wait floor=60s.
