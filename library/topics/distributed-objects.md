# Topic: distributed-objects

> Abstract: Design patterns for objects that are *themselves distributed entities* — a single logical world-object with many machine-local representations kept coherent — as distinct from the ordinary sense of "distributed objects" (individual objects located at different network addresses). The keystone is Chip Morningstar's **unum pattern** from Lucasfilm *Habitat* and its descendants (Elko, Electric Communities): a **unum** is the world-level object; its per-machine portion is a **presence**; presences are factored not as master/replica but by a **division of labor**, each authoritative over different aspects and each holding private state, coordinated by a small fixed set of messaging patterns (Reply / Neighbor / Broadcast / Point) over **behavioral, anti-REST** protocols. This is the MMO/actor lineage behind the E-vat model and Endo's ocap presences/remotables: the "vat" term, per-unum authority, and the containership problem all prefigure capability-secure distributed-object systems. Distinct from [change-propagation](change-propagation.md) (which is about propagating deltas between replicas/observers) and [capability-theory](capability-theory.md) (the ocap security theory) — this topic is specifically the *object-model shape* of a logical object split across machines. Seeded 2026-07-11 by `scholar-ingest-source-habitat-chronicles`.

## Sections

| Section | Topics | Abstract |
|---------|--------|----------|
| [overview](../sections/habitat-chronicles--unum-pattern--overview.md) | distributed-objects | Morningstar names the unum — a distributed object that is itself a distributed entity — with roots in Lucasfilm Habitat, Elko, and Electric Communities. |
| [unum-vs-object-two-planes](../sections/habitat-chronicles--unum-pattern--unum-vs-object-two-planes.md) | distributed-objects | A world entity (the teacup) occupies a different plane from the software objects realizing it; the term unum reserves object for OOP objects. |
| [presences-and-division-of-labor](../sections/habitat-chronicles--unum-pattern--presences-and-division-of-labor.md) | distributed-objects, change-propagation | A presence is the per-machine portion of a unum; presences embody division of labor, not master/replica, each with private state. |
| [addressing-presences-vats-and-channels](../sections/habitat-chronicles--unum-pattern--addressing-presences-vats-and-channels.md) | distributed-objects, capability-theory | Messaging a unum means messaging a presence; addresses carry unum-id plus presence-indicator, over vats and channels, with client/server asymmetry. |
| [four-messaging-patterns](../sections/habitat-chronicles--unum-pattern--four-messaging-patterns.md) | distributed-objects, change-propagation | Reply, Neighbor, Broadcast, Point — the four codified server-side messaging patterns over a shared multi-client context. |
| [behavioral-protocols-anti-rest](../sections/habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest.md) | distributed-objects, networking | Unum interfaces are about behavior not data; parameterized operations compress better than state transfer — about as anti-REST as you can be. |
| [other-divisions-of-labor-and-containership](../sections/habitat-chronicles--unum-pattern--other-divisions-of-labor-and-containership.md) | distributed-objects, capability-theory | Alternate divisions of labor (peer-to-peer), per-unum client/server authority (Electric Communities), and the containership problem. |

## See also

- [capability-theory](capability-theory.md) — the ocap/E lineage (vats, Electric Communities, the granovetter operator) that grew out of and alongside this distributed-object work.
- [change-propagation](change-propagation.md) — the delta-propagation view the unum pattern deliberately is *not* (it rejects data-replication in favour of behavioral protocols), and its natural complement for the shared-state side.
- [ocapn](ocapn.md) — the OCapN protocol family that carries capability references between vats, the modern transport counterpart to unum message channels.
- [networking](networking.md) — the datagram/transport substrate under cross-vat message channels.
