from_host: endolin-garden2-5bcdff64
from: watchdog:pr-feedback-preflight
sent_at: 2026-08-10T17:28:06Z
watchdog_key: preflight-gather-fail-endojs-endo-but-for-bots
notice_count: 19
first_seen: 2026-07-29T06:56:25Z
last_seen: 2026-08-10T17:28:06Z
---
WATCHDOG notice — occurrence #19 (first seen 2026-07-29T06:56:25Z, latest 2026-08-10T17:28:06Z).
The SAME condition (`preflight-gather-fail-endojs-endo-but-for-bots`) has now been observed 19 times; this is ONE
coalesced notice that updates in place, not 19 messages. Latest detail:

pr-feedback-preflight could not gather evidence for endojs/endo-but-for-bots#963 (cid=5243661900) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not resolve feedback target id 5243661900 on endojs/endo-but-for-bots#963 (neither a review nor an inline comment)
--- captured stderr ---
gh: Not Found (HTTP 404)
gh: Not Found (HTTP 404)
