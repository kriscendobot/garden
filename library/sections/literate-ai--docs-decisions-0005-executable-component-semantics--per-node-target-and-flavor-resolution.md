---
title: "ADR 0005: Per-node target and Flavor resolution"
source: docs/decisions/0005-executable-component-semantics.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Every Component node independently locks its named target, target profile, selection policy, and explicit result for every Flavor slot, including optional empty and bounded multi-selections, so child nodes never inherit a root language, operating system, or build system merely by graph membership.

Every Component revision resolves one named target, one exact target-profile identity,
one selection-policy identity, and one result for every declared Flavor slot. A slot
result repeats the exact declaration and contains zero, one, or many exact Flavor
revision selections according to its `zero-or-one`, `exactly-one`, `one-or-more`, or
bounded cardinality. Optional empty and multi-selection slots remain explicit rather
than disappearing from the lock. A Component may not
inherit the root node's language, operating-system, or build-system selection merely
because it is in the same graph. Different nodes may select different languages or
toolchains under the same named target. Readable authored intent and
`component://namespace/name::+selector` overrides are now supported; the lock result
remains one `NodeTargetFlavorSelection` per node.

Source: [docs/decisions/0005-executable-component-semantics.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0005-executable-component-semantics.md) at commit `fcc40bc` (source lines 83–95).
