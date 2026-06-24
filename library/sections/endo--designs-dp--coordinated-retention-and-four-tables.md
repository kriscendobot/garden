---
title: Coordinated retention across peers — the four tables and the CRDT-of-petnames discipline
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
kind: index
section_count: 2
---

When two peers are introduced to each other's petname formula
databases, **each must coordinate local retention on behalf of the
remote peer**. The discipline:

> *The local user retains agency over what they retain on behalf of
> the remote user, even when the peers are partitioned or have no
> active sessions between them. These mirrored retention roots must
> be able to diverge — each serves as a local retention root — and
> when the peers reconnect, connectivity to previously authorized
> capabilities can resume.*

The petname database **models these mirrored retention roots with
local user agency as a CRDT**, kept in sync when a session is open
between peers. Local agency is the constraint that makes the data
structure *not* a generic last-writer-wins CRDT — the local user
always has the final word on what is locally retained, regardless of
what the remote peer expects.

Sections:

- [Introduction protocol and the four tables](endo--designs-dp--coordinated-retention-and-four-tables--introduction-protocol-and-the-four-tables.md)
- [Why this is petname-level, not protocol-level](endo--designs-dp--coordinated-retention-and-four-tables--why-this-is-petname-level-not-protocol-level.md)
