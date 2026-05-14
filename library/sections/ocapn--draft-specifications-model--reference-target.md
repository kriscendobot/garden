---
title: Reference: Target
source: draft-specifications/Model.md
source_repo: kriscendobot/ocapn
source_commit: 971eadd133f36b0d57bd32d29d83f221e81b9c1b
source_date: 2025-06-23
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, capability-security, captp]
status: current
notes: Cross-reference: library/sections/endo--pkg-marshal-readme--pass-by-presence-vs-copy.md, library/sections/endo--pkg-marshal-readme--convert-val-slot.md.
---

> Abstract: OCapN Reference > Target: a far reference to a capability. The receive side gets a proxy that forwards method calls to the sender's object. Maps to pass-style remotable (the pass-by-presence category). The OCapN spec describes wire-level identity and re-identification; Endo's marshal handles this via convertValToSlot/convertSlotToVal callbacks plugged in by CapTP.

# Reference (Capability)

A value that can receive messages, either a Target or Promise.

> References are the Capabilities in the name OCapN ("Object Capability
> Network") that distinguish a Capability Transfer Protocol from mere RPC
> ("Remote Procedure Calls").
> References forward messages and support
> [Promise Pipelining](https://en.wikipedia.org/wiki/Futures_and_promises#Promise_pipelining).

## Target

Targets represent either a local value or a remote value.
OCapN can export references to local targets and can import references to
remote targets.
A local target handles deliveries and produces either a return value
(fulfillment) or thrown error (rejection reason) for a message delivery.
A remote target (a presence) forwards messages to its corresponding local target.

> - **Guile**: a procedure
> - **JavaScript**: to be proposed
> - **Python**: to be proposed
>
> Tracking: https://github.com/ocapn/ocapn/issues/49

Targets have [Pass Invariant Equality](#pass-invariant-equality).
A target might be sent from a local peer to a remote peer, then the remote peer
may send that target back to the local peer.
The sent target will be equal to the received target and no other value.


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
