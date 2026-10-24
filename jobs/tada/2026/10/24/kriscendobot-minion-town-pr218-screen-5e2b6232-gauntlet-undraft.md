## Undraft stage: kriscendobot/minion.town #218 ("feat(accounts): add the guest bond ledger and backfill")

PR #218 is OPEN, not a draft, and its head is still `5e2b6232bc4dfd27083912167ed48cbaf06cb5af`, the commit the panel passed. Something had already marked it ready before this stage ran, so I did not run `gh pr ready`. A second metadata fetch confirmed `isDraft=false` at the same head.

**Advisory appellate review** (Sonnet `claude -p`; recorded only, it does not block the undraft). The review input was truncated at 150 KB, so the reviewer saw the diff only up to partway through `test/deploy-accounts-store-backfill.test.ts`. It found no data-loss path in the backfill. These points are worth a look:
- **Preflight file may be missing from the archive.** `deploy-app.sh` copies `accounts-store-iam-preflight.mjs` into the stage directory, but if the shared assembler's production member list doesn't include it, every deploy fails at preflight. That fails closed: the old app stays live. The new tests only grep the script text, so they wouldn't catch it.
- **The preflight checks less than a real bond write needs.** It exercises only the ledger `Update` grant. It doesn't cover ledger `DeleteItem`, the account-row `Update` (including the `ForAllValues` / `dynamodb:Attributes` condition), or the deny statements. The IAM test uses a homemade policy evaluator rather than `simulate-principal-policy`.
- **The IAM grants are broader than the stated invariant.**
  - `GuestRecoveryBondOnly` has no `LeadingKeys` condition, so the app can set the recovery attributes on rows outside the ledger partition.
  - The app may delete any ledger row. A compromised app could remove bond rows while the "reconciled" marker still says the ledger is complete, so #220 must not treat the ledger as tamper-evident.
- **Rollback depends on the operator.** Only `deploy-accounts-store.sh` honors the `legacy-writers-retired` marker. `deploy-app.sh` could still ship a pre-ledger artifact after step 3.
- **A failed secret read leaves deploys blocked.** The script deletes the `provisioned` and `reconciled` markers before it reads `GUEST_RECOVERY_KEY` from Secrets Manager. If that read fails, deploys stay blocked until someone reruns the script. Reading the secret first would avoid this.

Possible follow-ups, not posted: check that the assembler includes the preflight file, and make `deploy-app.sh` refuse pre-ledger artifacts once the retired marker exists.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr218-screen-5e2b6232-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (231384 cached reads)
- Output: 1987 tokens
- Cost: $0.4400408
- Wall-clock: 62s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
