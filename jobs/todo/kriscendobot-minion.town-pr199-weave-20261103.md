---
posted_at: 2026-11-03T06:06:41Z
role: weaver
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Weave kriscendobot/minion.town#199 onto current main

PR: https://github.com/kriscendobot/minion.town/pull/199 (`feat/guest-coupons`, base `main-bda7739`, 246 commits behind `main`).
Why: kriskowal approved and asked to integrate and enable it (https://github.com/kriscendobot/minion.town/pull/199#pullrequestreview-5747577467), and a trial merge onto main c5c35044 conflicts, so the conductor would stall on `needs weave`.

Pin the merge base per roles/weaver/AGENT.md. A trial `git merge-tree` reports these conflicts:

- `deploy/aws/www/guest.html` and `deploy/aws/www/guest.js`: modified here, DELETED on main. Do not resurrect the deleted files. Find what replaced them and port the coupon redemption (the `#v=1&coupon=` fragment and the `POST /api/guest/coupon` call) there, so a newcomer can still redeem. This is the part that decides whether the feature works once enabled. If no surface can carry it without a design decision, escalate rather than guess.
- `src/config.ts`, `src/web/guest-web-router.ts`: content conflicts.

Keep the PR draft and keep the defaults `GUEST_ADMISSION=open`, `COUPON_STORE=off`. Run the coupon, config, and web suites locally.

**After the force-push and green CI, stage the re-review of the moved head:**

    scripts/jobs/post-gauntlet.sh kriscendobot-minion.town-pr199-gauntlet-20261103 https://github.com/kriscendobot/minion.town/pull/199

The merge job `kriscendobot-minion.town-pr199-conduct-20261103` is parked `blocked_on` that gauntlet, and the production flip `minion-town-coupon-admission-flip-20261103` is parked `blocked_on` the merge. If you cannot complete the weave, do not post the gauntlet: message the maintainer, so the chain visibly waits.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-03T07:13:04Z -->
