# Fix round 3: kriscendobot/minion.town PR #218

I fixed all three must-fix items from panel-3, but one is only partly closed: IAM still cannot make a guest close terminal. I pushed two follow-up commits to `split/pr216-ledger` (`f448a022..1b307e77`), and CI is green (`ci-wait-merge` rc 0). No pre-pass block was attached, so I worked from the latest panel verdict (review 5630552849).

## Must-fix items
- **Design doc contradicted the IAM policy (archivist 1, integrator 2).** `designs/account-creation-open-signup.md` § 2 now describes the actual grant: both attribute-restricted `UpdateItem` grants, the deny rules, and how the grants cover `bondGuest`'s transaction.
- **App could forge the operator's markers (locksmith 1).** Fully fixed.
  - The `provisioned` and `reconciled` markers moved to their own partition, `minion-town:guest-bond-markers`.
  - The app role is now denied `PutItem`, `UpdateItem` and `DeleteItem` there.
  - The policy check in `deploy-accounts-store.sh` refuses to continue unless that deny is installed.
- **The "terminal" close could be undone (locksmith 2).** Partly fixed:
  - The ledger `UpdateItem` grant is now limited to the ledger partition with `dynamodb:LeadingKeys`.
  - `PutItem` on the ledger partition is denied, so a ledger row can't be replaced to hide bonds.
  - The preflight probe now tests the scoped grant on a fresh ledger key.
  - **Still open:** IAM can't tell setting an attribute from removing it, so the app's credential can still reopen a closed guest or drop a ledger entry. The close is terminal only because the store's code never does that. The design doc now says so and points to moving the close behind the admin credential, which the guest-deletion PR (#220) would have to decide. Panel-4 may raise this again.

## Should-fix and comment items applied
- **`DEPLOYMENT.md`:**
  - The rollout steps moved under § Open self-signup, with a pointer from the CD bullet.
  - They now mention that the backfill removes recovery bonds for guests already deleted.
  - The probe is described correctly ("a conditional update … whose condition must fail").
  - Deletion is described as `closeGuestBonds`' contract rather than behavior this PR ships.
  - The uneven paragraph is rewrapped.
- **JSDoc in `accounts.ts`:** it now names `GuestBondAdmin.closeGuestBonds`, drops the note about a future PR, and says `unbondGuest` leaves the ledger entry in place.
- **Shared names:** I added `GUEST_BOND_MARKERS_ISS`, `GUEST_BOND_PROVISIONED_SUB` and `GUEST_BOND_RECONCILED_SUB`. A new test checks that `deploy-accounts-store.sh`, the preflight `.mjs` and `set-account-role.sh` use the same values. `set-account-role.sh list` filters out both partitions by prefix.
- **Repeated comments:** the script header, the four restatements of how transactions are authorized, the marker explanations, and the `deploy-app.sh` preflight comment are cut down to pointers.

## Not done
- **Regrouping commits into two (integrator 1):** not done, because this stage pushes review-feedback commits on top and doesn't rewrite history. A retcon job could do it.
- **Returning the store and the bond admin as separate objects (locksmith 3):** not done; it is a larger change that fits better with #220.

## Tests
- **Updated:** the IAM test, the rollout test, the backfill test and the bonds test.
- **New tests:**
  - Marker writes are denied.
  - Ledger attributes can't be written outside the ledger partition, and a ledger row can't be replaced.
  - The policy check rejects an installed policy without the scoped grant or the deny.
- The affected tests pass (71/71) and typecheck is clean.
- In the full local `npm test`, 2 tests failed, both in `test/git-remote/*`. This diff doesn't touch those files, and CI is green, so they look specific to this host.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3969074 cached reads)
- Output: 32195 tokens
- Cost: $2.4675148000000005
- Wall-clock: 1538s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
