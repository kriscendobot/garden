from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T02:44:15Z
doom_base: improve-gauntlet-notices-to-pr-20261106
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T02:44:15Z
last_seen: 2026-11-06T02:44:15Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-gauntlet-notices-to-pr-20261106; it stays HELD until a human promotes it
(promote-plan.sh improve-gauntlet-notices-to-pr-20261106) or removes it, so nothing is lost.
Original job base: improve-gauntlet-notices-to-pr-20261106

--- original job body ---
---
posted_at: 2026-11-06T02:03:01Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
tier: mentor
dispatch: automatic
---
Maintainer directive (kriskowal, liaison muster 2026-11-06): gauntlet HALTED and REVIEW-BUDGET-REACHED notices should go to the applicable PR, and skip the maintainer inbox from now on.

In scripts/jobs/gauntlet.sh, every `gauntlet_notify` call site for the halted and review-budget-reached terminal states (search `gauntlet_notify`; the review-budget one is near `REVIEW-BUDGET-REACHED`) currently sends the must-fix block and `gauntlet_resume_hint` only to the maintainer inbox. Move that content into the terminal PR receipt (`gauntlet_terminal_receipt`) so the PR comment carries the unaddressed must-fix block, the severity note, and the exact resume command; then remove the maintainer-inbox send for those two states. Keep the log line. Keep any notice that is NOT about a single PR (for example a gauntlet that cannot name its PR) going to the maintainer inbox, since there is no PR to receive it. Update the gauntlet tests under scripts/jobs/test/ to assert the receipt content and the absence of a maintainer message, run them, and push to main2 directly per the garden's no-PR convention. Do not change panel or fix behavior.
