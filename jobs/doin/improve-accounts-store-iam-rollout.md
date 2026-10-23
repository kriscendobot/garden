---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
deploy/aws/scripts/deploy-accounts-store.sh
`src/auth/stores/dynamodb.ts:249-280` now requires `TransactWriteItems`, but automatic deployment excludes this script (`DEPLOYMENT.md:1358-1368`), causing recovery bonds to fail with `AccessDeniedException`. Make the IAM migration enforced or explicitly ordered before application rollout, and verify the installed role includes the transaction permission.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-23T13:51:20Z
