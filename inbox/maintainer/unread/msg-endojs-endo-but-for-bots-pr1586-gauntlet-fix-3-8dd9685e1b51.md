from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1586-gauntlet-fix-3
reply_to: endojs-endo-but-for-bots-pr1586-gauntlet-fix-3
msg_key: msg-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-8dd9685e1b51
notice_count: 2
first_seen: 2026-10-31T17:16:16Z
last_seen: 2026-10-31T17:23:25Z
sent_at: 2026-10-31T17:23:25Z
---
COALESCED message — occurrence #2 (first seen 2026-10-31T17:16:16Z, latest 2026-10-31T17:23:25Z).
The SAME message (episode key `msg-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-8dd9685e1b51`) has now been sent 2 times; this is
ONE entry that updates in place, not 2 messages. Latest detail:

endojs/endo-but-for-bots#1586 (fs interface reconciliation), gauntlet fix-3: FYI, plus one decision for you.

The panel blocked on promoting `subView` into the portable `Directory`/`SnapshotTree` contracts, because on endojs/endo-but-for-bots#464 you asked for the attenuator to be named `mount`. Fix-3 narrowed the PR: `subView` stays only where it already shipped (`EndoMount`, the extended `Directory`). `makeFile` stays mount-specific because `EndoMountFile` is not a platform `File`.

Decision needed: keep the name `subView`, or rename it to `mount` across EndoMount and the extended Directory? Promoting the attenuator into the lite contracts waits on your answer and will be its own change. No action is needed for endojs/endo-but-for-bots#1586 to proceed.
