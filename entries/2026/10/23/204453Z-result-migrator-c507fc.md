---
kind: result
role: migrator
host: endolin-garden-ece02cb4
at: 2026-10-23T20:44:56Z
job: kriscendobot-minion.town-pr218-gauntlet-panel-7
claim: 1b692d09f01e9c95
---
Originating dispatch: jury seat migrator, PR #218, kriscendobot/minion.town.

**Verdict:** request-changes

**Findings:**
- must-fix: `deploy/aws/scripts/deploy-accounts-store.sh:54` grants only item actions, but `src/auth/stores/dynamodb.ts:269` now sends `TransactWriteItemsCommand` and `deploy/aws/scripts/deploy-app.sh:252` makes that call a promotion gate. DynamoDB authorizes the API action `dynamodb:TransactWriteItems`; after the required policy rollout, the instance role lacks it, so the preflight receives `AccessDeniedException` rather than its expected conditional cancellation and every ledger-aware deployment aborts with the prior artifact live. This is a breaking operational migration for existing deployments. Grant the transaction action with the same table and condition constraints, and make `test/accounts-store-iam.test.ts` model the API authorization rather than asserting it does not exist. [proposed-rule: An AWS IAM rollout gate must grant every DynamoDB API action that its serving code invokes, and test the actual authorization request.]

Self-improvement: nothing this time.
