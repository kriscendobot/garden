---
title: Structural identity
source: notes/notation.md
source_repo: dialog-db/dialog-db
source_commit: bde506d786a080291051b2e069cabe38cda769b2
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: Both attributes and concepts are **structurally identified** — identity derives from components, not from a name. An attribute's identity is the tuple `(the, type, cardinality)`; a concept's identity is derived from the sorted set of its constituent attribute identities. Two definitions with the same structure are the same thing regardless of how they are referred to. The one nominal escape hatch: an attribute's `the` component (in `domain/name` form) is part of the identity precisely because it carries semantic intent — `diy.cook/quantity` and `diy.cook/price` may both be `(*, Integer, one)` structurally, yet stay distinct because `the` denotes the kind of relation they form. The `description` field is *not* part of identity.

Both attributes and concepts are structurally identified. Their identity is derived from their components, not from a name. However, attributes contain a nominal component (`the`) that captures semantic intent, identifying the relation in `domain/name` format and distinguishing attributes that would otherwise be structurally identical.

An attribute's identity is the tuple `(the, type, cardinality)`. A concept's identity is derived from the sorted set of its constituent attribute identities. Two definitions with the same structure are the same thing, regardless of how they are referred to.

The `the` component within an attribute is nominal: it carries meaning beyond structure. `diy.cook/quantity` and `diy.cook/price` may both be `(*, Integer, one)` structurally, but they are distinct attributes because `the` denotes the kind of relation they form, which is what makes it part of the identity in the first place.

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
