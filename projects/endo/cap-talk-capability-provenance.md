# cap-talk provenance for Endo's capability model

> Abstract: What the cap-talk mailing-list archive (founded 1998 by Jonathan Shapiro of EROS) says that bears directly on Endo's design and open questions. Endo is an object-capability platform; several of its load-bearing patterns, including caretaker revocation, connectivity discipline, distributed capability transport, durable retention, and refusal to designate authority by identity, were argued out on cap-talk years before they were formalized in the Miller papers Endo cites. This file flags the concrete connections so an Endo contributor can reach the primary sources from the project tree, not only from the library. Sources live under [`../../library/sources/cap-talk-1998.md`](../../library/sources/cap-talk-1998.md) and [`../../library/sources/cap-talk-1999.md`](../../library/sources/cap-talk-1999.md).

## Revocation: destroyable indirection is the caretaker

Shapiro's 1998 EROS revocation primitive hands the holder a capability to a *destroyable indirection object* rather than to the target, so destroying the indirection rescinds access without disturbing any other reference. This is the primary-source ancestor of the pattern Endo and Agoric call the **caretaker**, and of the library's [revocation-by-withdrawal](../../library/concepts/revocation-by-withdrawal.md) concept. Charles Landau's companion point says a *rescinded key must return a message just like any other key*. Endo and E instead make a broken reference a *distinguishable* terminal state a client can react to (`_whenBroken`). The tension between transparent revocation and reactable broken references matters for Endo's disconnection and disincarnation semantics.

- [`../../library/sections/cap-talk-1998--capability-ids-and-indirection-revocation.md`](../../library/sections/cap-talk-1998--capability-ids-and-indirection-revocation.md)
- [`../../library/sections/cap-talk-1998--rescinded-keys.md`](../../library/sections/cap-talk-1998--rescinded-keys.md)

## The connectivity discipline

"You can only transmit a capability by invoking some other capability that you already have" (Shapiro, 1998) is the operational statement of *only connectivity begets connectivity*, the axiom Endo's whole reachability and retention story rests on. The corollary that objects are *allocated, not created* (a space bank sells storage; the payer can reclaim it) is a direct antecedent of Endo's explicit-storage-accounting stance over transparent garbage collection.

- [`../../library/sections/cap-talk-1998--creating-and-granting-capabilities.md`](../../library/sections/cap-talk-1998--creating-and-granting-capabilities.md)

## Designation, not identity

Endo's refusal to grant authority by ambient identity is exactly Shapiro's argument that a capability fuses designation and authority while an ACL must reconstruct "who is calling" and can be fooled. The later proxy-attribution debate adds a limit to telemetry claims: an audit record can prove which reference was exercised, but not whether its named holder acted directly, delegated, proxied, or was confused.

- [`../../library/sections/cap-talk-1998--card-keys-are-capabilities.md`](../../library/sections/cap-talk-1998--card-keys-are-capabilities.md)
- [`../../library/sections/cap-talk-1998--acls-on-capabilities.md`](../../library/sections/cap-talk-1998--acls-on-capabilities.md)
- [`../../library/sections/cap-talk-1999--principal-attribution-proxies-and-confinement.md`](../../library/sections/cap-talk-1999--principal-attribution-proxies-and-confinement.md)

## Authentication produces a capability set

The April 1998 CGI thread gives Endo a practical gateway rule: authenticate at the protocol edge, then deliberately map the result to the smallest and weakest **bucket of capabilities** sufficient for the session. The bucket is the operational identity past the authenticator. Authentication does not justify ambient socket creation, file-system access, or a machine-wide user object.

- [`../../library/sections/cap-talk-1998--cgi-confinement-and-capability-buckets.md`](../../library/sections/cap-talk-1998--cgi-confinement-and-capability-buckets.md)

## Distributed references are more than RPC object identifiers

The October 1999 thread names the distinction Endo's CapTP must preserve. The tuple "object ID, method ID, arguments" only has capability meaning if possession authorizes invocation, an endpoint cannot forge designation of an arbitrary hidden object, reference identity survives transport, and introductions are mediated. Miller's closure connection gives the local half of the same model: a closure's captured state is its authority-bearing acquaintance set.

- [`../../library/sections/cap-talk-1999--distributed-capabilities-rpc-and-closures.md`](../../library/sections/cap-talk-1999--distributed-capabilities-rpc-and-closures.md)

## Retention, reclamation, and covert channels

Landau's shared-object puzzle shows why cross-peer retention needs explicit per-holder state and a cleanup signal when a holder disappears. Shapiro, Miller, and Frantz then expose a second-order hazard: returning storage when the last capability disappears can reveal that event through observable quota. Endo's formula retention graph should therefore treat retention changes as authority-sensitive state and avoid promising that local reclamation is information-free.

- [`../../library/sections/cap-talk-1999--shared-object-lifetime-reference-counting.md`](../../library/sections/cap-talk-1999--shared-object-lifetime-reference-counting.md)
- [`../../library/sections/cap-talk-1999--storage-gc-and-covert-channels.md`](../../library/sections/cap-talk-1999--storage-gc-and-covert-channels.md)

## Durable state is not transaction agreement

System-wide persistence can preserve a circular capability graph, but it does not eliminate lost commit acknowledgments, network failure, or check-then-update races. Endo's durable vats and formulas need application operations with explicit retry and idempotency semantics. Reconstructing the object graph after a restart answers "what survived," not "what did the remote caller learn before the failure."

- [`../../library/sections/cap-talk-1999--persistence-and-transaction-failure.md`](../../library/sections/cap-talk-1999--persistence-and-transaction-failure.md)

## Brands and generic makers

The 1999 Trusty Scheme exchange makes a subtle Endo API property explicit: the operation that creates sealer/unsealer or brand pairs may be generally available without weakening any generated pair. Authority comes from holding one of the matching references, not from exclusive access to the generic maker.

- [`../../library/sections/cap-talk-1999--rights-amplification-from-seals-and-equality.md`](../../library/sections/cap-talk-1999--rights-amplification-from-seals-and-equality.md)

Scholar jobs `scholar-ingest-cap-talk` and `scholar-ingest-cap-talk-1999` (2026-09-16), founding-era slices.
