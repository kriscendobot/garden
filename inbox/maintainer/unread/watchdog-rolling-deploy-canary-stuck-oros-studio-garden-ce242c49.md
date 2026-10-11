from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-11T21:20:03Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 452
first_seen: 2026-10-09T06:59:03Z
last_seen: 2026-10-11T21:20:03Z
---
WATCHDOG notice — occurrence #452 (first seen 2026-10-09T06:59:03Z, latest 2026-10-11T21:20:03Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 452 times; this is ONE
coalesced notice that updates in place, not 452 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 78f9dacc9383 21 min ago
but still reports deployed_sha db962f13979837e7a6c8f91920b8f67394c3c9d5. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
