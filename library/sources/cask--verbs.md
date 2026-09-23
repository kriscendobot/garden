---
source: doc/design/verbs.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
section_count: 2
status: current
notes: Catalog doc; consolidated to 2 sections (the verb catalog itself, and the dispatch/type-designator design notes) per conventions.md's reference-doc consolidation rule. Introduces concept cask-verb-catalog; the reduce shape is the cask-reducer-pattern; the out-of-band/in-band type designators tie to cask-named-typed-pointer.
---

> Abstract: The catalog of CASK's four-letter verb codes for data-structure operations. Each verb maps to one abstract signature shape with common semantics across every type that supports it: reads are `(store, root, args...) → value` and reduces are `(store, root, args...) → root'` over a 32-byte root hash, with the store implicit, following the same reducer shape the rest of CASK uses. There are 10 reads, 17 reduces, 27 verbs total (6 structural lifecycle/encoding verbs and 21 data verbs). The document also specifies verb dispatch: the out-of-band 2-byte mode (cell record / directory entry) plus the in-band schema hash (Links[0]) together fix the valid verb set, and a unified operation layer resolves the target, reads the mode, loads the schema, dispatches the type-specific implementation, and for reduces writes the new root back (a cell CAS or a directory-tree rebuild). A verb applied to an incompatible type is an error.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [verb-catalog](../sections/cask--verbs--verb-catalog.md) | content-addressed-storage | current |
| [verb-dispatch-and-type-designators](../sections/cask--verbs--verb-dispatch-and-type-designators.md) | content-addressed-storage | current |

## Provenance

Source: [doc/design/verbs.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/verbs.md) at commit `cdb975d8` (2026-02-14, Kris Kowal). Ingested by scholar on 2026-06-25 (job `scholar-ingest-cask-13`, cycle 14).
