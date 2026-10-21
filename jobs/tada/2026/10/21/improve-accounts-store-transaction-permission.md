I added a test that checks the deployed policy against every request the account store sends. I did not add `dynamodb:TransactWriteItems`, because AWS has no IAM action by that name. The change is pushed to PR #200 (`kriscendobot/minion.town`, branch `feat/beta-settings-simplify`) as commit `144535eb`.

**Why the job's premise was wrong.** The `TransactWriteItems` call only exists on PR #200's branch, not on `main`. AWS's transaction IAM docs (https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/transaction-apis-iam.html) say each item in a transaction is authorized by its underlying action (`PutItem`, `UpdateItem`, `DeleteItem` or `ConditionCheckItem`). The repo's billing store already relies on this. `bondGuest` makes two `Update`s, and the policy already allows them through its `UpdateItem` grant, which is limited to named attributes. Every attribute they touch is on that list, so recovery bonds were never blocked. Granting `TransactWriteItems` would have done nothing.

**What changed:**
- **New `test/accounts-store-iam.test.ts`:**
  - It reads the policy from `deploy-accounts-store.sh`, runs every store method against a fake client, and works out the permission each command needs. That includes splitting a transaction into its per-item actions. It then checks each one against the policy.
  - It fails if the store gains a method the test doesn't run, if the adapter uses a command the test doesn't know, or if the policy uses a policy condition the test can't evaluate. So a new store operation can't ship without its permission being checked.
  - It rejects `dynamodb:Transact*` actions in the policy, since they aren't real.
  - It checks that the app is still denied: role or status changes (including inside a transaction), `DeleteItem`, `Scan`, and `Query` on the main table.
- **`deploy/aws/scripts/deploy-accounts-store.sh`:** a comment only, explaining why the transaction needs no extra grant and pointing to the test. The policy itself is unchanged.

**Verification:**
- The new test and the existing `test/accounts-dynamodb-bonds.test.ts` pass, and `npm run typecheck` is clean.
- Removing `guest_bonds_closed` from the policy makes the new test fail on `bondGuest`, as it should; I then restored the script.
- In the full suite, 1476 tests pass and 1 fails: `test/git-remote/capability.test.ts > projectPartition > propagates a git failure…`. That test doesn't touch either changed file, but I didn't check whether it also fails without my commit.

**Follow-ups:**
- `unbondGuest` asks DynamoDB to return the whole updated row (`ReturnValues: "ALL_NEW"`). The policy doesn't limit this, so it is allowed now. If anyone tightens the policy the way AWS recommends for attribute-limited grants, that call will break; the new test would catch it.
- The header comment in `src/auth/stores/dynamodb.ts` still describes the app's permissions as "GetItem + PutItem only", which is out of date.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-accounts-store-transaction-permission.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1253695 cached reads)
- Output: 15794 tokens
- Cost: $1.2452670000000001
- Wall-clock: 342s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
