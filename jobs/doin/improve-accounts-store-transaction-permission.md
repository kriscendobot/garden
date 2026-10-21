---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
deploy/aws/scripts/deploy-accounts-store.sh
deploy/aws/scripts/deploy-accounts-store.sh:76-78 omits `dynamodb:TransactWriteItems`, though `src/auth/stores/dynamodb.ts:266-297` uses it for recovery bonds. Grant the scoped action and add a deployment-policy assertion so future store operations cannot ship without their required IAM permission.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-21T04:24:44Z
