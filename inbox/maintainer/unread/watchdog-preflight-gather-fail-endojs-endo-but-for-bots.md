from_host: endolin-garden-ece02cb4
from: watchdog:pr-feedback-preflight
sent_at: 2026-08-06T05:52:42Z
watchdog_key: preflight-gather-fail-endojs-endo-but-for-bots
notice_count: 13
first_seen: 2026-07-29T06:56:25Z
last_seen: 2026-08-06T05:52:42Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-07-29T06:56:25Z, latest 2026-08-06T05:52:42Z).
The SAME condition (`preflight-gather-fail-endojs-endo-but-for-bots`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

pr-feedback-preflight could not gather evidence for endojs/endo-but-for-bots#909 (cid=5200880710) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not resolve feedback target id 5200880710 on endojs/endo-but-for-bots#909 (neither a review nor an inline comment)
--- captured stderr ---
gh: Not Found (HTTP 404)
gh: Not Found (HTTP 404)
