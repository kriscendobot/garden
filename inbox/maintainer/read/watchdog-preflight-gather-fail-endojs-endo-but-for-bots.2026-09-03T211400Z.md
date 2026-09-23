from_host: endolin-garden-ece02cb4
from: watchdog:pr-feedback-preflight
sent_at: 2026-09-03T21:14:00Z
watchdog_key: preflight-gather-fail-endojs-endo-but-for-bots
notice_count: 2
first_seen: 2026-07-30T00:14:18Z
last_seen: 2026-09-03T21:14:00Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-07-30T00:14:18Z, latest 2026-09-03T21:14:00Z).
The SAME condition (`preflight-gather-fail-endojs-endo-but-for-bots`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

pr-feedback-preflight could not gather evidence for endojs/endo-but-for-bots#982 (cid=5532176099) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
evidence gathering failed: could not fetch pull endojs/endo-but-for-bots#982
--- captured stderr ---
gh: Not Found (HTTP 404)
