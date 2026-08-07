from_host: endolin-garden-ece02cb4
from: watchdog:pr-feedback-preflight
sent_at: 2026-08-07T03:41:32Z
watchdog_key: preflight-gather-fail-endojs-endo-but-for-bots
notice_count: 16
first_seen: 2026-07-29T06:56:25Z
last_seen: 2026-08-07T03:41:32Z
---
WATCHDOG notice — occurrence #16 (first seen 2026-07-29T06:56:25Z, latest 2026-08-07T03:41:32Z).
The SAME condition (`preflight-gather-fail-endojs-endo-but-for-bots`) has now been observed 16 times; this is ONE
coalesced notice that updates in place, not 16 messages. Latest detail:

pr-feedback-preflight could not gather evidence for endojs/endo-but-for-bots#851 (cid=5212022426) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not resolve feedback target id 5212022426 on endojs/endo-but-for-bots#851 (neither a review nor an inline comment)
--- captured stderr ---
gh: Not Found (HTTP 404)
gh: Not Found (HTTP 404)
