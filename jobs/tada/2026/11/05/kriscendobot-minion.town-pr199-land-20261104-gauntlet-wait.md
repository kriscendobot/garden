---
orchestration-failed: true
---
**#199's gauntlet stopped at `review-budget-reached`, so the panel never came back clean.** The merge should not proceed. I did not resume the gauntlet, add rounds or change anything on the PR, per the maintainer's stop-and-report instruction.

## Terminal state
- **Gauntlet:** `kriscendobot-minion.town-pr199-gauntlet-20261103` ended with 8 of 8 rounds spent, at a recorded cost of $16.38. The report is `jobs/tada/2026/11/05/kriscendobot-minion.town-pr199-gauntlet-20261103.md`, and its must-fix list says "unknown", so the list below comes from the review itself.
- **PR:** still open and in draft, on head `c3ce331ca292ad99b58ec5b7b91ff48fbd3a251f` and base `main-c5c3504`.
- **Last panel:** panel-8 reviewed `ef986ba6af958206f03ac16ffa5684f1850f9ec7` and ended must-fix in [review 5778806352](https://github.com/kriscendobot/minion.town/pull/199#pullrequestreview-5778806352). All nine seats voted request-changes.

## Must-fix list from panel-8
1. **A ledger read yields a guest's credential (locksmith, breaker, purist, wire-watcher).**
   - Rows store `leaseNonce` in plaintext beside `couponId`, and `complete` never clears it (`src/coupons/dynamodb.ts:62`).
   - Anyone who can read the table can replay that pair to `POST /api/guest/coupon` and get the guest's bearer credential, with no time limit.
   - This defeats the rule in `designs/guest-coupons.md` § 12 that the ledger stores no guest identifier.
2. **`coupon-airdrop all` skips every signed-in guest (breaker).** `GUEST_HANDLE` in `src/coupons/daemon-socket.ts` admits only `web-` and `coupon-` names, so `g-<digest>` guests get nothing while the run still reports success.
3. **The flip procedure can silently reopen admission (integrator).** `deploy/aws/README.md:62,68` says to set `GUEST_ADMISSION=coupon` and restart, but names no way to make that setting persist.

## Fix commits no panel has seen
Fix-8 pushed two commits after panel-8's head: `0edfbcd6` (docs) and `c3ce331c` (fixes and tests).

Its report says all three must-fix items are addressed:
- **Item 1:** rows now hold only a digest of the nonce, and replay ends one day after redemption or when the sweep drops the name.
- **Item 2:** `all` now includes `g-<digest>` guests.
- **Item 3:** the README names the systemd drop-in, and `deploy-app.sh` fails the deploy if `/api/guest/admission` differs from what the unit renders.

I did not check those fixes against the code, and no panel has reviewed them.

**CI:** at `c3ce331c`, I confirmed both visible Actions runs passed: `test (typecheck + vitest)` and `clip frame browser gate`. The bot PAT can't read `statusCheckRollup`, so other checks weren't visible. Fix-8 says it did not confirm the daemon suite ran in CI, and that the `deploy-app.sh` check has only had a syntax check.

## Left open by fix-8; a later panel may raise these again
- **Closed admission (locksmith):** it is still a runtime gate over retained create authority, including the delete-then-provide race in `closedToNewGuests`.
- **Coupon attachment (locksmith):** coupons still attach by digest match rather than from a held coupon. § 12 records this as a phase 1 limitation.
- **Sweep cost (engine-realist):** the sweep scans all history on every tick, and terminal rows have no TTL or archive.
- **Attach reads (engine-realist):** `attachForHolder` still does one `GetItem` per delivered serial.
- **Overlapping binds (saboteur, engine-realist):** `bindCoupon` can still overlap across processes in a narrow window.
- **Readable `couponId`:** an `issued` row's `couponId` can still be redeemed, so a ledger read can spend a pool unit, though it can't yield an existing guest's credential. § 12 leaves this for the maintainer to veto.

## Decision for the maintainer
The options are to grant another panel on `c3ce331c`, or to make the merge decision directly. Another panel would be:

`scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr199-gauntlet-20261103 panel --add-rounds N`

The campaign's `-merge` and `-deploy-verify` children are still parked in `jobs/plan/`, and I did not touch them.


## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `ef986ba6af958206f03ac16ffa5684f1850f9ec7`; this job presented `c3ce331ca292ad99b58ec5b7b91ff48fbd3a251f`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket accepted a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 10 on 1 host(s) (1 unmetered)
- Input: 156 tokens (4932197 cached reads)
- Output: 55309 tokens
- Cost: $8.9911784 (1 engagement(s) unpriced)
- Wall-clock: 6286s
- Model(s): claude-opus-5-5 ×9

<!-- garden-usage-end -->
