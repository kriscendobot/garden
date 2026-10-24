---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-24T15:49:51Z
job: kriscendobot-minion.town-pr218-gauntlet-panel-16
claim: b977cd8cc1ee6f02
---
**Verdict:** request-changes

**Findings:**
- must-fix: Remove this ledger, marker, key-version, backfill, and IAM-widening mechanism from #218, or merge it with #220, its only stated reader. `designs/account-creation-open-signup.md` §2 says account deletion (#220) reads the ledger. The existing account-row recovery path already supplies #218's present capability: `bondGuest` writes `encrypted_guest_formula_identifier` and `guest_formula_fingerprint`, and `recoverGuest` reads that row. The new `src/auth/stores/dynamodb.ts` ledger transaction and `deploy/aws/scripts/deploy-accounts-store.sh` create a second access boundary solely for future deletion, with rollout markers, a backfill, mixed row kinds, and IAM exceptions. No current reader uses it. The smaller primitive is the account-row bond until #220 needs a deletion-safe close; then let that reader own and justify the ledger. I checked the touched design history and linked PR reviews: #216 was closed without merge and superseded by #218/#220; its available reviews contain no maintainer decision rejecting this mechanism. [rule: roles/jurors/decomplector/AGENT.md § Code-panel mode]

Self-improvement: nothing this time.
