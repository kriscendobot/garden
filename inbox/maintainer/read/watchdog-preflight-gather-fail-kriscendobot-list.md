from_host: endolin-garden2-5bcdff64
from: watchdog:pr-feedback-preflight
sent_at: 2026-08-11T00:17:22Z
watchdog_key: preflight-gather-fail-kriscendobot-list
notice_count: 2
first_seen: 2026-08-10T23:59:33Z
last_seen: 2026-08-11T00:17:22Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-10T23:59:33Z, latest 2026-08-11T00:17:22Z).
The SAME condition (`preflight-gather-fail-kriscendobot-list`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

pr-feedback-preflight could not gather evidence for kriscendobot/list#1 (cid=5247528889) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not resolve feedback target id 5247528889 on kriscendobot/list#1 (neither a review nor an inline comment)
--- captured stderr ---
gh: Not Found (HTTP 404)
gh: Not Found (HTTP 404)
