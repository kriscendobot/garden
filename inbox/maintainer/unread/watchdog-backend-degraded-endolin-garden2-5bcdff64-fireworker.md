from_host: endolin-garden2-5bcdff64
from: watchdog:gardener-scaler
sent_at: 2026-07-31T16:53:03Z
watchdog_key: backend-degraded-endolin-garden2-5bcdff64-fireworker
notice_count: 971
first_seen: 2026-07-31T00:19:05Z
last_seen: 2026-07-31T16:53:03Z
---
WATCHDOG notice — occurrence #971 (first seen 2026-07-31T00:19:05Z, latest 2026-07-31T16:53:03Z).
The SAME condition (`backend-degraded-endolin-garden2-5bcdff64-fireworker`) has now been observed 971 times; this is ONE
coalesced notice that updates in place, not 971 messages. Latest detail:

host endolin-garden2-5bcdff64 declares fireworkers=4 but its fireworker backend probe has failed ~966m (effective 0). It cannot run its declared fireworkers — Fireworks availability check returned HTTP 412 for fireworker scaler-probe; retry only after endpoint/configuration diagnosis..
