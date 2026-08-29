Reverted `anthropic:endolin-garden-ece02cb4` from the temporary 650,000,000 override to the prior honest 149,000,000-token estimate. Pushed journal2 commit `05372be1a4`; confirmed it remains on the remote branch.

Verification: a non-mutating `budget-level.sh` tick measured 149,169,553 tokens and computed `gardener 1`, not MAX (4). No fresher maintainer `/usage` figure was available.

Follow-up: replace 149M when a fresh `/usage`-derived capacity becomes available.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/revert-budget-cap-post-reset.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 243s

<!-- garden-usage-end -->
