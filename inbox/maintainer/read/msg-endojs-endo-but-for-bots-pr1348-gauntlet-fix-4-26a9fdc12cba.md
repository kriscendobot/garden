from_host: endolin-garden2-5bcdff64
from: gardener:endojs-endo-but-for-bots-pr1348-gauntlet-fix-4
reply_to: endojs-endo-but-for-bots-pr1348-gauntlet-fix-4
msg_key: msg-endojs-endo-but-for-bots-pr1348-gauntlet-fix-4-26a9fdc12cba
notice_count: 1
first_seen: 2026-09-29T03:29:09Z
last_seen: 2026-09-29T03:29:11Z
sent_at: 2026-09-29T03:29:11Z
---
endojs/endo-but-for-bots#1348 (draft, gauntlet round 4): the panel's two remaining must-fix items need your decision; a fixer can't settle them.

1. Issue endojs/endo-but-for-bots#731 parks the JSON agent-tools wrappers in favor of code mode. This PR adds a new public `@endo/agentry/workspace-agent` built on them. Do you lift that parking for this slice (and we record it in designs/daemon-agent-tools.md and on endojs/endo-but-for-bots#731), or should the PR stay draft?
2. The ledger says `Disposition: deliverable`, but it defers Phase 2 (2c) and Phase 4 (daemon grants reaching lal/fae end to end). Should it be reclassified as a slice or probe that stays draft, or should the Phase 4 consumer come into scope?

Fix round 4 (head 09fb9e313b) applied the mechanical should-fix items. Until you decide, the next panel will flag 1 and 2 again.
