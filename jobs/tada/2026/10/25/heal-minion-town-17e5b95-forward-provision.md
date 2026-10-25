The forward heal worked. kriscendobot/minion.town `main` at 17e5b95 (#220) is deployed, the prod probe is green, #225 is closed, and the proxy resumed the delegation on its own.

**Cause.** #220's deploy check tries to write a `guest_bonds_closed` attribute on the ledger rows. The live `garden-ec2-ssm` policy (`minion-accounts-store-readprovision`) still had #218's version, which allowed neither that attribute nor `dynamodb:Query` on the ledger. #220's DEPLOYMENT.md says to re-run `deploy-accounts-store.sh` even when the ledger is already rolled out.

**Checks before the change.**
- The `provisioned`, `reconciled` and `legacy-writers-retired` markers were all present. That makes `LEGACY_BOND_WRITERS=retired` the only valid mode; the script refuses `active` on a reconciled store.
- `minion/guest-recovery-key` has a single version (2026-09-25) and rotation is off. That justifies `UNVERSIONED_BONDS_KEY=current`, as in the c104813 precedent.
- #220's policy only adds grants, all limited to the `minion-town-accounts` table, and keeps every grant the serving app uses.

**AWS changes.**
- I ran `LEGACY_BOND_WRITERS=retired UNVERSIONED_BONDS_KEY=current deploy/aws/scripts/deploy-accounts-store.sh` from the isolated 17e5b95 checkout as `garden-fleet`. It exited 0.
- The script read the installed policy back and verified it. I also diffed the policy before and after. The only changes:
  - `GuestBondLedgerOnly` now allows the `guest_bonds_closed` attribute.
  - `GuestBondLedgerRemove` became `GuestBondLedgerReadRemove` and added `dynamodb:Query`. It is still limited to the `minion-town:guest-bond-ledger` partition.
  - All Deny statements are unchanged.
- The backfill rewrote 1 bond and unbonded 0 rows. The `provisioned` and `reconciled` markers were recorded again.

**Runs.**
- `deploy.yml` on `main` (17e5b95) passed: https://github.com/kriscendobot/minion.town/actions/runs/40197391373. The account-store IAM probe passed this time.
- `prod-probe.yml` passed, both the `probe` and `report` jobs: https://github.com/kriscendobot/minion.town/actions/runs/40197867673

**PRs and delegation.**
- I closed https://github.com/kriscendobot/minion.town/pull/225 (the revert draft) with a one-line comment saying it is superseded and linking both runs.
- I did not resume the screener by hand. `minion-town-screening.sh status` now reads `active`, with `resumed_at` 2026-10-25T13:34:37Z.

**Follow-ups.** None needed. The `weave #225` fallback was not used. One leftover: a background loop I started to wait for the `active` status is still running. My check never matched the status output, so it will idle until the harness stops it; it changes nothing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/heal-minion-town-17e5b95-forward-provision.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1435553 cached reads)
- Output: 6318 tokens
- Cost: $1.0260946000000002
- Wall-clock: 1897s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
