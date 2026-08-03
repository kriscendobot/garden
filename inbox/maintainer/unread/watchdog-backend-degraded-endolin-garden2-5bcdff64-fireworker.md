from_host: endolin-garden2-5bcdff64
from: watchdog:gardener-scaler
sent_at: 2026-08-03T13:18:44Z
watchdog_key: backend-degraded-endolin-garden2-5bcdff64-fireworker
notice_count: 4958
first_seen: 2026-07-31T00:19:05Z
last_seen: 2026-08-03T13:18:44Z
---
WATCHDOG notice — occurrence #4958 (first seen 2026-07-31T00:19:05Z, latest 2026-08-03T13:18:44Z).
The SAME condition (`backend-degraded-endolin-garden2-5bcdff64-fireworker`) has now been observed 4958 times; this is ONE
coalesced notice that updates in place, not 4958 messages. Latest detail:

host endolin-garden2-5bcdff64 declares fireworkers=4 but its fireworker backend probe has failed ~4953m (effective 0). It cannot run its declared fireworkers — Fireworks availability check returned HTTP 412 for fireworker scaler-probe; retry only after endpoint/configuration diagnosis..
