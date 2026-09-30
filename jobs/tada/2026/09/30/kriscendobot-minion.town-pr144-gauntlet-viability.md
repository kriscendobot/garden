**Viability report: kriscendobot/minion.town PR #144** ("design: guest-account coupons carried by invitations (growth governance)")

**Result: proceed.** The PR has not been superseded, and the reason for it still holds.

**PR facts:** open, not merged, still a draft. Head `design/guest-coupons` @ `c172dc6d`; base `main-7fb38ed` (frozen). Opened 2026-09-30T05:02Z by job `design-minion-town-guest-coupons`. It changes two files: it adds `designs/guest-coupons.md` and adds 2 lines to `designs/invitation-only-guest-onboarding.md`. It has no reviews or comments yet.

**Deciding question:** Does kriskowal's request in endojs/endo-but-for-bots#1116 (r4140186381) still stand with nothing else answering it: guest-account coupons carried by invitations, drawn from a growable, expiring root pool, and handed out by air-drop?

**Evidence:**
- **The request is still open.** kriskowal's review comment r4140186381 asks for exactly this follow-up: invitations carry a coupon formula id, a growable root pool, air-dropped coupon books, and expiry that returns coupons to the pool. The comment is still on #1116, which is itself still OPEN and unmerged.
- **Nothing newer covers it.** `main` has no coupon or admission design, and a PR search for "coupon" in kriscendobot/minion.town finds only #144.
- **Recent `main` history doesn't touch it.** Everything on `main` since 2026-09-30T00:00Z is npm-registry deploy work (#134/#135, `7fb38ed4`→`c54f5070`), unrelated to guest admission.
- **The nearest design supports it rather than replacing it.** `designs/siwe-invitation-pivot.md` (#80, 2026-09-28) moves admission onto the invitation-only axis and turns down open self-signup. That fits the coupon design, which replaces the open `createGuest` with coupon-gated `redeemCoupon`.
- **The PR is 2 hours old** and nothing has been committed that competes with it.

**Note for later stages:** the design has a non-empty open-questions section (§ 11, six questions, each with a recommendation). The maintainer will need to answer those in review; this doesn't affect viability.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr144-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (158067 cached reads)
- Output: 1686 tokens
- Cost: $0.37946940000000007
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
