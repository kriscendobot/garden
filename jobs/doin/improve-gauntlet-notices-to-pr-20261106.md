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

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-06T02:03:26Z
