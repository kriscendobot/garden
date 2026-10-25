## Fix round 5: kriscendobot/minion.town PR #222

I applied the panel-5 fixes in one commit and pushed it. CI finished green on the new head (rc 0, 4 of 4 checks passed, none failed).

The job carried no pre-pass block, so the fixes came from the latest panel verdict (review 5640670794, "Must-fix before merge"). It had one must-fix and several should-fixes from the archivist and pruner jurors.

**What changed:** commit `5011ac03` ("docs(accounts): state the store ceiling once, move ledger leftovers to the PR"). `safe-push-pr-head.sh` pushed it as a fast-forward from `9e7074fb`.

- **Must-fix (archivist 1):** `DEPLOYMENT.md` claimed two different ceilings for a compromised account store, daemon-guest admission and read. It now says read only (`resident` = `mcp/tools`, `mcp/minions:read`) and cites design § 3.
- **Restated IAM split (pruner 2):** `DEPLOYMENT.md` no longer spells out the app role's grants in its inventory entry or its IAM-split bullet. Both now point to `designs/account-creation-open-signup.md` § 2. That also removes the broken "§ The IAM split" link (archivist 4).
- **Incident notes (archivist 3, pruner 1):** I removed the "reverted guest bond ledger" bullet, the history plus the cleanup steps, from `DEPLOYMENT.md`. Its content now sits in the PR body under "Production leftovers from #218's branch". The `garden-heal` and `garden-job` markers in the body are unchanged.
- **`src/auth/stores/dynamodb.ts` (archivist 2, pruner 3):**
  - The header said this file is the only place under `src/` allowed an AWS SDK import. That's false: the billing and waitlist store adapters also load it lazily, and the header now says so.
  - I reworded its paraphrase of the portability rule so it no longer says adapters live under `src/auth/stores/`.
  - The paragraph restating the design's IAM split is now a one-line pointer.
- **`deploy/aws/scripts/deploy-accounts-store.sh` (pruner 2, 4):** the header's restatement of the split is now a pointer, and the two section banners are gone.
- **Design open question 3 (pruner 5):** the "Resolved" line is now just a pointer to `DEPLOYMENT.md` § Provider portability boundary.

**Checks:** `tsc --noEmit` is clean, the deploy script passes `bash -n`, and 10 local vitest files passed (135 tests: harness-gate plus the account and deploy tests).

**Follow-ups:**
- `DEPLOYMENT.md` § Provider portability boundary still names `src/auth/stores/dynamodb.ts` as "the one exception" to the no-AWS-SDK rule, which has the same inaccuracy as the header claim. It isn't part of this PR's diff, so I left it alone.
- The cleanup steps now in the PR body haven't been run against production; an operator with garden-fleet admin credentials still needs to do it.

I did not re-run the panel; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr222-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1144510 cached reads)
- Output: 7526 tokens
- Cost: $0.945022
- Wall-clock: 1059s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
