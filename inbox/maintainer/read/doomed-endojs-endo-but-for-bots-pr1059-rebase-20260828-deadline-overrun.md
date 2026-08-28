from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-28T14:43:07Z
doom_base: endojs-endo-but-for-bots-pr1059-rebase-20260828
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-28T14:43:07Z
last_seen: 2026-08-28T14:43:07Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1059-rebase-20260828; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr1059-rebase-20260828) or removes it.
Original job base: endojs-endo-but-for-bots-pr1059-rebase-20260828

--- original job body ---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
https://github.com/endojs/endo-but-for-bots/pull/1059 ("feat(ironhorse)!: snapshot store seam") is
CONFLICTING/DIRTY against `llm` following the maintainer merging
https://github.com/endojs/endo-but-for-bots/pull/1046 just now. Rebase
onto current `llm`, resolve conflicts, push, and confirm CI.
