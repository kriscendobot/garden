from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-29T21:43:10Z
poison_base: finbot-pr5-panel-20260729-195004
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-29T21:43:10Z
last_seen: 2026-07-29T21:43:10Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/finbot-pr5-panel-20260729-195004; it stays HELD until a human promotes it
(promote-plan.sh finbot-pr5-panel-20260729-195004) or removes it, so nothing is lost.
Original job base: finbot-pr5-panel-20260729-195004

--- original job body ---
role: builder

# Run the required merge-governance panel for kriscendobot/finbot PR #5

PR: https://github.com/kriscendobot/finbot/pull/5 (DRAFT)
Head branch: `feat/observe-inference-dispatch` @ `57e397c9558ed0468f75fca0a25e5724aa02dae5`.
Base: `main` @ `877fa76769b4ff538916ac21afcac747409dc542` (`origin/main` is this base).
CI: green (`test` pass). Mergeable.

Increment: "inference-driven OBSERVE stage dispatch". The prior panel run produced
must-fix findings; the branch now includes the fixes that bind the observe tool to
trusted inputs and require those inputs. The three earlier panel jobs are poisoned
and parked after fleet churn, so do not revive them. This is the fresh, current-head
merge-governance gate.

## Do

1. Get an isolated project worktree for the PR head:
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/observe-inference-dispatch`
2. Run the scripted code panel against `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 5 origin/main`. Require non-empty
   formal verdicts from every seat. Do not treat an absent or empty seat block as a
   pass; re-run that seat.
3. On must-fix, run the fixer loop on the PR head until the panel passes, keeping
   the tree green.
4. On a passing panel, leave the PR DRAFT and do not merge or un-draft it. Post
   `finbot-pr5-fable-signoff` with `role: orchestrator` and `model: claude-fable-5`,
   including the panel outcome and PR URL. The Fable orchestrator owns sign-off and
   any merge it directs.

Per merge governance (2026-07-22), finbot lands only after both a passing panel and
Fable-orchestrator sign-off. Never self-merge.
