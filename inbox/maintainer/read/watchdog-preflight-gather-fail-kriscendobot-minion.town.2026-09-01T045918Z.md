from_host: endolin-garden-ece02cb4
from: watchdog:pr-feedback-preflight
sent_at: 2026-09-01T04:59:18Z
watchdog_key: preflight-gather-fail-kriscendobot-minion.town
notice_count: 2
first_seen: 2026-08-10T23:05:19Z
last_seen: 2026-09-01T04:59:18Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-10T23:05:19Z, latest 2026-09-01T04:59:18Z).
The SAME condition (`preflight-gather-fail-kriscendobot-minion.town`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

pr-feedback-preflight could not gather evidence for kriscendobot/minion.town#73 (cid=5489113009) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not fetch pull kriscendobot/minion.town#73
--- captured stderr ---
gh: Not Found (HTTP 404)
