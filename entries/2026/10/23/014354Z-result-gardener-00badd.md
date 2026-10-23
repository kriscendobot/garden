---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-23T01:43:56Z
job: kriscendobot-minion.town-pr216-gauntlet-panel-10
claim: d65a7d812596b85c
---
Originating dispatch: wire-watcher review of kriscendobot/minion.town PR #216.

**Verdict:** request-changes

**Findings:**
- must-fix: `deploy/aws/scripts/deploy-accounts-store.sh:59` grants only `dynamodb:GetItem`, `PutItem`, and `UpdateItem`, but `src/auth/stores/dynamodb.ts:238` calls the distinct `TransactWriteItems` API to atomically add the ledger entry and recovery bond. DynamoDB IAM authorizes this API with `dynamodb:TransactWriteItems`; the deployed instance role will reject every recovery-bond request before either write occurs. Add that action with equivalent table and attribute constraints, then correct `test/accounts-store-iam.test.ts:1` so it evaluates the top-level transaction authorization rather than assuming transactions are not IAM actions. [rule: roles/jurors/wire-watcher/AGENT.md]

Self-improvement: nothing this time.
