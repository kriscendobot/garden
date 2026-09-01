from_host: endolin-garden2-5bcdff64
from: deadline-nudge
sent_at: 2026-09-01T19:02:00Z
kind: deadline-nudge
claim_attempt: 5d31735bbeb83ce8
deadline_at: 2026-09-01T19:11:52Z
remaining_seconds: 592
attempt_billable_tokens: unknown
job_billable_tokens_spent: unknown
job_output_tokens_spent: unknown
job_token_budget: 100000
job_token_budget_source: role-default
job_token_budget_epoch: lifetime
job_token_budget_remaining: unknown
campaign: none
campaign_budget_tokens: none
campaign_spend_tokens: none
campaign_budget_remaining: none
quota_window_status: ok
provider_quota_limit: none
provider_quota_resets_at: none
quota_window_spend_tokens: 16795601
quota_window_budget_tokens: 385000000
quota_window_remaining_tokens: 368204399
quota_window_seconds: 604800
quota_window_reevaluate_at: 2026-09-05T04:00:00Z
---
Deadline nudge: about 10 minutes remain in this attempt. Wrap up now. Use the budget fields above to choose: continue only if the remaining unit fits; post a parked successor with `post-plan.sh --budget-hold` for quota refresh, `post-plan.sh --go-ahead` for maintainer authorization, or `post-plan.sh --deferred` for priority parking. For one continuous, sequential unit, commit and push safe progress, post one successor with `post-job.sh <successor-base>` and an appropriate `handler-timeout:`, and do not fan it out across agents; then declare the evidenced handoff. For separable stages, park children with `post-plan.sh --orchestrated --orchestrated-by <orch>` and record them with `post-orchestration.sh`; use `--budget-tokens` to distribute a campaign cap. An unfinished deliverable must never claim clean completion. After the successor or orchestration is durably posted, report what is complete and what remains, then end with `<<<GARDEN-JOB-HANDED-OFF: <successor-base-or-orch>>>` immediately before the completion signal. That records `handed-off:` and `deliverable-complete: false`; without a durable named successor the handoff is rejected.
