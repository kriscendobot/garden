from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-10T10:48:08Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal
notice_count: 5
first_seen: 2026-11-05T22:52:21Z
last_seen: 2026-11-10T10:48:08Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-11-05T22:52:21Z, latest 2026-11-10T10:48:08Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.021760s, giveups=1, steals=0 (max 3/window), wait floor=60s.
