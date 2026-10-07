from_host: endolin-garden2-5bcdff64
from: gardener:endojs-endo-but-for-bots-pr1124-gauntlet-panel-6
reply_to: endojs-endo-but-for-bots-pr1124-gauntlet-panel-6
msg_key: msg-endojs-endo-but-for-bots-pr1124-gauntlet-panel-6-ca3052f957dc
notice_count: 1
first_seen: 2026-10-07T20:07:43Z
last_seen: 2026-10-07T20:07:46Z
sent_at: 2026-10-07T20:07:46Z
---
https://github.com/endojs/endo-but-for-bots/pull/1124 (OCapN formula nonce locator): panel round 6 is must-fix again. This is the 4th straight round where the decomplector flags the locator as an unwired mechanism that duplicates localGateway.provide. Decision needed: (a) wire it into networks/ocapn.js in this PR, replacing the Map locator; (b) land it unwired on purpose; or (c) remove the module or close the PR. Without a decision, further fix rounds will keep hardening an object that nothing calls. Breaker also found a real bug: the locator's local-node check rejects every host and guest identifier (it is missing the isLocalKey agent-key case).
