from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-30T00:41:02Z
watchdog_key: rolling-deploy-canary-stuck-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-30T00:41:01Z
last_seen: 2026-09-30T00:41:02Z
---
Rolling-deploy canary endolin-garden2-5bcdff64 is STUCK: it was released to b3b5fc27e5dd 38 min ago
but still reports deployed_sha df7a6549e01186822e72bcde51611933d8cae3ed. Check garden-self-deploy on endolin-garden2-5bcdff64
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
