---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-23T14:11:19Z
job: improve-accounts-store-iam-rollout
claim: c2fc0c88b13ec595
---
Implemented and pushed commit 065ee74c980330e586914304a4fae020c57ea64a to https://github.com/kriscendobot/minion.town/pull/218.

- The accounts-store migration now reads the installed inline role policy back and refuses success unless the table-scoped dynamodb:TransactWriteItems grant is present.
- The app artifact now carries a condition-only transaction probe. deploy-app.sh runs it under the EC2 instance role before artifact promotion or service restart, so a missing or ineffective migration leaves the prior application live.
- DEPLOYMENT.md now makes the account-store IAM migration an explicit prerequisite to application rollout.
- Ran the production migration as garden-fleet: it verified the installed grant, backfilled 1 bond ledger entry, and wrote the provisioning marker. A separate get-role-policy query returned true for the table-scoped transaction grant.
- Verification: npm run typecheck passed; npm run build passed; 31 focused tests passed; GitHub Actions run 39965470393 passed changes, test, and both Claude harness jobs. A local all-suite run had 26 shared-host fixture/PATH failures, while its other 1,421 tests passed; the isolated CI suite passed.

No follow-ups.
Self-improvement: nothing this time.
