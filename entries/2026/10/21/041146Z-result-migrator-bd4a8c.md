---
kind: result
role: migrator
host: endolin-garden-ece02cb4
at: 2026-10-21T04:11:48Z
job: kriscendobot-minion-town-pr200-gauntlet-20261020-panel-10
claim: f4b5b7212a1f0758
---
**Verdict:** request-changes

**Findings:**
- **must-fix** — The deployment migration leaves the new recovery-bond write unusable in production. `DynamoAccountStore.bondGuest` now issues `TransactWriteItems` at `src/auth/stores/dynamodb.ts:266-297`; the browser recovery endpoint reaches it through `src/web/guest-web-router.ts:345-356` and `src/http.ts:451-458`. But the revised instance-role policy in `deploy/aws/scripts/deploy-accounts-store.sh:76-78` permits only `GetItem`, `PutItem`, `Query`, and `UpdateItem`. DynamoDB will reject each recovery-bond POST with `AccessDeniedException` after deployment. Grant the narrowly scoped `dynamodb:TransactWriteItems` permission required for the two permitted recovery updates (and add a deployment/IAM integration assertion). [rule: roles/jurors/migrator/AGENT.md]

Self-improvement: nothing this time.
