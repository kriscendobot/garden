from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-27T23:33:07Z
doom_base: improve-auto-gauntlet-issue-ref
doom_signature: elapsed-constancy
notice_count: 1
first_seen: 2026-08-27T23:33:07Z
last_seen: 2026-08-27T23:33:07Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden-ece02cb4.
The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
Read the handler log for the fast failure cause. Raising the handler budget will not help.
The work is preserved at jobs/plan/improve-auto-gauntlet-issue-ref; it stays HELD until a human promotes it
(promote-plan.sh improve-auto-gauntlet-issue-ref) or removes it.
Original job base: improve-auto-gauntlet-issue-ref

--- original job body ---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/auto-gauntlet-handoff.sh
Treat a report reference that GitHub definitively says is not a pull request as an issue citation and skip gauntlet inspection. Two completed issue-driven jobs cited `kriscendobot/garden#58`, then failed on the same `PullRequest` GraphQL lookup and were unnecessarily requeued.
