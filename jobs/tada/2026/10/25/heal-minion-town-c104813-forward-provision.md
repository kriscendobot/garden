I took the forward route and it worked. Production now runs `c104813` (the guest bond ledger app). All five steps are done, and none of them was forced or skipped.

**Before step 1**
- **Unversioned bonds:** I set `UNVERSIONED_BONDS_KEY=current` because the version history shows the key was never rotated. `minion/guest-recovery-key` has a single version, created 2026-09-25, never changed since, with rotation off.
- **Live app permissions:** step 1 replaces the app role's access policy (`garden-ec2-ssm` / `minion-accounts-store-readprovision`). That role already had a policy left over from an earlier version of the ledger work, which allowed `bonded_accounts`, `guest_bonds_closed` and `TransactWriteItems`. Neither the app serving at the time (`27f70ed`) nor `c104813` uses those names in its code. The old app's only write sets `encrypted_guest_formula_identifier` and `guest_formula_fingerprint`, and the new policy still allows both, so swapping it didn't affect the app that was serving.

**Steps**
1. **Provisioning:** `LEGACY_BOND_WRITERS=active UNVERSIONED_BONDS_KEY=current deploy-accounts-store.sh` succeeded. It installed the policy and read it back to verify it, backfilled the one existing bond into the ledger, and recorded the `provisioned` marker.
2. **Deploy and probe:** I re-ran `deploy.yml` on `main` (`c104813`) by hand and it succeeded: https://github.com/kriscendobot/minion.town/actions/runs/40160877641. Then `prod-probe.yml` passed all 8 checks: https://github.com/kriscendobot/minion.town/actions/runs/40161258966.
3. **Retiring the old app:** once the new app was serving and the probe was green, I ran `LEGACY_BOND_WRITERS=retired`. It backfilled 1 bond again and recorded the `reconciled` and `legacy-writers-retired` markers. From here on, production can't roll back to an app older than the ledger; a bad release has to be fixed with a newer one.
4. **Closed #222** with a one-line comment saying it was superseded by the forward provisioning, naming the deploy run and the probe run.
5. **Screener:** I didn't resume it by hand. On its 04:26:41Z tick the proxy logged "delegation auto-resumed after deploy run 40160877641". `minion-town-screening.sh status` now returns `active`, with nothing left marked as healing.

**What changed:** only AWS state (the IAM policy, the ledger rows and the markers) and the closed PR. I made no code commits to the garden or to minion.town.

**Follow-ups:** none required. #224 (the fix so client services restart after a daemon redeploy) can now merge through the screener as planned. The PR #222 gauntlet is no longer needed, so I did not grant it extra rounds.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/heal-minion-town-c104813-forward-provision.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1127671 cached reads)
- Output: 5762 tokens
- Cost: $0.8672861999999999
- Wall-clock: 1101s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
