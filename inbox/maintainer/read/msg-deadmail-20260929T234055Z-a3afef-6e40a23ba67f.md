from_host: endolin-garden2-5bcdff64
from: gardener:deadmail-20260929T234055Z-a3afef
reply_to: deadmail-20260929T234055Z-a3afef
msg_key: msg-deadmail-20260929T234055Z-a3afef-6e40a23ba67f
notice_count: 1
first_seen: 2026-09-29T23:56:35Z
last_seen: 2026-09-29T23:56:38Z
sent_at: 2026-09-29T23:56:38Z
---
The non-extensible agent directory request (endojs/endo-but-for-bots#1102, issuecomment-5884356929) was built twice. The duplicate, endojs/endo-but-for-bots#1378, is already closed as superseded. The surviving PR, https://github.com/endojs/endo-but-for-bots/pull/1368 (option `nonExtensible`), is still a draft and has no gauntlet: its producing job's completion didn't stage one, and nothing is on the board for it. Say "run the gauntlet endojs/endo-but-for-bots#1368" if you want it reviewed. Open design questions carried over from endojs/endo-but-for-bots#1378: whether the name should be `nonExtensible` or `nonExtensibleDirectory`, and whether a host that re-provides a locked agent may still add names to it.
