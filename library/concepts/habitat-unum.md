---
id: habitat-unum
aliases: ["unum pattern", "una", "unums", "world object", "Chip Morningstar unum", "Habitat unum", "presence (unum)", "unum presence", "division of labor presence", "containership problem", "Elko server framework", "Electric Communities unum", "Reply Neighbor Broadcast Point", "Neighbor message"]
topics: [distributed-objects, capability-theory]
---

# habitat-unum

The **unum** (Latin, "a single thing"; plural *una* or *unums*) is Chip
Morningstar's design pattern for a **distributed object that is itself a
distributed entity** — a single logical world-object (the canonical teacup on a
table in a virtual room) whose objective identity is distinct from the OOP objects
that realize it on each machine. The per-machine portion of a unum is a
**presence**; the teacup unum has a server presence and a client presence on each
participant's machine. Presences are factored **not** as master/replica but by a
**division of labor**: each is authoritative about different aspects of the unum's
existence and typically holds **private state it does not share** (the client owns
display/rendering; the server owns the shared physics and may hold secrets). This
asymmetric-information structure is precisely why the pattern does **not** reduce to
data replication. Roots trace to Lucasfilm *Habitat* (1985–86) and carry forward
into the **Elko** server framework and **Electric Communities**' capability-secure
distributed world; the "vat" execution-environment term and the E-language ocap
lineage grew from this same MMO/actor tradition that underlies Endo's presences and
remotables. Not to be confused with jcorbin's unrelated `unum` task-queue monorepo
(concept keyword `unum`).

Addressing a unum needs two components — the unum's identity plus an indicator of
*which presence(s)* — because a message actually goes to a presence (an object),
not to the unum (not an object). Over vats connected by message channels, external
presences correspond one-to-one with channels, yielding a client/server asymmetry
(a client has one channel and never distinguishes "message the unum" from "message
the server"). Server-side coordination uses four codified messaging patterns:
**Reply** (to the sender), **Neighbor** (to all clients *except* the sender),
**Broadcast** (to all clients), and **Point** (to one explicitly chosen client,
used rarely). Unum protocols are **behavioral, not data-based** — "about as
anti-REST as you can be" — because a parameterized operation compresses far better
than transmitting all resulting state (Habitat ran over 300/1200-baud links). Open
directions: alternate divisions of labor (peer-to-peer consensus), **per-unum**
client/server authority (Electric Communities), and the **containership problem**
(modelling one unum containing another across machines).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [habitat-chronicles--unum-pattern--overview](../sections/habitat-chronicles--unum-pattern--overview.md) | Names the unum pattern and its Habitat/Elko/Electric-Communities lineage. |
| [habitat-chronicles--unum-pattern--unum-vs-object-two-planes](../sections/habitat-chronicles--unum-pattern--unum-vs-object-two-planes.md) | The teacup: a world entity on a different plane from the objects realizing it; why the term unum. |
| [habitat-chronicles--unum-pattern--presences-and-division-of-labor](../sections/habitat-chronicles--unum-pattern--presences-and-division-of-labor.md) | Presence = per-machine portion; division of labor, not master/replica; private/asymmetric state. |
| [habitat-chronicles--unum-pattern--addressing-presences-vats-and-channels](../sections/habitat-chronicles--unum-pattern--addressing-presences-vats-and-channels.md) | Two-part addressing (unum-id + presence), vats and channels, client/server asymmetry. |
| [habitat-chronicles--unum-pattern--four-messaging-patterns](../sections/habitat-chronicles--unum-pattern--four-messaging-patterns.md) | Reply, Neighbor, Broadcast, Point; Reply+Neighbor and Broadcast idioms; the fanout primitive. |
| [habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest](../sections/habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest.md) | Behavioral (not data) protocols; knowledge-based compression; about as anti-REST as you can be. |
| [habitat-chronicles--unum-pattern--other-divisions-of-labor-and-containership](../sections/habitat-chronicles--unum-pattern--other-divisions-of-labor-and-containership.md) | Peer-to-peer, per-unum authority (Electric Communities), the containership problem. |
| [what-are-capabilities/distributed-services-and-engineering](../sections/habitat-chronicles--what-are-capabilities--distributed-services-and-engineering-practices.md) | The **Electric Communities** decentralized-virtual-world project (dwarf-axe-in-the-stock-exchange) that produced the **E language** — the ocap lineage the unum pattern shares. |

## See also

- [[vat-and-compartment]] — the "vat" execution-environment term the unum pattern uses for a machine's object host; the E/Endo lineage adopted it directly.
- [[granovetter-operator]] — the reference-passing primitive of the capability lineage (Electric Communities → E → Endo) that grew alongside this distributed-object work.
- [[object-capability]] — the security model the Electric Communities descendants of Habitat built, adding capability discipline to the distributed-object substrate.

## Common confusions

- **"A unum is just a distributed object (one object on some remote machine)."** No — that is the *ordinary* meaning of "distributed object," and coining "unum" exists precisely to avoid it. A unum is an object that is *itself a distributed entity*, spread across machines as presences; the ordinary distributed object is one whole object sitting at one remote address.
- **"The server presence is the real unum; clients are cached copies."** This is the master/replica reading the pattern explicitly rejects. Presences embody a *division of labor*, not a copy hierarchy; each presence is authoritative over different aspects and holds private state the others must not see.
- **"The unum pattern is a data-replication scheme."** No — it is deliberately *anti*-replication and anti-REST: its message interfaces are about *behavior* (what the unum does), not about synchronizing data, because behavioral protocols compress far better and because replication cannot cleanly withhold information from some participants.
- **"This unum is the same as the library's `unum` source."** No — the library's `sources/unum.md` is jcorbin's unrelated task-queue automation monorepo. This concept is Chip Morningstar's Habitat distributed-object pattern; they share only the word.
