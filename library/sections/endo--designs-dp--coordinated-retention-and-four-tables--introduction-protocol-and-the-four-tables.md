---
title: Introduction protocol and the four tables
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [daemon, persistence, capability-security, ocapn]
status: current
notes: This is the **petname-side** companion to the cross-peer retention protocol described in [[endo-but-for-bots--llm-designs-dcpg--retention-set-model]]. The DCPG design covers the *wire protocol* for retention propagation; this section covers the *user-facing data model* (mirrored retention roots with local agency) that the wire protocol serves.
parent: endo--designs-dp--coordinated-retention-and-four-tables
---

Connections between peers are arranged through an **out-of-band
mechanism of introduction via a third party**. One party creates an
**invitation** for a specific guest; the guest **accepts** the
invitation.

- The **inviting party** designates a petname for the guest at the
  time of constructing the invitation formula.
- The **accepting party** designates a petname for the host at the
  time of acceptance.

This constructs **coordinated storage for both parties**: a *local
table* and a *remote table* on each side, for a **total of four
tables**:

|   | On the inviter | On the accepter |
|---|---|---|
| Local-agency table | Inviter's policy: what *we* retain about the guest | Accepter's policy: what *we* retain about the host |
| Remote-view table | Inviter's mirror of: what the guest claims to retain about us | Accepter's mirror of: what the host claims to retain about us |

Each *local* table serves the agency of its user. The *remote* table
is **never consulted for local retention decisions** — the local user
always has the final word on what is retained locally, regardless of
what the remote peer expects.

The asymmetry of authority that makes this work is the same one named
in [[endo-but-for-bots--llm-designs-dcpg--status-and-why-crdt-abandoned]]:
each side is the authoritative writer of its own local retention
policy, and there is nothing to *converge on* between sides. The
"CRDT" framing here is descriptive of the data shape (eventually
consistent, append-friendly), not of conflict resolution semantics —
conflicts cannot occur because writes to a side's local table only
come from that side.
