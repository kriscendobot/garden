from_host: endolin-garden2-5bcdff64
from: watchdog:pr-feedback-preflight
sent_at: 2026-08-10T23:15:26Z
watchdog_key: preflight-gather-fail-kriscendobot-minion.town
notice_count: 2
first_seen: 2026-08-10T23:05:19Z
last_seen: 2026-08-10T23:15:26Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-10T23:05:19Z, latest 2026-08-10T23:15:26Z).
The SAME condition (`preflight-gather-fail-kriscendobot-minion.town`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

pr-feedback-preflight could not gather evidence for kriscendobot/minion.town#34 (cid=5247080255) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not resolve feedback target id 5247080255 on kriscendobot/minion.town#34 (neither a review nor an inline comment)
--- captured stderr ---
gh: Not Found (HTTP 404)
gh: Not Found (HTTP 404)
