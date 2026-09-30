The design is done. It's in draft PR https://github.com/kriscendobot/minion.town/pull/144, which the earlier attempt opened before it was reaped. This run didn't redo anything. I checked the PR against the job spec, and `ensure-pr.sh --find-only` adopted it (no duplicate was opened) and recorded it on `work/design-minion-town-guest-coupons`.

**What's in the PR** (head `design/guest-coupons` at `c172dc6d06`, base `main-7fb38ed`, draft):
- It adds `designs/guest-coupons.md` (372 lines) and a 2-line cross-link in `designs/invitation-only-guest-onboarding.md`.
- **Coupon:** an ordinary daemon `eval` formula over a coupon-issuer caplet run by the root host. `redeem()` creates exactly one guest. A conditional write to a ledger is the moment the coupon is claimed, and naming the guest deterministically means a crash mid-redeem still ends at the same guest.
- **Pool:** the operator sets a capacity that can be raised. Available = capacity − outstanding − redeemed. Expired or revoked coupons go back to the pool.
- **Air-drop:** `root-ctl coupons airdrop` sends each guest a coupon book (a directory of coupons) in a message. If the pool is short, coupons go out round-robin.
- **Invitation carries a coupon:** a new `coupon=` field in the minion.town invitation link fragment. This part is minion.town only and needs no daemon change.
- **Newcomer path:** when `GUEST_ADMISSION=coupon`, the bootstrap's `redeemCoupon` replaces the open `createGuest`. Accepters on another federated instance, with a Familiar, or with their own pet daemon ignore the coupon, and it expires back to the pool.
- **Daemon support:** only one piece needs it. An optional hook against endo `llm` would let `endo://` invitation links carry a coupon (`InvitationFormula.enclosures`, `&enc.coupon=`). It is a later phase.
- The doc also has an ownership map, rejected alternatives, a test plan, and six open questions for the maintainer, each with a recommendation (§ 11). They are:
  - binding a coupon to its invitation;
  - where the ledger lives;
  - the default expiry and air-drop size;
  - when to switch admission to coupon-only;
  - who gets an air-drop;
  - when to build the daemon hook.

**Follow-ups:** the six open questions need maintainer answers on the PR. Building the daemon hook in endojs/endo-but-for-bots is deferred until someone needs coupons in `endo://` links.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-guest-coupons.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 64 tokens (2240463 cached reads)
- Output: 24536 tokens
- Cost: $1.9922446000000003
- Wall-clock: 301s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
