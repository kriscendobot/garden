from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-28T01:56:53Z
doom_base: dependabotany-recheck-endo-but-for-bots-20260928-012250
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-28T01:56:53Z
last_seen: 2026-09-28T01:56:53Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/dependabotany-recheck-endo-but-for-bots-20260928-012250; it stays HELD until a human promotes it
(promote-plan.sh dependabotany-recheck-endo-but-for-bots-20260928-012250) or removes it, so nothing is lost.
Original job base: dependabotany-recheck-endo-but-for-bots-20260928-012250

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Wear `roles/botanist/AGENT.md` and re-evaluate every due Dependabot embargo row for project `endo-but-for-bots` / repo `endojs/endo-but-for-bots`, executing each now-due verdict on this bot-owned repository. Recover the cumulative ledger with `grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'`; re-fetch live PR/base state and do not rely on stale rows.
