Implemented and pushed to `main2`:

- Extended closed-PR receipts with evidence-gated outcomes: `roll-forward`, `productive-redirect`, `administrative-continuation`, or `unresolved`.
- Added total-cost and detailed MRE fields.
- Added audited historical base→PR overrides and regression coverage.
- Backfilled 36 receipts; all 59 archived receipts now use the current schema. All 22 terminal PRs with Qwen engagements are covered.
- Published `designs/qwen-pr-cost-analysis.md`: matched Qwen mean/median total cost was $255.74/$178.18 versus $427.87/$211.42 for other workers. MRE represented 99.7% and 99.8% of totals, respectively. The three-PR Qwen sample is too small and confounded for a ranking claim.
- Found no evidence-backed roll-forward Qwen failure; two attempts redirected productively, several were administrative continuations, and one remains unresolved.
- Sent the findings toward `qwen-mentor-tier-trial`; its inbox had already closed, so the message was durably dead-lettered for promotion.
- Verified `cost-by-pr-test.sh` (11/11), `receipt-watcher-test.sh` (8/8), classification rejection, shell syntax, and remote journal completeness.

Follow-up: the mentor trial should collect more clean primary-carrier cases and cap human sitting-days/comment volume, since raw token cost is immaterial.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/receipt-backfill-and-qwen-cost-analysis.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1880s

<!-- garden-usage-end -->
