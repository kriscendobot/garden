from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-27T20:37:25Z
doom_base: reconcile-hardened-url-shim-status
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-27T20:37:25Z
last_seen: 2026-09-27T20:37:25Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/reconcile-hardened-url-shim-status; it stays HELD until a human promotes it
(promote-plan.sh reconcile-hardened-url-shim-status) or removes it, so nothing is lost.
Original job base: reconcile-hardened-url-shim-status

--- original job body ---
---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Reconcile the M2 `hardened-url-shim` design record for `endojs/endo-but-for-bots` with upstream PR #3332, which merged, and update its journal-plan status and evidence so it no longer schedules duplicate implementation work.
