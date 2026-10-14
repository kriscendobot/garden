from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-14T02:32:03Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 353
first_seen: 2026-10-12T21:38:02Z
last_seen: 2026-10-14T02:32:03Z
---
WATCHDOG notice — occurrence #353 (first seen 2026-10-12T21:38:02Z, latest 2026-10-14T02:32:03Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 353 times; this is ONE
coalesced notice that updates in place, not 353 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to e1e898bdc9d4 48 min ago
but still reports deployed_sha 242f944cdf7db5e58f19a09e9b9a07a5d3c2effb. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
