Round 7 fixes for kriscendobot/minion.town#218 are pushed and CI is green: all 4 checks passed, and `ci-wait-merge.sh` returned rc 0. I fixed two findings fully and one in part. I declined the most-repeated finding (grant `dynamodb:TransactWriteItems`) with evidence, and left two larger changes for the maintainer.

The head moved from `311c1f1` to `c93ffd7` through `safe-push-pr-head.sh`, which fast-forwarded it without rewriting history. Locally, the three affected test files pass (47 tests) and `tsc --noEmit` is clean. I posted a follow-up summary comment on the PR explaining what was fixed and why the rest was declined.

**Fixed:**
- **integrator:** `deploy-accounts-store.sh` now checks `LEGACY_BOND_WRITERS` before it makes any AWS call. Before, the table and IAM steps ran first. The test now requires that an unset, empty or unknown value makes no AWS call at all.
- **stylist:** `probeId` is renamed to `probeIdentifier` in `check-accounts-store-transaction.mjs`, its `.d.mts` file and the rollout test.
- **archivist (part):** the design doc now explains how AWS checks permissions for a transaction, with a link to the AWS IAM reference. It also points to the billing store, which already uses the same pattern in production.

**Declined, with reasons on the PR:**
- **Grant `dynamodb:TransactWriteItems` (migrator, locksmith, engine-realist, archivist):** IAM has no such action. AWS checks each item in a transaction against the normal per-item actions, which this policy already grants. The billing store's transaction already runs in production without that grant. `deploy-app.sh` also tests the real permission under the instance role before promotion, so a missing grant would block the deploy rather than fail silently.
- **releaser (add a changeset):** this repo has no `.changeset/` setup. The migration steps are already in `DEPLOYMENT.md`.
- **pruner (remove a teaser line):** the line it cites doesn't exist in the design doc. The phrase only appears in `DEPLOYMENT.md`, where it heads the actual procedure.

**Left for the maintainer:**
- **decomplector:** it says to remove the whole guest bond ledger because nothing in production deletes bonds yet. That is a scope decision, not a fix-loop item.
- **purist:** it wants the store split into separate runtime objects for normal use and bond administration. This is a should-fix and would be its own refactor.

If panel-8 raises the `TransactWriteItems` grant again, it is the same false finding. The maintainer may need to settle it or override it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1087896 cached reads)
- Output: 8011 tokens
- Cost: $0.9452471999999998
- Wall-clock: 1075s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
