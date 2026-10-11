from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-11T10:59:31Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal
notice_count: 2
first_seen: 2026-10-10T21:55:54Z
last_seen: 2026-10-11T10:59:31Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-10T21:55:54Z, latest 2026-10-11T10:59:31Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.167577s, giveups=1, steals=0 (max 3/window), wait floor=60s.
