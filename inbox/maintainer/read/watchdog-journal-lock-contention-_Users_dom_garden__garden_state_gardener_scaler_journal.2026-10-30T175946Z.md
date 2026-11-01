from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-30T17:59:46Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal
notice_count: 13
first_seen: 2026-10-17T06:44:40Z
last_seen: 2026-10-30T17:59:46Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-10-17T06:44:40Z, latest 2026-10-30T17:59:46Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.098238s, giveups=1, steals=0 (max 3/window), wait floor=60s.
