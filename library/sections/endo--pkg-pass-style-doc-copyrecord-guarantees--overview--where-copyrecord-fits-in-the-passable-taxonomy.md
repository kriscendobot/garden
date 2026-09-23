---
title: Where CopyRecord fits in the Passable taxonomy
source: packages/pass-style/doc/copyRecord-guarantees.md
source_repo: endojs/endo
source_commit: be51fb10b6f4
source_date: 2023-11-30
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
parent: endo--pkg-pass-style-doc-copyrecord-guarantees--overview
---

Passable values are those for which `passStyleOf(r)` returns normally rather than throwing. If it returns normally, it returns a string classifying the kind of Passable that `r` is. CopyRecord, CopyArray, and some others are pass-by-copy containers, which are a kind of Passable.
* Pass-by-copy containers only contain Passables. For a CopyRecord, all its properties only have Passable values.

Thus, we can consider a pass-by-copy container to be the root of a tree of pass-by-copy containers, whose leaves are any of the other kinds of Passable, such as JavaScript primitive values, promises, and remotables (far objects and their remote presences). At the JavaScript level, this tree may actually be a dag (directed acyclic graph), but in the semantics of the distributed object system, it is equivalent to the tree that the dag unfolds into. Our distributed object system compares and serializes them only according to their contents as trees.
* `passStyleOf(r)` validates that the pass-by-copy graph starting from a pass-by-copy `r` has no cycles, and therefore is equivalent to a finite tree.
* The future proxy-safety plan explained above will ensure that all pass-by-copy objects in the tree are non-proxies. Put together, once a root has been validated as any pass-by-copy, the entire pass-by-copy tree will be guaranteed to act as simple stable passive data. Be aware that this plan, by design, would still allow proxies at the leaves of the pass-by-copy tree.

Source: [packages/pass-style/doc/copyRecord-guarantees.md](https://github.com/endojs/endo/blob/be51fb10b6f4/packages/pass-style/doc/copyRecord-guarantees.md) at commit `be51fb10`.
