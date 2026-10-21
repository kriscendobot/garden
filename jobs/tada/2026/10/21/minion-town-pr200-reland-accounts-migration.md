The accounts-store migration has run, and the re-land of #200 is open as kriscendobot/minion.town#213, ready for review and mergeable. Its CI had not been checked when I finished.

1. **Precondition met:** #211 merged at 2026-10-21T16:03Z (`a84d6d6`). Every `main` workflow at that commit passed: deploy, tests, clip frame browser gate and prod probe.
2. **Credentials:** this host runs as `arn:aws:iam::292378781985:user/garden-fleet`. That is the garden-fleet admin credential `DEPLOYMENT.md` names for `deploy-accounts-store.sh`, not CI's scoped deploy role. No maintainer message was needed.
3. **Migration:** I ran the #200 version of `deploy-accounts-store.sh` from the re-land branch. The table is `minion-town-accounts` in us-west-1, and the app role is `garden-ec2-ssm`. I then checked both results directly in AWS:
   - **Index:** `guest-formula-fingerprint` is `ACTIVE`, `KEYS_ONLY`. It took about 4 minutes to build.
   - **Query grant:** the policy `minion-accounts-store-readprovision` now has the statement `GuestBondsByFingerprint`, which allows `dynamodb:Query` on `…:table/minion-town-accounts/index/guest-formula-fingerprint`. The script also added `bonded_accounts` and `guest_bonds_closed` to the attributes the app may update.
   - **Effect on the live app:** none. The new policy grants everything the old one did, and the index only adds, so the reverted app now serving is unaffected.
4. **Re-land PR:** it reverts the #211 revert commit (`87cebebf`), giving head `c511a23f` on branch `reland/pr200-settings`. The resulting tree is identical to #200's merge `f6fe2b5`. The body states the migration ran and quotes the evidence above.
   - I opened it with `ensure-pr.sh`, which required a frozen base, so I pushed `main-a84d6d6` (the current `main` tip) and based the PR on it.
   - The proxy screen is meant to merge it once delegation is active again and validate the deploy.

**Note for #210 (last-active time):** it also needs `deploy-accounts-store.sh` re-run before its deploy. I did not touch #210.

## Manual gauntlet handoff

The completion guard found https://github.com/kriscendobot/minion.town/pull/213 ready without gauntlet coverage. A deduplicated review-docket decision was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr200-reland-accounts-migration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (617090 cached reads)
- Output: 4166 tokens
- Cost: $0.637722
- Wall-clock: 617s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
