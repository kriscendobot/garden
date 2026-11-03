**FIX round 3 for minion.town PR #199: the one blocking finding is fixed and pushed, and CI is green.**

- **Blocking finding (`spell-out-identifiers`):** this was a false positive. The flagged `DynamoDB` is the AWS product name, in the `USAGE` help text in `src/endo/root-ctl.ts`. The probe scans line by line, so it read that line of a multi-line template literal as code.
    - **Fix:** I reworded the line to "work the AWS ledger table COUPON_TABLE". Spelling it out as `DynamoDatabase` would be wrong. A `spell-out-exempt` marker would turn the check off for the whole file, including the `err` spellings an earlier round fixed.
    - **Commit:** `989a9c58`, pushed to `feat/guest-coupons` with `safe-push-pr-head.sh` in advance mode (`d6c2009d` → `989a9c58`). It changes help text only.
- **Advisory (pruner, `deploy/aws/scripts/deploy-coupon-store.sh:5`):** I kept the comment. It records something the code doesn't show: creating the table doesn't change admission until `COUPON_STORE=dynamodb` is set.

**Verification**
- **Style pre-pass:** the read-only probes against `main-c5c3504` exit 0, with only the pruner advisory left. The `main-c5c3504` ref was my local tracking ref, so panel-4's pinned pair still needs its own run.
- **Tests:** `test/endo-root.test.ts` passes (13/13). I didn't run the full suite locally.
- **CI:** `ci-wait-merge.sh` returned rc 0, with 2 of 2 runs passing on `989a9c58`. This host's bot token can't read `statusCheckRollup`, so that result comes from the Actions runs API and doesn't cover commit statuses or non-Actions checks.

**Follow-up (not done here):** the probe doesn't track template-literal state across lines, so prose inside multi-line templates can fire false positives. Fixing that, or exempting product names like `DynamoDB`, would be a separate garden job.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (363464 cached reads)
- Output: 4824 tokens
- Cost: $0.6483008
- Wall-clock: 559s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
