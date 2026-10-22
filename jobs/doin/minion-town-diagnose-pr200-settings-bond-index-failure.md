---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Context: the reland of PR #200 (settings) via PR #213 was merged and then reverted in kriscendobot/minion.town as commit 0e644c0c, so main is now byte-identical to a84d6d6, the last build that deployed. Deploy run 39668538848 failed closed at startup. The production probe threw "guest bond index unavailable ...: ValidationException", the smoke check failed, and the deploy restored the previous artifact.
Task:
1. Find the root cause of the DynamoDB ValidationException on the guest bond index. Likely suspects are the new `src/auth/stores/dynamodb.ts` bond-index query, `deploy/aws/scripts/deploy-accounts-store.sh`, and the IAM or table and index schema in the accounts store. Compare the query shape against the real production table and index definitions. The AWS CLI is at ~/.local/bin.
2. Check whether a pre-deploy step needs to create the index or grant IAM before the code ships. `test/accounts-dynamodb-bonds.test.ts` and `test/accounts-store-iam.test.ts` were part of the reverted change.
3. Post findings as a comment on PR #213 or in a new issue. Then prepare a corrected re-land as a DRAFT PR, with a pre-deploy index and IAM migration if one is needed.
Do not re-merge the reverted change as-is. First check the journal and existing PRs for a diagnosis or re-land already in flight, and skip this job if one exists.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T00:40:24Z
