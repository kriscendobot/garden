---
kind: result
role: migrator
host: endolin-garden-ece02cb4
at: 2026-10-23T13:33:57Z
---
**Verdict:** request-changes

**Findings:**
- **Must-fix:** `src/http.ts:420-424` remains the production recovery-bond caller, but its unchanged call to `bondGuest` now reaches `TransactWriteItemsCommand` in `src/auth/stores/dynamodb.ts:249-280`. Installed roles have only the prior `UpdateItem` grant until an operator runs the changed `deploy/aws/scripts/deploy-accounts-store.sh:51-58`. The automatic merge deployment expressly excludes that provisioning script (`DEPLOYMENT.md:1358-1368`), so a normal deploy of this head makes every new recovery bond fail with `AccessDeniedException`. Add an enforced or explicitly ordered pre-deploy IAM migration (and a rollout check) before the application uses the transaction. [rule: DEPLOYMENT.md § Continuous deployment]

Self-improvement: nothing this time.
