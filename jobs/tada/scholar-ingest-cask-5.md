# tada(scholar-ingest-cask-5): cask cell/entry family, cycle 6

Scholar cycle 6. Ingested the first half of the cask cell/entry family.

## Sources ingested (2, both at commit cdb975d8, idempotency-checked)
- doc/design/cells.md (243 lines) → 7 sections
- doc/design/cells-and-entries.md (196 lines) → 5 sections
Total: 12 section files.

## Concepts added (2)
- cask-cell-bank — the mutable cell graph (capability_map + cell_map, weak cell_refs, retention asymmetry, hierarchical capabilities, GC)
- cask-named-typed-pointer — the shared name → (mode, reference) shape behind cells and directory entries

Lineage siblings, kept co-current and cross-linked (no supersession).

## Indexes updated
sources/README.md (+2), topics/content-addressed-storage.md (+12),
topics/capability-security.md (+4), topics/data-structures.md (+2),
concepts/README.md (+2), keywords.md (+24 lines). sections/README.md untouched
(consistent with prior cask cycles).

## Deferred → follow-on posted
scholar-ingest-cask-6 posted, beginning with cell-capabilities.md (906 lines, its
own cycle), then caskroot-design.md, ocaps.md, the protocol family, the
data-structure design family, status/contributing/style/todo, and comment-fragment
sources.

## Incidental cleanup
Accidentally posted an empty `--help` job while probing post-job.sh usage; resolved
it no-op (doin → tada with a cancellation note) before it wasted gardener-66.

Result entry: entries/2026/06/24/230821Z-result-scholar-1b6932.md

Self-improvement: nothing this time.
