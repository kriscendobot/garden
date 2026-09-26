Inbox is empty. This job was a scholar-thread reply, not a code change — nothing to commit to main2.

## Completion report

**Job:** Dead-lettered message for `issue-kriskowal-garden-26` (that doer had already completed). Intent: fold dckc's new comment on kriskowal/garden issue #26 into the in-flight scholar consideration and reply on the thread.

**What the comment asked:** dckc corrected the scholar's claim (in [comment 4888954857](https://github.com/kriskowal/garden/issues/26#issuecomment-4888954857)) that sealing a purse yields "a balance-viewing reference without withdrawal authority." dckc's point: a sealed purse is fully **inert** — no methods at all, no balance viewing — unless handed to a holder of the matching **unsealer** (who then gets the *whole* purse, full authority). The right primitive for attenuated read access is a **facet** — by analogy to ERTP's `getDepositFacet()`, one would expose `getBalanceFacet()`.

**What I did:**
- Grounded the correction against the referenced source (`dckc/vattr97 .../escrow-ertp.ts`): confirmed `getSealedPurses` calls `sealers.A.seal(escrows.A)` and that `Sealer.seal` "turns an object into an inert token" — validating dckc's correction and pinpointing my prior conflation of *sealing* (rights-conserving opaque transport, all-or-nothing via unsealer) with *attenuation* (a narrowed facet).
- Posted a reply as the scholar ([comment 4892390711](https://github.com/kriskowal/garden/issues/26#issuecomment-4892390711), as kriscendobot — matching the thread): conceded the slip; restated the two primitives correctly; adopted `getBalanceFacet() → { getCurrentAmount }` as a read-through-to-OC view with zero mutation surface (fitting the earlier "OC is source of truth" correction); noted `getSealedPurses` still earns its keep for the *transport* role; and revised spike item 1 to a three-facet split (balance-view / deposit / full purse held by connector).

**Changed:** one issue comment on kriskowal/garden#26. No garden repo (main2) code changes — this is a design consideration; nothing was built or committed. The issue remains open (submitter dckc closes it).

**Follow-ups:** None required. I offered dckc the next slice (single-sided oracle-gated escrow sketch, or the read-through façade with the three-facet split) pending his choice.
