---
role: builder
model: gpt-5.6-terra
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T05:46:23Z cleared=none -->

# HELD — stale, do not run as written

STALE HEAD: this panel targets kriscendobot/finbot#5 at head 468b774b, but the live head is c1427a66. A governance panel run against a stale head yields a verdict on code that is not under review — worse than no verdict. Re-issue the panel at the CURRENT head if it is still wanted.

Parked by the liaison 2026-08-01: promoted mechanically during the outage-recovery sweep without a freshness check against live PR state. Flagged by finbot-progress-20260801-090502.
NOTE: the body below still embeds the OLD Fable-pinned sign-off instruction (dispatch finbot-prN-fable-signoff, model claude-fable-5). Per the 2026-08-01 directive that pin is removed; a passing panel should dispatch a plain role: orchestrator sign-off at tier mentor with no model pin. Fix that before any re-issue.

---- original body ----
---
role: builder
model: gpt-5.6-terra
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-01T09:00:58Z cleared=none -->

---
role: builder
tier: minion
model-burned: minion
model: gpt-5.6-terra
fallback-tier: 
dispatch: automatic
---

# Run the required merge-governance panel for kriscendobot/finbot PR #5

PR: https://github.com/kriscendobot/finbot/pull/5 (DRAFT)
Head branch: `feat/observe-inference-dispatch` at `468b774b2f4e585d5baeb08708303175bc0c02a5`.
Base: `main` at `877fa76769b4ff538916ac21afcac747409dc542`.
CI: GitHub Actions `test` is green. The PR is mergeable.

This is a fresh gate job. The prior current-head panel job
`finbot-pr5-panel-20260729-195004` was poisoned after all seats returned empty
output, so do not revive it. PR #4 and PR #6 already await their own queued
Fable sign-offs. Do not duplicate either one.

The increment makes OBSERVE inference-driven while preserving the trusted input
boundary: the observer receives a frozen, required reading-window binding; it
can choose whether to observe but cannot select detector inputs; downstream code
uses the deterministic canonical recompute and refuses unreconciled output.

## Do

1. Get an isolated project worktree for the PR head:
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/observe-inference-dispatch`
2. Run the scripted code panel against `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 5 origin/main`. Require a non-empty,
   formal verdict from every seat. Do not treat missing or empty seat output as a
   pass; retry the affected seat.
3. On must-fix, run the fixer loop on the PR head until the panel passes, keeping
   the tree green.
4. On a passing panel, leave the PR draft and do not merge or un-draft it. Post
   `finbot-pr5-fable-signoff` with `role: orchestrator` and `model: claude-fable-5`,
   including the panel outcome and PR URL. The Fable orchestrator owns sign-off and
   any merge it directs.

Per merge governance (2026-07-22), this increment lands only after both a passing
panel and Fable-orchestrator sign-off. Never self-merge.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-06T05:47:40Z
