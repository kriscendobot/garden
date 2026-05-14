---
title: Appendix A — Vats (communicating event loops)
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
notes: The source carries a "/NOTE: whether to keep this section is subject to further consideration/" so this material may be removed in future spec revisions. The vat abstraction (transactional event-loop containing an object heap) is also the model Endo's daemon implements — soft-flag overlap with endo--pkg-daemon-readme--*. Cross-cuts with the underlying-protocol model spec at ocapn--draft-specifications-model--*.
---

> Abstract: Background note — implementations are free to organize delivery semantics however they want, but the model rooted in the upstream protocol is the **vat**: an event loop with an object heap. Messages to objects are queued FIFO and delivered one at a time; the vat is transactional, so a delivery that errors leaves the vat in the prior state. A peer may contain one or more vats; whether a peer subdivides into vats is internal to that peer and not exposed across the network. Some implementations use a single inter-vat-and-inter-machine messaging system (everything goes through CapTP); others have a fast local-vat-to-local-vat path with CapTP only at machine boundaries.

# Appendix
## Appendix A: Vats

> NOTE: whether or not continuing to include this section is worthwhile is subject to further consideration within the OCapN specification group.

This resembles the pattern of "communicating event loops" which contain objects, and in object-capability-security terminology such event loops are generally called "vats".

A peer may contain one or more vats, but if more than one vat is contained on a peer, this detail is not exposed to the network — it is an internal detail of that peer.

```
;;;   .----------------------------------.         .-------------------.
;;;   |              Peer 1              |         |       Peer 2      |
;;;   |              ======              |         |       ======      |
;;;   |                                  |         |                   |
;;;   | .--------------.  .---------.   .-.       .-.                  |
;;;   | |    Vat A     |  |  Vat B  |   |  \______|  \_   .----------. |
;;;   | |  .---.       |  |   .-.   | .-|  /      |  / |  |   Vat C  | |
;;;   | | (Alice)----------->(Bob)----' '-'       '-'  |  |  .---.   | |
;;;   | |  '---'       |  |   '-'   |    |         |   '--->(Carol)  | |
;;;   | |      \       |  '----^----'    |         |      |  '---'   | |
;;;   | |       V      |       |         |         |      |          | |
;;;   | |      .----.  |       |        .-.       .-.     |  .----.  | |
;;;   | |     (Alfred) |       '-------/  |______/  |____---(Carlos) | |
;;;   | |      '----'  |               \  |      \  |     |  '----'  | |
;;;   | |              |                '-'       '-'     '----------' |
;;;   | '--------------'                 |         |                   |
;;;   |                                  |         |                   |
;;;   '----------------------------------'         '-------------------'
```

- **Object layer**: Alice has a reference to Alfred and Bob, Bob has a reference to Carol, Carlos has a reference to Bob. Possession is directional; Alice having a reference to Bob does not give Bob a reference to Alice.
- **Vat layer**: Alice and Alfred are objects in Vat A, Bob is an object in Vat B, Carol and Carlos are in Vat C.
- **Peer/network layer**: there are two peers (Peer 1 and Peer 2) connected over a CapTP network. The shapes on the borders represent the directions of references each peer has into the other. The cooperating peers preserve the asymmetries (Bob has Carol, not vice versa).

The OCapN specifications leave delivery internals to the implementations and offer no opinion on what system might exist. The protocol has its roots in systems implementing an event loop and object heap called a *vat*. A vat has objects spawned within it; messages sent to these objects queue in a FIFO and are delivered one at a time. Vats are transactional: if an error occurs during message delivery the transaction aborts, leaving the vat in its prior state.

Often machines (virtual or otherwise) have multiple vats running on them. Some implementations have their own messaging between vats and use CapTP only for machine-to-machine. Others use CapTP boundaries between all vats, including those on the same machine.

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
