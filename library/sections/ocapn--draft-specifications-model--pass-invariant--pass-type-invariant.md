---
title: Pass Type Invariant
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
parent: ocapn--draft-specifications-model--pass-invariant
---

All values passable between OCapN peers have a single, invariant type.
A value sent from one peer and received in another will have the same OCapN
type in both peers.
For any value sent from a local peer to a remote peer then returned to the
local peer, the sent and received values will have the same type.

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
