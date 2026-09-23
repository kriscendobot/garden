from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-29T10:43:07Z
poison_base: endojs-endo-but-for-bots-pr723-conduct
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-29T10:43:07Z
last_seen: 2026-07-29T10:43:07Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr723-conduct; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr723-conduct) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr723-conduct

--- original job body ---
---
role: conductor
---

Merge endojs/endo-but-for-bots PR #723 after its current maintainer approval is present. The PR is already undrafted; do not change that state. Review feedback 4803487425 was addressed at b746656b538933e381e5de62f532a62ed671dc96, and all checks were green at dispatch. Use the conductor procedure to verify current head, CI, and approval, then merge.
