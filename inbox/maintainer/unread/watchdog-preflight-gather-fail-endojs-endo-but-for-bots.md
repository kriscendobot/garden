from_host: endolin-garden2-5bcdff64
from: watchdog:pr-feedback-preflight
sent_at: 2026-07-30T21:14:32Z
watchdog_key: preflight-gather-fail-endojs-endo-but-for-bots
notice_count: 5
first_seen: 2026-07-29T06:56:25Z
last_seen: 2026-07-30T21:14:32Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-07-29T06:56:25Z, latest 2026-07-30T21:14:32Z).
The SAME condition (`preflight-gather-fail-endojs-endo-but-for-bots`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

pr-feedback-preflight could not gather evidence for endojs/endo-but-for-bots#403 (cid=5124648430) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not resolve feedback target id 5124648430 on endojs/endo-but-for-bots#403 (neither a review nor an inline comment)
--- captured stderr ---
gh: Not Found (HTTP 404)
gh: Not Found (HTTP 404)
