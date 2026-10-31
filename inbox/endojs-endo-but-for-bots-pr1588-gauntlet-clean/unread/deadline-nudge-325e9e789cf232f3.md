from_host: endolin-garden-ece02cb4
from: deadline-nudge
sent_at: 2026-10-31T10:30:00Z
kind: deadline-nudge
claim_attempt: 325e9e789cf232f3
deadline_at: 2026-10-31T10:44:20Z
remaining_seconds: 860
attempt_billable_tokens: 0
job_billable_tokens_spent: 89853
job_output_tokens_spent: 11072
job_token_budget: 250000
job_token_budget_source: role-default
job_token_budget_epoch: lifetime
job_token_budget_remaining: 238928
campaign: none
campaign_budget_tokens: none
campaign_spend_tokens: none
campaign_budget_remaining: none
quota_window_status: ok
provider_quota_limit: none
provider_quota_resets_at: none
quota_window_spend_tokens: 5037435
quota_window_budget_tokens: 271000000
quota_window_remaining_tokens: 265962565
quota_window_seconds: 604800
quota_window_reevaluate_at: 2026-11-07T04:00:00Z
---
Deadline nudge: about 15 minutes remain in this attempt. Wrap up now. Use the budget fields above to choose: continue only if the remaining unit fits; post a parked successor with `post-plan.sh --budget-hold` for quota refresh, `post-plan.sh --go-ahead` for maintainer authorization, or `post-plan.sh --deferred` for priority parking. For one continuous, sequential unit, commit and push safe progress, post one successor with `post-job.sh <successor-base>` and an appropriate `handler-timeout:`, and do not fan it out across agents; then declare the evidenced handoff. For separable stages, park children with `post-plan.sh --orchestrated --orchestrated-by <orch>` and an explicit `--role`, `handler-budget-role:`, or `handler-timeout:`, then record them with `post-orchestration.sh`; use `--budget-tokens` to distribute a campaign cap. An unfinished deliverable must never claim clean completion. After the successor or orchestration is durably posted, report what is complete and what remains, then end with `<<<GARDEN-JOB-HANDED-OFF: <successor-base-or-orch>>>` immediately before the completion signal. That records `handed-off:` and `deliverable-complete: false`; without a durable named successor the handoff is rejected.
