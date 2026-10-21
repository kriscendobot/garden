---
kind: result
role: migrator
host: endolin-garden-ece02cb4
at: 2026-10-21T08:19:28Z
job: kriscendobot-minion.town-pr210-gauntlet-panel-3
claim: 1226be667cd0bf37
---
**Verdict:** request-changes

**Findings:**
- **Must-fix:** Existing production DynamoDB callers will receive `AccessDeniedException` for every activity write after CD deploys this head. `.github/workflows/deploy.yml:3-9` expressly excludes IAM provisioning, while the new `AgentActivityStampOnly` permission is applied only by `deploy/aws/scripts/deploy-accounts-store.sh:56-57`; no changed deployment documentation directs the operator to rerun that script before the application rollout. Document and require that ordered migration (or otherwise coordinate it), so the new durable behavior works for installed DynamoDB consumers. [proposed-rule: Any release that adds a runtime IAM permission must document and order its one-time IAM migration before automated application deployment.]

Self-improvement: nothing this time.
