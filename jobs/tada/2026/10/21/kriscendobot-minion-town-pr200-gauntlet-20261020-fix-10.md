Fix round 10 for kriscendobot/minion.town PR #200 (gauntlet `kriscendobot-minion-town-pr200-gauntlet-20261020`) is pushed and CI is green.

**Input:** No pre-pass block was attached, so I worked from the latest panel verdict on the PR, the "Must-fix before merge" review from 2026-10-21 04:25Z.

**Pushed** to `feat/beta-settings-simplify` with `safe-push-pr-head.sh`, moving the head from `144535eb` to `28d151e9`:
- **`00a71fcd` fix(web):**
  - **Late-bind deletion race** (assessor, wire-watcher, breaker #1): `bindGuest` now refuses a temporary `web-open-*` bind once the guest's deletion marker is stored. It checks again after the name lands and removes it if the guest has stopped being openable. The marker is stored on the daemon, so the check also holds between separate service processes.
  - **Crash leftovers:** a retried deletion that finds the guest already deleted now removes any temporary names left on it. Each new daemon connection also removes temporary names whose guest can no longer be opened.
  - **Reconnect** (breaker #2): the socket service forgets a connection once it closes or fails to open, so a retry reconnects instead of reusing dead references.
  - **Deletion success** (integrator, breaker #3): `DELETE /api/guest` now returns 204 only after the recovery bonds are removed and the final audit line is written. Otherwise it records the failure and returns 409 `deletion-pending`, so the browser keeps its credential and the next DELETE finishes the job.
  - **Tests:** renamed `g` to `guestAuditTag` (stylist) and removed two comments that only restated the code (pruner). Added tests for each of the fixes above, plus a repeated deletion of a guest with no bonds (corner-prober).
- **`28d151e9` docs:**
  - The deletion contract in `closed-beta-waitlist.md` and `DEPLOYMENT.md` now matches the new behavior.
  - The sign-out JSDoc in `settings.js` now says the identity provider's session ends only as deployed.
  - The landing role panel is gone from § 6 and the phase table of `account-creation-open-signup.md` (archivist).
  - The IAM comment in `deploy-accounts-store.sh` now cites the AWS guide.

**Declined, with reasons given in the PR comment:**
- **IAM `dynamodb:TransactWriteItems`** (4 jurors): IAM has no such action. DynamoDB checks each item in a transaction against its underlying action, here `UpdateItem`, and the existing `accounts-store-iam` test already checks every request against the policy.
- **Harden CapTP arguments** (warden): `@endo/captp` already hardens every argument it sends (`serialize(harden([prop, args]))`).
- **Remove the deletion tombstone** (decomplector): out of scope for a fix round, since the tombstone is what makes a repeated DELETE succeed. Left for maintainer direction.
- **Purist items:** `@endo/sha256` is not published, and using `Fail` from `@endo/errors` would add a dependency and change the lockfile.
- **Changeset** (releaser): this repo has no Changesets setup.
- **Splitting commit `7667e3c9`** (packager): that would rewrite published history.

**Follow-ups:** the duality-auditor renames, the engine-realist concern that the bond ledger grows without bound, and the fast-checker property test are not done.

**Verification:** locally, the 9 test files under `test/web` plus `test/accounts-store-iam` passed (103 tests) and `tsc --noEmit` was clean. In the full local suite, 2 `test/git-remote` tests failed; this change doesn't touch that code. I posted the SHA-anchored completion summary for the scribe: https://github.com/kriscendobot/minion.town/pull/200#issuecomment-6308244750. `ci-wait-merge.sh` returned rc 0: both checks passed (test and clip frame browser gate). The runs were queued for about 40 minutes behind other branches first. My first CI watcher was killed by the tool time limit, so a second detached one gave the result.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4381293 cached reads)
- Output: 31941 tokens
- Cost: $2.4959185999999995
- Wall-clock: 3957s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
