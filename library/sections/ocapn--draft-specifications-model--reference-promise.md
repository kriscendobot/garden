---
title: Reference: Promise
source: draft-specifications/Model.md
source_repo: kriscendobot/ocapn
source_commit: 971eadd133f36b0d57bd32d29d83f221e81b9c1b
source_date: 2025-06-23
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, capability-security, captp, eventual-send]
status: current
notes: Cross-reference: library/sections/endo--pkg-eventual-send-readme--handled-promise.md, library/sections/endo--pkg-eventual-send-readme--e-when.md.
---

> Abstract: OCapN Reference > Promise: a pending capability that will resolve to a Target. The OCapN spec describes promise resolution semantics across the wire (a promise can be fulfilled, rejected, or resolved to another remote reference). Maps to pass-style's promise pass-style and to the HandledPromise primitive in @endo/eventual-send.

## Promise

A Promise represents the eventual return value (fulfillment) or thrown error
(rejection reason) for a message delivery.
A Promise is pending until settled with either a fulfillment or rejection
reason.
OCapN queues messages delivered to a Promise.
If the eventual resolution of a Promise is another Promise, OCapN forwards
the queued messages to the next Promise.
If the eventual fulfillment value of the Promise is a Target, OCapN forwards
the queued messages to the Target.
OCapN does not forward messages to non-references (non-capabilities).

> - **Guile**: to be proposed
> - **JavaScript**: a JavaScript promise
> - **Python**: to be proposed
>
> Tracking https://github.com/ocapn/ocapn/issues/55

OCapN does not maintain [Pass Invariant Equality](#pass-invariant-equality) for
promises.

As with all other types, OCapN does maintain [Pass Type Invariance]
(#pass-type-invariant) such that a local promise sent to a a remote peer
arrives as a promise, regardless of whether it is pending or settled locally.

OCapN maintains that, if a local promise is sent to a remote peer and then
returned, either the fulfillment value or the rejection reason of the sent and
received promises will satisfy the pass invariants applicable to their type.

> For example, if the sent promise settles with a fulfillment value that is a
> Target, the sent and received targets will be equal, because Targets
> maintain [Pass Invariant Equality](#pass-invariant-equality).
>
> For another example, if the sent promise settles with a fulfillment value
> that is a Struct, the sent and received structs will be equal, because all
> [Containers](#container) maintain [Pass Invariant
> Equality](#pass-invariant-equality).


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
