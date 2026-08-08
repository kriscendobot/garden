from_host: endolin-garden-ece02cb4
from: watchdog:pr-feedback-preflight
sent_at: 2026-08-08T03:59:08Z
watchdog_key: preflight-gather-fail-endojs-endo-but-for-bots
notice_count: 18
first_seen: 2026-07-29T06:56:25Z
last_seen: 2026-08-08T03:59:08Z
---
WATCHDOG notice — occurrence #18 (first seen 2026-07-29T06:56:25Z, latest 2026-08-08T03:59:08Z).
The SAME condition (`preflight-gather-fail-endojs-endo-but-for-bots`) has now been observed 18 times; this is ONE
coalesced notice that updates in place, not 18 messages. Latest detail:

pr-feedback-preflight could not gather evidence for endojs/endo-but-for-bots#963 (cid=5224391071) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not resolve feedback target id 5224391071 on endojs/endo-but-for-bots#963 (neither a review nor an inline comment)
--- captured stderr ---
gh: Not Found (HTTP 404)
gh: Not Found (HTTP 404)
