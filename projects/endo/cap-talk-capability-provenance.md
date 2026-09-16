# cap-talk provenance for Endo's capability model

> Abstract: What the cap-talk mailing-list archive (founded 1998 by Jonathan Shapiro of EROS) says that bears directly on Endo's design and open questions. Endo is an object-capability platform; several of its load-bearing patterns — the caretaker/revocation model, the connectivity discipline, the refusal to designate authority by identity — were argued out on cap-talk years before they were formalized in the Miller papers Endo cites. This file flags the concrete connections so an Endo contributor can reach the primary sources from the project tree, not only from the library. Sources live in the library under [`../../library/sources/cap-talk-1998.md`](../../library/sources/cap-talk-1998.md) (first slice; more eras pending).

## Revocation: destroyable indirection is the caretaker

Shapiro's 1998 EROS revocation primitive — hand the holder a capability to a *destroyable indirection object* rather than to the target, so destroying the indirection rescinds access without disturbing any other reference — is the primary-source ancestor of the pattern Endo/Agoric call the **caretaker**, and of the library's [revocation-by-withdrawal](../../library/concepts/revocation-by-withdrawal.md) concept (removing a formula withdraws the recipe for constructing the capability). Charles Landau's companion point — a *rescinded key must return a message just like any other key* (revocation indistinguishable from a live-but-unhelpful object) — is a useful contrast for Endo: Endo/E instead make a broken reference a *distinguishable* terminal state a client can react to (`_whenBroken`). The tension (transparent revocation vs. reactable broken reference) is worth keeping in view when reasoning about Endo's disconnection and disincarnation semantics.

- [`../../library/sections/cap-talk-1998--capability-ids-and-indirection-revocation.md`](../../library/sections/cap-talk-1998--capability-ids-and-indirection-revocation.md)
- [`../../library/sections/cap-talk-1998--rescinded-keys.md`](../../library/sections/cap-talk-1998--rescinded-keys.md)

## The connectivity discipline

"You can only transmit a capability by invoking some other capability that you already have" (Shapiro, 1998) is the operational statement of *only connectivity begets connectivity* — the axiom Endo's whole reachability/retention story rests on, later formalized in *The Structure of Authority* (2004). The corollary that objects are *allocated, not created* (a space bank sells storage; the payer can reclaim it) is a direct antecedent of Endo's explicit-storage-accounting stance over transparent garbage collection, which matters for Endo's persistence and quota model.

- [`../../library/sections/cap-talk-1998--creating-and-granting-capabilities.md`](../../library/sections/cap-talk-1998--creating-and-granting-capabilities.md)

## Designation-not-identity, and the "what is a capability" hygiene

Endo's refusal to grant authority by ambient identity (no ambient authority; a reference *is* the authority) is exactly Shapiro's 1998 argument that a capability fuses designation and authority while an ACL must reconstruct "who is calling" and can be fooled. The archive's recurring *definitional* dispute — syscall-gating and POSIX "capabilities" are not object-capabilities — is a standing reminder for Endo docs and issue triage to keep the *object-capability* qualifier explicit when the word "capability" appears in a security claim.

- [`../../library/sections/cap-talk-1998--card-keys-are-capabilities.md`](../../library/sections/cap-talk-1998--card-keys-are-capabilities.md)
- [`../../library/sections/cap-talk-1998--acls-on-capabilities.md`](../../library/sections/cap-talk-1998--acls-on-capabilities.md)
- [`../../library/sections/cap-talk-1998--caos-capability-os-terminology.md`](../../library/sections/cap-talk-1998--caos-capability-os-terminology.md)

Scholar job `scholar-ingest-cap-talk` (2026-09-16), first-pass founding-era slice.
