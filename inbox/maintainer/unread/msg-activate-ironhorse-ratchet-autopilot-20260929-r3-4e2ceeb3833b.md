from_host: endolin-garden-ece02cb4
from: gardener:activate-ironhorse-ratchet-autopilot-20260929-r3
reply_to: activate-ironhorse-ratchet-autopilot-20260929-r3
msg_key: msg-activate-ironhorse-ratchet-autopilot-20260929-r3-4e2ceeb3833b
notice_count: 1
first_seen: 2026-09-29T04:33:34Z
last_seen: 2026-09-29T04:33:36Z
sent_at: 2026-09-29T04:33:36Z
---
Update (04:35Z): the ratchet is still NOT live. The leader root is still e036bb8e (it lacks c3aae0b2c0c). The roll target moved to 18df481c04b5; canary endolin-garden2 is deferring for a long job (ceiling ~07:05Z), and oros-studio is still stuck at e036bb8e. I handed off: activate-ironhorse-ratchet-autopilot-20260929-r4 is parked in plan/ (blocked), and a one-time 11:30Z timer job releases it, ahead of the ironhorse-ratchet first fire at 14:00Z (r4 re-snoozes if the deploy is still pending). The oros-studio wedge still needs a human look.
