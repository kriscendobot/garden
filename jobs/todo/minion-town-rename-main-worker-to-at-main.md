---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
kriscendobot/minion.town creates a worker pet name literally called "MAIN"
(bare, no `@`) when evaluating guest-side source — found at
`src/endo/gateway/daemon-site-registry.ts:285`, `evaluateRegister`:
`guest.evaluate("MAIN", source, ["guest", "sites"], [guestPetName,
sitesPetName])`. This is inconsistent with every other well-known name in
the guest's directory (`@agent`, `@host`, `@mail`, `@nets`, `@planes`,
`@self`), which all follow the `@`-prefix convention. Grep the rest of
`src/` for any other bare-string worker-name literals (`"MAIN"` or
similar ad hoc names) while you're in there.

**Fix:**
1. Rename the literal to `@main` at this call site (and any other place a
   worker pet name gets minted during guest provisioning/use).
2. Make `@main` **indelible**: `guest_remove` (and any other path that can
   delete a guest pet name) must refuse to remove `@main`. There is no
   existing protection at the daemon level for `@`-prefixed well-known
   names (checked `packages/daemon/src/guest.js` on `endo-but-for-bots` @
   `llm` — `remove` has no such guard), so this protection needs to live
   in minion.town's own tool layer. Use judgment on whether this
   protection should extend to the other well-known `@`-names too, or
   stay scoped to `@main` as asked — state your reasoning either way.

**Existing guests** (including the garden's own, confirmed via
`guest_list` — mine shows a bare `MAIN` today) already hold the old bare
`MAIN` worker. Decide whether to migrate/rename it in place, leave it as
inert legacy cruft once `@main` takes over going forward, or provide a
one-time cleanup path — say which and why in the completion report.
