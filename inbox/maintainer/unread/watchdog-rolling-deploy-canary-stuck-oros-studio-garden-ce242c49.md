from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-12T06:20:02Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 478
first_seen: 2026-10-09T06:59:03Z
last_seen: 2026-10-12T06:20:02Z
---
WATCHDOG notice — occurrence #478 (first seen 2026-10-09T06:59:03Z, latest 2026-10-12T06:20:02Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 478 times; this is ONE
coalesced notice that updates in place, not 478 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 563e6db8cbe5 21 min ago
but still reports deployed_sha 78f9dacc9383e72f5c069392606e4cd7da886986. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
