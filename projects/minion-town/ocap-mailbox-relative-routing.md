# minion-town: relative routing and the ocap-mailbox adapter

> Abstract: Mark Miller's [[relative-routing]] is the frame for the ocap-mailbox
> adapter's core choice — an email-backed synthetic guest is *one route* to a
> peer, an in-daemon OCapN-over-Noise session is *another*, and the adapter
> should short-circuit to the nearest reliable path when more than one exists,
> selecting a route rather than committing to a single absolute address. Grounds
> the design discussion on kriscendobot/minion.town PR #37.

## The mapping

The library concept page is
[library/concepts/relative-routing.md](../../library/concepts/relative-routing.md):
a peer is named by a durable identity (public key / VatID) while *how to reach
it* is carried separately as a set of candidate routes, and the connecting party
picks the nearest, shortest, most reliable one that works. The erights grounding
is CapTP's `acceptFrom(donorPath :String[], ...)` — a route list, not an
address — and the OCapN descendant is the peer locator's plural, ephemeral
**connection hints**.

For the ocap-mailbox adapter this reframes the two transports not as rival
designs to choose between once, but as **two hints on the same peer**:

- an **email-backed synthetic guest** — a store-and-forward route that always
  works (mail is the lowest-common-denominator, partition-tolerant path,
  matching E/Pluribus's original *store-and-forward* framing of inter-vat
  messaging); and
- an **in-daemon OCapN-over-Noise session** — a direct, low-latency route
  available only when both peers are reachable in-daemon.

Relative routing says: advertise both, and let the connecting party
short-circuit to the in-daemon Noise session when it is available, falling back
to the email mailbox when it is not — the same identity, two routes, nearest
reliable path chosen at connect time. It also says the adapter should *not* bake
one transport into the peer's identity: the mailbox address and the Noise
endpoint are ephemeral hints looked up fresh, not durable naming, so a peer that
gains or loses the in-daemon path keeps its identity unchanged.

## Provenance

Maintainer directive by @kriskowal on the design review of
<https://github.com/kriscendobot/minion.town/pull/37> (inline comment
<https://github.com/kriscendobot/minion.town/pull/37#discussion_r3781520494>):
*"Please post a scholar job to research Mark Miller's notion of 'relative
routing' because this concept applies equally well to CapTP connection hints and
choosing the nearest, shortest, and most reliable path to establish a session."*
Ingested via the `scholar-relative-routing-miller` job, 2026-08-14.

## See also

- [[relative-routing]] — the cross-cutting library concept this note applies.
- [[three-party-handoff]] — the introduction protocol underneath an ocap mailbox handing a peer to a third party.
