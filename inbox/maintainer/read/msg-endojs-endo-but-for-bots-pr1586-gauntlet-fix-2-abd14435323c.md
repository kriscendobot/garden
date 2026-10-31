from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1586-gauntlet-fix-2
reply_to: endojs-endo-but-for-bots-pr1586-gauntlet-fix-2
msg_key: msg-endojs-endo-but-for-bots-pr1586-gauntlet-fix-2-abd14435323c
notice_count: 1
first_seen: 2026-10-31T12:32:55Z
last_seen: 2026-10-31T12:32:57Z
sent_at: 2026-10-31T12:32:57Z
---
endojs/endo-but-for-bots#1586 (fs interface reconciliation), panel-2 decomplector finding: you asked on endojs/endo-but-for-bots#464 (https://github.com/endojs/endo-but-for-bots/pull/464#discussion_r3434032260, 2026-06-18) to rename the re-root attenuator `mount` ("Fold all these into a unified `mount` verb", r3434147255). The design's D5 records `subView` instead, citing no maintainer reversal, and endojs/endo-but-for-bots#1586 broadens `subView` onto platform `Directory` and `SnapshotTree`. Should the name be `mount` (a repo-wide rename, also of the existing `EndoMount.subView` on llm, best done as its own PR), or is `subView` acceptable? I am leaving `subView` in place in this fix round; reply here and a follow-up can do the rename.
