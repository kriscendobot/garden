from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-28T18:43:06Z
doom_base: endojs-endo-but-for-bots-pr1038-fix-20260828
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-28T18:43:06Z
last_seen: 2026-08-28T18:43:06Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1038-fix-20260828; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr1038-fix-20260828) or removes it.
Original job base: endojs-endo-but-for-bots-pr1038-fix-20260828

--- original job body ---
---
role: fixer
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Revalidate endojs/endo-but-for-bots PR #1038 after post-approval head movement

The conductor backstop found that the current head 41cd489f30cc587e5a2d8296dfc81955da744ff3 was pushed after kriskowal approved 470c5957c5f668b9814f58bd86d45829dd748360. The originating conduct job explicitly requires approval on the exact head and directs a fixer/shepherd dispatch on regression.

Inspect the post-approval delta (currently the fixup commit), verify it is coherent and checks remain green, and leave the branch ready for a fresh maintainer approval. Do not merge. Bot repo only: endojs/endo-but-for-bots.

PR: https://github.com/endojs/endo-but-for-bots/pull/1038
