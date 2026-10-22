# Fix round 1 for kriscendobot/minion.town PR #216: must-fix applied, CI green

I fixed the one must-fix item from the panel review (review 5608479543, written by the assessor seat). I pushed it to the PR head as follow-up commit `e4b699e3` (on `reland/pr200-settings-2`, advancing from `856dae44`). CI passed: 7 of 7 checks, 0 failed, and `ci-wait-merge.sh` returned rc 0.

**The bug:** `unbondGuest` in `src/auth/stores/dynamodb.ts` closed the guest-bond ledger using `UpdateItem` with `ReturnValues: "ALL_NEW"`. The deployed IAM policy in `deploy/aws/scripts/deploy-accounts-store.sh` only allows `UpdateItem` on six named attributes. `ALL_NEW` counts every attribute of the item as accessed, so the policy would refuse the close. Every account deletion would then end in `GuestDeletionPendingError` and never finish.

**What changed:**
- **The close:** it no longer asks for return values. The code then reads `bonded_accounts` with a strongly consistent `GetItem`, which the policy already allows. This read can't miss a bond, because `bondGuest` is refused once the ledger is closed. A comment in the code records why.
- **`test/accounts-store-iam.test.ts`:** the test's IAM model now treats `ALL_NEW`/`ALL_OLD` as accessing every attribute, which is the gap the assessor pointed out. A new test checks that the deployed policy allows the close without return values and refuses it with `ALL_NEW`. The bonded-row fake now answers the ledger `GetItem` instead of returning attributes from `UpdateItem`.
- **`test/accounts-dynamodb-bonds.test.ts`:** the fake table no longer returns attributes from `UpdateItem`, matching real DynamoDB when no return values are requested. The tests now check that the close has no `ReturnValues` and is followed by a ledger `GetItem`. The bad-ledger-entry and reserved-word tests were updated to match.
- **Local checks:** `vitest run test/accounts*` passed (36 of 36) and `npm run typecheck` was clean.

**Not done (left for later rounds or the maintainer):** none of these blocked the review.
- Should-fix items:
  - Assessor: also check `CancellationReasons[1]` in `bondGuest`.
  - Stylist: rename `sockPath`/`conn`/`tmp`.
  - Archivist: rewording in `DEPLOYMENT.md`.
- The pruner's summary-fix cuts to the design doc, `DEPLOYMENT.md` and the PR body.

The archivist's item would only become must-fix if the app had no startup refusal. The assessor confirmed it does: `src/http.ts` runs a startup probe in production.

I did not re-run the panel; the driver posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr216-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1454048 cached reads)
- Output: 8630 tokens
- Cost: $1.0372016
- Wall-clock: 3351s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
