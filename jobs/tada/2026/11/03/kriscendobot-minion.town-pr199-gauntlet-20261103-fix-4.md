FIX round 4 for PR #199 is finished: I applied all four panel must-fixes, pushed them to `feat/guest-coupons` (`989a9c58` → `9d4a6077`), and CI is green (`ci-wait-merge` rc 0).

**Must-fixes, from review 5750462857**

| Finding | Seat | Fix |
| --- | --- | --- |
| Guest credentials stored in plaintext in the ledger | locksmith | `holderId` and `guestId` are gone from the rows. `attachForHolder` now finds the inviter's root pet names through the daemon's `reverseIdentify`, and books already name recipients that way. A replayed redemption reads `coupon-<serial>-agent` without provisioning, so a deleted guest gets `coupon unavailable` and no replacement. |
| `GUEST_ADMISSION=coupon` still let new sign-ins create guests | locksmith | Under coupon admission, `/mcp` and the `/account` guest routes open only a guest that already exists (`closedToNewGuests`). Otherwise `/mcp` returns a tool error and the `/account` routes return 403. |
| Concurrent same-nonce redemption could orphan a guest | saboteur | The issuer now finishes each serial's redemption in a single flight, which the sweep shares. I removed the memory daemon's own single-flight so tests exercise the issuer's. |
| One departed recipient stopped an air-drop run | breaker | Delivery failures are now isolated per book: the failed book reports an `error`, stays pending, and a resume retries it. Losing the run lease still stops the run, and `coupon-airdrop` and `coupon-airdrop-resume` exit 1 on a partial run. |

**Where I departed from the panel's suggested fixes**
- **No fingerprint:** locksmith suggested storing a keyed fingerprint, but storing nothing removes the plaintext without giving `root-ctl` access to `GUEST_RECOVERY_KEY`.
- **`ACCOUNT_AUTOPROVISION` stays on:** turning it off at the flip would break recovery for newcomers, because `bond` requires an existing account row. The gate therefore applies to guest creation, not to account creation.

**Commits**
- `b2460e6b`: the admission gate.
- `9d4a6077`: the other three fixes. They overlap in `issuer.ts`, so they share one commit rather than one per concern.
- `deploy/aws/README.md`, the changeset and `designs/guest-coupons.md` are updated across these two commits.

**Verification**
- **CI:** both workflows passed on `9d4a6077`. That includes full vitest and the live-daemon coupons step against the pinned Endo daemon, which now covers concurrent redemption, replay after deletion, a departed recipient and closed admission. I confirmed those steps from the job's step list, because the logs weren't readable with this token.
- **Local:** typecheck and the 10 coupon and guest test files I ran passed (200 tests), before one small test addition covered by CI.
- **Local full suite:** it didn't finish, so I stopped it. It had failures in other test files, mostly shell-script deploy and Claude CLI tests, and this diff changes no scripts. I put these down to `/tmp` being noexec on this host, but only re-checked `test/endo-guest-lockdown.test.ts` and `test/deploy-guest-credential-gate.test.ts`, which passed with an executable temp directory.

**Follow-ups, not done**
- **Should-fix items left for panel-5 or the maintainer:**
  - Resume undoes `coupon-revoke-book`.
  - A ledger outage fails invitations.
  - `attachForHolder` still decides by identity, not by the capability held.
  - The `attachCoupon` option has no control in the UI.
  - A dead coupon blocks acceptance under open admission.
  - The guest-name pattern is looser than its sibling.
- **Departed recipients:** a resume still tops up a departed recipient's book, so those units stay reserved until they expire. There is still no verb to close such a book.
- **Other tokens in the ledger:** `couponId` and `attachedTo` remain in plaintext. `couponId` is a redemption token that the lookup needs. The panel flagged neither.
- **PR comment:** I didn't post a summary on the PR, since the job didn't ask for one and this review has no inline threads.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (5406884 cached reads)
- Output: 54396 tokens
- Cost: $3.7973528000000005
- Wall-clock: 2458s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
