---
title: @endo/marshal (overview)
source: packages/marshal/README.md
source_repo: endojs/endo
source_commit: 70bcca3d4ba93e92221a9188f583126ca84e4e4d
source_date: 2024-02-05
source_authors: [Richard Gibson, Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [marshal, pass-style]
status: current
---

> Abstract: @endo/marshal is the pass-style serialization layer for capability-bearing values. Converts between in-memory JavaScript values and a smallcaps wire format, distinguishing pass-by-copy values (the passable types: copyArray, copyRecord, primitive, error) from pass-by-presence values (remotables). Foundation for CapTP and OCapN protocols.

# @endo/marshal

"Marshalling" refers to the conversion of structured data (a tree or graph of
objects) into a string, and back again.

The `marshal` module helps with conversion of "capability-bearing data", in
which some portion of the structured input represents "pass-by-proxy" or
"pass-by-presence" objects that should be serialized into values referencing
special "slot identifiers". The `toCapData()` function returns a "CapData"
structure: an object with a `body` containing a serialization of the input data,
and a `slots` array holding the slot identifiers. `fromCapData()` takes this
CapData structure and returns the object graph. There is no generic way to
convert between pass-by-presence objects and slot identifiers, so the marshaller
is parameterized with a pair of functions to create the slot identifiers and turn
them back into proxies/presences.

`marshal` uses JSON to serialize the object graph, but knows how to serialize
values that cannot be expressed directly in JSON, such as bigints, `NaN`, and
`undefined`.


Source: [packages/marshal/README.md](https://github.com/endojs/endo/blob/70bcca3d4ba93e92221a9188f583126ca84e4e4d/packages/marshal/README.md) at commit `70bcca3d`.
