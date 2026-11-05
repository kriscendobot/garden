**Fix round 7 for kriscendobot/minion.town PR #199 is done: the one blocking item is fixed, pushed, and CI is green (7 of 7 checks passed).**

- **Blocking failure (prefer-endo-primitives):** I added the standard exemption marker as the first line of `src/coupons/issuer.ts`: `// prefer-endo-primitives-exempt -- @endo/sha256 is not published on npm; …`. Five other modules in the repo already carry this marker for the same reason, so I didn't rewrite the code. The probe now passes, and `tsc --noEmit` reports no errors.
- **Non-blocking warning (comment length):** I left the comment at the top of `deploy/aws/scripts/deploy-coupon-store.sh` as it is. It records something the code doesn't show: creating the table does not change admission until `COUPON_STORE=dynamodb` is set on `minion-mcp.service`.

**Push:** I committed `ef986ba6` as a review follow-up and pushed it to `feat/guest-coupons` with `safe-push-pr-head.sh --mode advance`, moving the head from `859e7eb8` to `ef986ba6`.

**Follow-ups:** none from this stage. I did not re-run the panel; the gauntlet driver posts panel round 8.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (602496 cached reads)
- Output: 3018 tokens
- Cost: $0.5798352
- Wall-clock: 390s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
