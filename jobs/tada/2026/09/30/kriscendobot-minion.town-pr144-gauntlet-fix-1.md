Fix round 1 for kriscendobot/minion.town#144 (`designs/guest-coupons.md`) is pushed, and CI is green.

I pushed one follow-up commit, `d81a2fe`, to `design/guest-coupons` with `safe-push-pr-head.sh --mode advance`, moving the head from `c172dc6`. `ci-wait-merge.sh --no-merge` then returned rc 0: 3 of 3 checks passed and none failed.

**The two must-fix items:**
- **Leaked units from abandoned redemptions (skeptic, and decomplector item 3):** capacity is now three stored counters on the capacity row: `capacity`, `reserved` and `redeemed`. They change in the same DynamoDB transaction as the coupon row. `reserved` counts every coupon still `issued` or `redeeming`, so a coupon mid-redemption always holds its unit. The sweep also handles `redeeming` rows whose lease is more than 15 minutes old: it finishes them into `redeemed` by provisioning the same named guest. It never puts them back to `issued`. Revoking a `redeeming` coupon is refused.
- **Second caller getting through (critic):** `redeem(nonce)` now takes a nonce chosen and stored by the caller, and the lease records it. A retry with the same nonce reaches the same guest. A different holder calling with another nonce is rejected, which now matches the "one guest, one rejection" test in § 10. The bootstrap call, the sequence diagram and local-storage persistence were updated to match.

**Should-fix and nit items also applied:**
- **Coupon books (decomplector):** the root builds a fresh directory under a temporary name, sends it, then removes its own name, so the guest is the only holder. Lineage and idempotency now live in a ledger book row with a `pending|sent` status. That also fixes skeptic's stranded-coupon problem when an air-drop fails partway.
- **Stored counters vs. computed `available` (decomplector item 2):** the stored counters are declared authoritative. The ownership map now lists the durable root pet names and the browser-held nonce.
- **`root-ctl` verbs (ergonomist):** flattened to the house grammar in `src/endo/root-ctl.ts`: `coupon-status`, `coupon-capacity`, `coupon-issue`, `coupon-airdrop`, `coupon-revoke` and `coupon-revoke-book`. `coupon-capacity` sets an absolute value and there is no additive verb. `coupon-status` output is split into labeled "Now" and "Last 30 days" groups.
- **Coupon with no invitation (critic item 2):** now stated as a deliberate widening of invitation-only onboarding, and tied to open question 1.
- **"Uses surfaces that already exist" claim (skeptic item 2):** § 2 now says phase 1 inherits the `guest.accept` blocker from onboarding § 3.2 rather than being shippable on its own.
- **Novice:** "lease" is defined in § 1 next to the diagram, there is a pointer to the § 6 flow, and the round-robin air-drop has a worked example.
- **Pedant and orthographer:** the `guest-native-invitations.md` reference is now a link, the backticks are gone from the link text in the onboarding amendment, and "cancelled" is now "canceled".
- **Tests (§ 10):** new cases for stale leases, the counter invariant, and air-drops that fail partway.

The cliché and British-spelling greps found nothing in the diff. The panel was not re-run; the driver posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr144-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1161931 cached reads)
- Output: 16272 tokens
- Cost: $1.1488901999999996
- Wall-clock: 528s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
