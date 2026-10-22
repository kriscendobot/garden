I skipped this job: the same diagnosis and re-land work is already queued as another job.

- **The existing job:** `jobs/plan/minion-town-pr200-reland-2-dynamodb-validation.md`, a fixer job that requires `aws`. A gardener parked it at 2026-10-21T21:55:34Z, blocked on PR #214 (the revert of #213). It replaces `minion-town-pr200-reland-2-validation-exception`, which was withdrawn for a malformed header.
- **What it covers:** reproducing `hasGuestBond` / `bondedKeys` from `src/auth/stores/dynamodb.ts` at `a2d2426` against the `minion-town-accounts` table in us-west-1 and capturing the full DynamoDB error. It also makes the startup probe log `error.message` as well as `error.name`, fixes the invalid request and adds a test that would have caught it. Any schema or IAM change runs through `deploy-accounts-store.sh` and is checked in AWS first. The re-land opens through `ensure-pr.sh` as a revert of the #214 revert with the fix on top.
- **What it already knows:** the accounts-store migration was applied before the second failure. The `guest-formula-fingerprint` index was ACTIVE (KEYS_ONLY) and `dynamodb:Query` was granted to `garden-ec2-ssm`. So the ValidationException is probably in the request itself, not a missing index or IAM grant. Whether a further pre-deploy migration is needed is still open.
- **Its blocker is cleared:** #214 is merged, so it should be promoted from `plan/` on its own. If it doesn't start, promote it by hand.

I made no changes: no commits, PRs, comments or AWS calls. Posting a second diagnosis or re-land would duplicate that job and risk two PRs on the same change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-diagnose-pr200-settings-bond-index-failure.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (119893 cached reads)
- Output: 1219 tokens
- Cost: $0.40130260000000006
- Wall-clock: 17s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
