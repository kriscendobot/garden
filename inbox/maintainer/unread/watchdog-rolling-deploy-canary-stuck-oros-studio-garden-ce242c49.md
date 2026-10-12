from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-12T22:38:02Z
watchdog_key: rolling-deploy-canary-stuck-oros-studio-garden-ce242c49
notice_count: 21
first_seen: 2026-10-12T21:38:02Z
last_seen: 2026-10-12T22:38:02Z
---
WATCHDOG notice — occurrence #21 (first seen 2026-10-12T21:38:02Z, latest 2026-10-12T22:38:02Z).
The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 21 times; this is ONE
coalesced notice that updates in place, not 21 messages. Latest detail:

Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 0411ed9fbd12 80 min ago
but still reports deployed_sha f9b279f6200603bec814a9feb5d2713e105035a1. Check garden-self-deploy on oros-studio-garden-ce242c49
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=endolin-garden-ece02cb4)
