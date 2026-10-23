Implemented and pushed commit `065ee74c` to `kriscendobot/minion.town` PR #218.

- Added installed-policy readback validation for `dynamodb:TransactWriteItems`.
- Added a pre-promotion transaction probe under the EC2 instance role, preventing rollout when IAM is ineffective.
- Documented the required IAM-before-application rollout order.
- Ran the production migration: installed grant confirmed, one bond ledger entry backfilled, provisioning marker recorded.
- Checks passed: build, typecheck, 31 focused tests, and all four GitHub Actions jobs.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-accounts-store-iam-rollout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1204s

<!-- garden-usage-end -->
