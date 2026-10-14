from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-14T04:14:02Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 354
first_seen: 2026-10-12T21:38:02Z
last_seen: 2026-10-14T04:14:02Z
---
WATCHDOG notice — occurrence #354 (first seen 2026-10-12T21:38:02Z, latest 2026-10-14T04:14:02Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 354 times; this is ONE
coalesced notice that updates in place, not 354 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 369ca75aba9d 21 min ago
but still reports deployed_sha e1e898bdc9d44caec21a53a2b2a2986cc1976e5e. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
