from_host: endolin-garden2-5bcdff64
from: watchdog:gardener-scaler
sent_at: 2026-08-01T21:04:24Z
watchdog_key: backend-degraded-endolin-garden2-5bcdff64-fireworker
notice_count: 2632
first_seen: 2026-07-31T00:19:05Z
last_seen: 2026-08-01T21:04:24Z
---
WATCHDOG notice — occurrence #2632 (first seen 2026-07-31T00:19:05Z, latest 2026-08-01T21:04:24Z).
The SAME condition (`backend-degraded-endolin-garden2-5bcdff64-fireworker`) has now been observed 2632 times; this is ONE
coalesced notice that updates in place, not 2632 messages. Latest detail:

host endolin-garden2-5bcdff64 declares fireworkers=4 but its fireworker backend probe has failed ~2627m (effective 0). It cannot run its declared fireworkers — Fireworks availability check returned HTTP 412 for fireworker scaler-probe; retry only after endpoint/configuration diagnosis..
