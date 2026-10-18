Fix round 2 for kriscendobot/minion.town PR #199 is finished. CI is green on head `41b506f` and I pushed nothing new, because an earlier attempt had already pushed every must-fix item.

The round-2 panel reviewed commit `4c239f9`, but the PR head had moved to `41b506f` when I claimed the job. The four commits after `4c239f9` (73f8278, 9936dc9, ba87842, 41b506f) already cover all three must-fix items and several should-fix items:

- **assessor (must-fix):** `isConditionFailure` in `src/coupons/dynamodb.ts` now treats a `TransactionCanceledException` as a lost condition check only when one of its `CancellationReasons` is `ConditionalCheckFailed`. A `TransactionConflict` or throttling cancel is rethrown, and a test covers the `TransactionConflict` case. The status changes now also condition on the whole row (should-fix 2).
- **archivist (must-fix):** the `COUPON_STORE` row in `deploy/aws/README.md` now reads "`off` mounts no coupon issuer or sweep, and `POST /api/guest/coupon` answers 404". The `couponStore` comment in `src/config.ts` says the same.
- **corner-prober (must-fix-loop):** an empty recipient list is refused in both `root-ctl.ts` and `issuer.airdrop`, and duplicate names are removed. Commit 41b506f also leaves a short air-drop book pending so a resume can top it up (assessor should-fix 3).

**Checks:**
- **Tests:** the two coupon suites pass locally (`test/coupon-ledger-dynamodb.test.ts` and `test/web/guest-coupons-http.test.ts`, 30 tests).
- **Typecheck:** `tsc --noEmit` reports no errors.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0. The bot token can't read the PR's check summary, so the script fell back to the Actions runs API, which showed 1 run with 0 failures. Commit statuses and checks from outside GitHub Actions can't be seen this way.

**Follow-up:** the driver re-posts panel-3 against `41b506f`. These should-fix items from the round-2 panel are not part of this stage and still need a decision:
- the locksmith's identity-keyed coupon spending
- the saboteur's swallowed `localStorage` error in `guest.js` and its unlocated corrupt-row parse error
- the corner-prober's added boundary tests

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 150 tokens (6608471 cached reads)
- Output: 32200 tokens
- Cost: $3.408574300000001
- Wall-clock: 7937s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
