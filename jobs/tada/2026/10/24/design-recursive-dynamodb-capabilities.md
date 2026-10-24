Completed design `recursive-dynamodb-capabilities` in draft PR https://github.com/kriscendobot/minion.town/pull/221 at commit `7eca8b82`.

- Added the DynamoDB adapter/attenuation inventory, recursive restriction model, transaction/query/pagination/error contracts, credential boundary, revocation/restart/audit design, ownership map, least-authority tests, and guest-coupon migration.
- Kept the deliverable design-only; no implementation was added.
- Verified the PR targets frozen base `main-68c3960`, contains only the design file, and GitHub Actions run `40058575108` passed typecheck, Vitest, and acceptance checks.
- Routed a 15M-token estimate for effort `recursive-dynamodb-capabilities` to the accountant.

## Follow-ups

- `build-recursive-dynamodb-capabilities`: implement `@endo/exo-dynamodb` on the Endo bot fork.
- `build-minion-town-recursive-dynamodb-capabilities`: afterward, migrate the coupon ledger and confined issuer in a separate PR.

Self-improvement: reported that the budget-request skill references a missing `request-budget.sh`; also notified the scholar of the missing DynamoDB library index entry.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-recursive-dynamodb-capabilities.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 727s

<!-- garden-usage-end -->
