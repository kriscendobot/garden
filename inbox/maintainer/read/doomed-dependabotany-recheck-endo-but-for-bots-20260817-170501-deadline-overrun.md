from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-17T17:53:07Z
doom_base: dependabotany-recheck-endo-but-for-bots-20260817-170501
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-17T17:53:07Z
last_seen: 2026-08-17T17:53:07Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden2-5bcdff64.
The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/dependabotany-recheck-endo-but-for-bots-20260817-170501; it stays HELD until a human promotes it
(promote-plan.sh dependabotany-recheck-endo-but-for-bots-20260817-170501) or removes it.
Original job base: dependabotany-recheck-endo-but-for-bots-20260817-170501

--- original job body ---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Daily dependabotany backstop for endo-but-for-bots

Wear roles/botanist/AGENT.md. Recover the cumulative Dependabot ledger from journal message entries whose body contains both "# Dependabotany" and "project: endo-but-for-bots". Re-evaluate every due open row, including https://github.com/endojs/endo-but-for-bots/pull/923, against live base state, advisories, source maturity, and CI; execute terminal dispositions through the conductor spine.
