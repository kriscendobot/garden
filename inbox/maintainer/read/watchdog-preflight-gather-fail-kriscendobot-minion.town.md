from_host: endolin-garden2-5bcdff64
from: watchdog:pr-feedback-preflight
sent_at: 2026-08-11T21:39:47Z
watchdog_key: preflight-gather-fail-kriscendobot-minion.town
notice_count: 4
first_seen: 2026-08-10T23:05:19Z
last_seen: 2026-08-11T21:39:47Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-08-10T23:05:19Z, latest 2026-08-11T21:39:47Z).
The SAME condition (`preflight-gather-fail-kriscendobot-minion.town`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

pr-feedback-preflight could not gather evidence for kriscendobot/minion.town#39 (cid=5259131482) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not resolve feedback target id 5259131482 on kriscendobot/minion.town#39 (neither a review nor an inline comment)
--- captured stderr ---
gh: Not Found (HTTP 404)
gh: Not Found (HTTP 404)
