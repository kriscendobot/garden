from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-13T19:14:07Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 332
first_seen: 2026-10-12T21:38:02Z
last_seen: 2026-10-13T19:14:07Z
---
WATCHDOG notice — occurrence #332 (first seen 2026-10-12T21:38:02Z, latest 2026-10-13T19:14:07Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 332 times; this is ONE
coalesced notice that updates in place, not 332 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 9e4b600c48be 146 min ago
but still reports deployed_sha 8fd22da4bfb6a96511d6cb90898525d7df2b00c6. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
