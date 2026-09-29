from_host: endolin-garden-ece02cb4
from: gardener:activate-ironhorse-ratchet-autopilot-20260929
reply_to: activate-ironhorse-ratchet-autopilot-20260929
msg_key: msg-activate-ironhorse-ratchet-autopilot-20260929-fc327b682232
notice_count: 1
first_seen: 2026-09-29T03:23:14Z
last_seen: 2026-09-29T03:23:16Z
sent_at: 2026-09-29T03:23:16Z
---
Ironhorse ratchet activation status (03:23Z): the leader root is still e036bb8e065, which predates the ratchet gates. The rolling deploy to 65f0c2e got through canary endolin-garden2 (validated ~02:50Z; it already had c3aae0b2c0c). Canary oros-studio-garden-ce242c49 has been flapping offline and is stuck at e036bb8e, now in retry backoff. main2 churned about 7 times overnight, and each change restarted the roll. No ironhorse-ratchet-watch tick has been emitted. I re-snoozed the schedule to 2026-09-29T14:00Z (2h cadence and occupancy unchanged). PR 1359 is untouched. The remaining work is handed off to job activate-ironhorse-ratchet-autopilot-20260929-r3. If oros-studio stays wedged, it may need a human look.
