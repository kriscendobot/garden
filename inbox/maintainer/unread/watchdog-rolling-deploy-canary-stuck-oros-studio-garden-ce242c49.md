from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-14T13:29:07Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 357
first_seen: 2026-10-12T21:38:02Z
last_seen: 2026-10-14T13:29:07Z
---
WATCHDOG notice — occurrence #357 (first seen 2026-10-12T21:38:02Z, latest 2026-10-14T13:29:07Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 357 times; this is ONE
coalesced notice that updates in place, not 357 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 42863eb06db9 20 min ago
but still reports deployed_sha d82f327af50a9b95a2c8f25e550132520910de7a. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
