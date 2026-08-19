from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T18:03:08Z
doom_base: dependabotany-recheck-endo-but-for-bots-20260819-170501
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-19T18:03:08Z
last_seen: 2026-08-19T18:03:08Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/dependabotany-recheck-endo-but-for-bots-20260819-170501; it stays HELD until a human promotes it
(promote-plan.sh dependabotany-recheck-endo-but-for-bots-20260819-170501) or removes it, so nothing is lost.
Original job base: dependabotany-recheck-endo-but-for-bots-20260819-170501

--- original job body ---
---
role: botanist
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Daily dependabotany backstop for endo-but-for-bots

Wear roles/botanist/AGENT.md. Recover the cumulative Dependabot ledger from journal message entries whose body contains both "# Dependabotany" and "project: endo-but-for-bots". Re-evaluate every due open row, including https://github.com/endojs/endo-but-for-bots/pull/923, against live base state, advisories, source maturity, and CI; execute terminal dispositions through the conductor spine.
