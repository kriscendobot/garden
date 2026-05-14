---
title: Pass Invariant
source: draft-specifications/Model.md
source_repo: kriscendobot/ocapn
source_commit: 971eadd133f36b0d57bd32d29d83f221e81b9c1b
source_date: 2025-06-23
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, marshal, pass-style]
status: current
notes: Cross-reference: library/sections/endo--pkg-pass-style-doc-copyarray-guarantees--overview.md, library/sections/endo--pkg-pass-style-doc-copyrecord-guarantees--overview.md, library/sections/endo--pkg-marshal-readme--frozen-objects-only.md.
---

> Abstract: OCapN Pass Invariant: the round-trip-stability requirement for the wire format. A value serialized and then deserialized must yield an equivalent value. Two sub-sections cover Pass Type Invariant (the type is preserved) and Pass Invariant Equality (the equality predicate is preserved). The Endo equivalent invariants are scattered across pass-style/doc/copyArray-guarantees, copyRecord-guarantees, and the marshal README's frozen-objects-only and beyond-json sections.

# Pass Invariant

> Any property that holds for corresponding values both locally and remotely
> between a pair of OCapN peers during a session is a Pass Invariant.

## Pass Type Invariant

All values passable between OCapN peers have a single, invariant type.
A value sent from one peer and received in another will have the same OCapN
type in both peers.
For any value sent from a local peer to a remote peer then returned to the
local peer, the sent and received values will have the same type.

## Pass Invariant Equality

OCapN defines a flavor of equality, nominally Equality.
Two values may be Equal under Equality.
Values of different OCapN types are not Equal.
Values of the same OCapN type may be Equal under conditions specific to their
shared type.
All OCapN types maintain pass invariant Equality except Promise and
(tentatively) Error.

All OCapN implementations, regardless of language, must model all OCapN types
such that Equality for the in-language representation of values is consistent
with the Equality and Pass Invariance of Equality for their corresponding OCapN
model type.

A type holds Equality invariant over passage between OCapN peers.
Any pair of local values that are Equal can be passed to another peer and the
respective remote values will also be Equal.

It follows that, for any local value that is sent over OCapN, if that value
returns to the local peer through any path through the network of remote peers,
the sent and received values will be Equal.

> OCapN Equal values may be locally distinguishable by other operators
> depending on the language implementation and type.

> In JavaScript, none of `==`, `===`, or `Object.is` are sufficient to compare
> Equality of values, which instead must take into account the OCapN type for
> each value.
> For example, Float64 can be compared by `Object.is`, which preserves the
> distinction between 0 and -0 and lack of distinction between any two NaN
> values.
> `Object.is` is also sufficient for Target provided that the OCapN
> implementation holds invariant a single object identity for every Target.
> The JavaScript ArrayBuffer representation of an OCapN ByteArray must be
> compared byte-for-byte.
> Also, `Object.is` is not sufficient for Container because container
> equality is based on recursive equality of the contents.


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
