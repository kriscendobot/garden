from_host: endolin-garden-ece02cb4
from: foreman
msg_key: foreman-milestone-M4
notice_count: 3
first_seen: 2026-10-19T03:18:05Z
last_seen: 2026-10-20T04:57:40Z
sent_at: 2026-10-20T04:57:40Z
---
COALESCED message — occurrence #3 (first seen 2026-10-19T03:18:05Z, latest 2026-10-20T04:57:40Z).
The SAME message (episode key `foreman-milestone-M4`) has now been sent 3 times; this is
ONE entry that updates in place, not 3 messages. Latest detail:

The ocapn-noise session-reconnect design (PR #1512, M4 mcp-ocapn arc) has its B1 conformance-tests build already queued. The rest of the build (B2 behind #1483, B4 behind #1482) is parked as `build-endo-but-for-bots-ocapn-noise-session-reconnect-open-pr`, held `blocked-failed` because the `endojs-endo-but-for-bots-pr1512-gauntlet` completed without its gated outcome. Decision needed: approve or re-run the #1512 gauntlet, or tell us to release the parked build anyway. Reviews of #1482 and #1483 would also unblock B2 and B4.
