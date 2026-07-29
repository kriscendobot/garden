from_host: endolin-garden2-5bcdff64
from: watchdog:pr-feedback-preflight
sent_at: 2026-07-29T16:27:31Z
watchdog_key: preflight-gather-fail-endojs-endo-but-for-bots
notice_count: 3
first_seen: 2026-07-29T06:56:25Z
last_seen: 2026-07-29T16:27:31Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-07-29T06:56:25Z, latest 2026-07-29T16:27:31Z).
The SAME condition (`preflight-gather-fail-endojs-endo-but-for-bots`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

pr-feedback-preflight could not gather evidence for endojs/endo-but-for-bots#874 (cid=5120591989) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not resolve feedback target id 5120591989 on endojs/endo-but-for-bots#874 (neither a review nor an inline comment)
--- captured stderr ---
gh: Not Found (HTTP 404)
gh: Not Found (HTTP 404)
