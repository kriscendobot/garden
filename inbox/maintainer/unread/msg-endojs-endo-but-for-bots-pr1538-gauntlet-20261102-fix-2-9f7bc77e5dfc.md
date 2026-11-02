from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-2
reply_to: endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-2
msg_key: msg-endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-2-9f7bc77e5dfc
notice_count: 1
first_seen: 2026-11-02T04:31:59Z
last_seen: 2026-11-02T04:32:09Z
sent_at: 2026-11-02T04:32:09Z
---
endojs/endo-but-for-bots#1538 (provideGitClone): the panel's decomplector seat asks for a maintainer ruling before another hardening round. Is a concurrent writer on the destination mount in scope for provideGitClone? If yes, the current staging-beside-the-mount + identity-checked publication stays (the design states this rationale). If no, the simpler contract is: exclusive destination, refuse non-empty, clone straight in, and remove on failure only what the clone created. That would drop the staging records, renameNoReplace and the four new FilePowers members. Fix round 2 applied the other must-fix items and kept the mechanism. Reply with "keep staging" or "simplify".
