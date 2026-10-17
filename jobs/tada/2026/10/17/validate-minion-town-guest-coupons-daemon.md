## Completion report: validate-minion-town-guest-coupons-daemon

The coupon daemon adapter now runs against the real pinned Endo daemon (`1706e632`), and that turned up one adapter bug, now fixed. The fix and the new test are pushed to the head of draft PR https://github.com/kriscendobot/minion.town/pull/199 (`feat/guest-coupons`) as follow-up commit `d9d481e`. CI is green on that commit, and the new daemon step actually ran its test in CI rather than skipping it.

**New test: `test/web/guest-coupons-daemon.test.ts`.** It follows the `ENDO_CHECKOUT` style of `test/web/guest-web-daemon.test.ts`. The coupon issuer runs over the production `makeSocketCouponDaemon` against a real daemon, and the router runs with `admission: "coupon"`. The test checks:
- **Issue:** the root issues a coupon. It is bound at `coupons/issued/<serial>` (via `evaluate` with a result path) and placed under `handouts/alice`.
- **Redeem:** `POST /api/guest/coupon` returns 201 and creates a `coupon-<serial>` guest whose identifier matches the root's `coupon-<serial>-agent`. Retrying with the same nonce returns the same guest; a different nonce gets 403.
- **Air-drop:** an `all` air-drop reaches both a `web-<uuid>` guest and the `coupon-<serial>` guest, and the root's outbox names are removed after sending.
- **Inbox:** the web guest's inbox shows the book. After the root has already removed its own name for the book, the guest can still adopt it, and `book/coupon-1` matches the coupon identifier the ledger recorded.
- **Second redemption:** the air-dropped coupon also redeems.
- **Sweep:** a day later, the sweep removes the names of the two redeemed coupons and leaves the still-issued coupon bound. The redeemed guest still works, and a second sweep does nothing.

**Bug found and fixed (`src/coupons/daemon-socket.ts`).** On the daemon, `has()` with a multi-part path throws "Unknown pet name" when an intermediate directory is missing, instead of returning false. That meant the very first `bindCoupon` failed, because `coupons/` didn't exist yet. `bindCoupon` and `removeCoupon` now check the path one level at a time. Nothing else in the adapter misbehaved.

**Other changes:**
- `src/coupons/wiring.ts`: I pulled `couponDaemonOverRoot(host)` out of `connectCouponIssuer`. The test uses it, so it exercises the same main-worker name detection (`@main` vs `MAIN`) as production.
- `.github/workflows/test.yml`: added a "Test live-daemon guest coupons acceptance" step that runs the new test in its own vitest process, like the other daemon tests.

**Local results:**
- Typecheck is clean, and the new test, `guest-coupons-http`, and `endo-pin-drift` pass.
- The full local suite had 1 failure out of 1197: `test/git-remote/capability.test.ts`, "propagates a git failure…". I didn't touch that area, and it passes in CI, so it looks specific to this host's git setup.

`GUEST_ADMISSION` was not changed anywhere; it stays default-off.

**Follow-ups:** none required. The PR stays draft and goes through its normal review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/validate-minion-town-guest-coupons-daemon.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3153602 cached reads)
- Output: 18317 tokens
- Cost: $1.8223884000000004
- Wall-clock: 2437s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
