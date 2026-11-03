Fix round 5 for PR #199 is pushed and CI is green, with the deterministic pre-pass failure resolved. CI was read through the Actions runs API because the bot token can't read the status rollup, so commit statuses and non-Actions check runs weren't visible.

**What changed**
- **Rename:** commit `3cb5b236` on `feat/guest-coupons` renames `err` to `error` in the two `catch` blocks of `src/endo/guest-service.ts` that the PR had added lines to (`withControl` and `facetFor`).
- **Left as is:** the other two `catch (err)` blocks in that file have no PR-added lines and the probe didn't flag them, so I didn't touch them.
- **Advisory comment (no change):** I kept the 3-line comment at `deploy/aws/scripts/deploy-coupon-store.sh:5`. It says the script is idempotent and host-side only, and that creating the table doesn't change admission until `COUPON_STORE=dynamodb` is set, which the adjacent code doesn't show.

**Checks**
- **Probes:** `pre-push-gates.sh --no-auto-fix --probes-only` against the pinned base `c5c35044` exits 0; only the non-blocking comment advisory remains.
- **Typecheck:** `tsc --noEmit` printed no errors.
- **Tests:** `test/endo-guest-lockdown.test.ts` passed (3 tests). `test/endo-guest-locator-federation.test.ts` and `test/web/guest-coupons-daemon.test.ts` were skipped in this environment (3 tests), so the guest-coupon daemon test did not exercise this change locally.
- **Push:** `safe-push-pr-head.sh` advanced the head from `9d4a6077` to `3cb5b236`, confirmed with `ls-remote`.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0, with 2 of 2 Actions runs finished and none failed.

**Follow-ups:** none from this stage; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (477071 cached reads)
- Output: 4750 tokens
- Cost: $0.6209262000000001
- Wall-clock: 696s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
