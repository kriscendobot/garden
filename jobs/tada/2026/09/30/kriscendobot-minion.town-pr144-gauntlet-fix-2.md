Fix round 2 is pushed to kriscendobot/minion.town PR #144 and CI is green: all 3 checks passed, and `ci-wait-merge.sh` returned 0.

The panel posted its round-2 verdict as a comment, because GitHub won't let the bot request changes on its own PR. I made one follow-up commit to `designs/guest-coupons.md` (`8de865b`, on top of `d81a2fe`) and pushed it to `design/guest-coupons` with `safe-push-pr-head.sh --mode advance`.

**Must-fix items**
- **Decomplector (the issuer had more authority than § 3 allows):** the design now has two separate actors.
  - The **issuer** caplet holds only the ledger and a `provisioner` that can provision guests.
  - A named **root driver** is the minion.town service's connection to the root host. It does everything that touches root names: binding coupon formulas, building and sending books, and removing names. It calls the issuer through an `admin` facet (`reserve`, `revoke`, `sweep`, `setCapacity`).
  - The § 2 table, issue steps, air-drop steps and sweep text in §§ 3–4, and the § 8 ownership map now name one owner per effect.
- **Skeptic (opening the link spent a coupon):** in the "no guest, coupon present" branch, the shell now shows a **Create a guest with this coupon** button. It draws the nonce and calls `redeemCoupon` only after the click, which keeps onboarding § 3.2's rule that opening a link does nothing. The same applies to a coupon link without an invitation. The sequence diagram and the § 10 shell test are updated.
- **Copyeditor:** the word after the Mandate colon is now capitalized ("An invitation…").

**Should-fix and comment items also addressed**
- **Issue replay:** a crash between writing the ledger row and binding the name now has an owner. The root driver checks with `has` before binding, and every sweep binds unnamed `issued` rows. Until then, `redeemCoupon` and the air-drop treat the coupon as unavailable. A test covers this.
- **Sweep:** it now runs in a named layer: a service timer drives it through the root driver, which calls `E(admin).sweep()`.
- **Book identity:** air-drop books are keyed on a run id (`<runId>-<guest>`) rather than the calendar day, and there is a new `coupon-airdrop-resume <run-id>` verb. A test checks that two same-day runs produce two books. Resending a book that was already sent is now called out as harmless.
- **Redeemed-member revocation:** severing a coupon-created guest now moves its coupon to a new `severed` state, decrements `redeemed`, and returns the unit, so `capacity` limits live guests rather than lifetime signups.
- **Operator surface:**
  - `coupon-issue` records a book, so a hand-issued batch can be revoked as a unit.
  - Both minting verbs print the serials they mint.
  - New `coupon-list <book-id>` shows each serial with its status and expiry.
  - The revoke verbs now report how many coupons they revoked and skipped.
- **`redeemCoupon`** returns the same `GuestWebState` envelope as `createGuest`.
- **Builder pointer:** the design now says the `POST /api/guest` REST route in `src/web/guest-web-router.ts` must also be gated.
- **Garbage-collection claim:** removed the unsourced statement that removing a name makes the formula collectible.
- **Wording and paths:**
  - Source paths are now relative links.
  - Added short explanations of "Familiar", "root account/root host" and "binding" where they first appear.
  - Reworded two unclear sentences the copyeditor flagged.

**Not changed:**
- The `packages/daemon/src/types.d.ts` path stays as it is, because that file is in the endo repository, not this one.
- The `§` symbol stays; the pedant rated it a matter of taste.
- The novice's suggestion to move the "Grounded against" pointer earlier was handled with inline explanations instead.

The gauntlet driver will post panel round 3 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr144-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (820358 cached reads)
- Output: 13603 tokens
- Cost: $1.0537636000000001
- Wall-clock: 438s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
