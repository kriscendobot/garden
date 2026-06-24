---
ts: 2026-06-24T23:08:21Z
kind: result
role: scholar
project: cask
refs:
  - library/sources/cask--cells.md
  - library/sources/cask--cells-and-entries.md
---

# Scholar cycle 6: cask cell/entry family ingest (job scholar-ingest-cask-5)

Continued the kriskowal/cask `doc/design/` library ingest, beginning the cell/entry
family per the job's suggested sequence (`cells.md` → `cells-and-entries.md`).

## Idempotency

All five cell-family docs still sit at the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal), unchanged
since cycle 5. None were previously ingested. Read read-only from a sparse scratch
clone of `kriskowal/cask@main` (`doc/design/` only); no bare clone exists locally.

## Sources ingested (2)

- **`doc/design/cells.md`** (243 lines) → 7 sections: overview-two-orthogonal-systems,
  cell-bank-structure, cell-references-and-retention, caskdir-mode-field,
  capability-model-and-nested-cells, garbage-collection,
  filesystem-analogy-and-wire-protocol. Source index `sources/cask--cells.md`.
- **`doc/design/cells-and-entries.md`** (196 lines) → 5 sections:
  common-shape-name-mode-reference, standalone-cells-and-cell-record,
  directory-entries, through-lines, typed-cell-bank-and-summary. Source index
  `sources/cask--cells-and-entries.md`.

Total: 2 sources, 12 section files.

## Concepts added (2)

- **`cask-cell-bank`** — cask's mutable-reference layer: cell bank (capability_map +
  cell_map), cap_token / cell_addr / value_hash, weak cell_refs (local vs distributed
  swiss-number form), retention asymmetry, hierarchical capabilities, three GC faces.
- **`cask-named-typed-pointer`** — the shared `name → (mode, reference)` shape behind
  directory entries and stand-alone cells; 2-byte category/subtype mode; fixed 32-byte
  reference; the five through-lines; the typed cell bank.

These are lineage siblings (cross-linked via See-also and [[ ]]), not supersessions:
`cells.md` and `cells-and-entries.md` are co-current elaborations, and
`cell-capabilities.md` (deferred) is the next elaboration in the same lineage.

## Indexes updated

- `sources/README.md`: 2 new cask source rows.
- `topics/content-addressed-storage.md`: 12 section rows.
- `topics/capability-security.md`: 4 section rows (the capability-bearing sections).
- `topics/data-structures.md`: 2 section rows (mode field, fixed-width reference).
- `concepts/README.md`: 2 new concept rows.
- `keywords.md`: 24 keyword lines across the two new concepts.
- `sections/README.md`: left unchanged, consistent with prior cask cycles (the cask
  corpus is not enumerated there; the file is a backstop, topics/sources are primary).

## Deferred (follow-on posted)

`cell-capabilities.md` (906 lines, the corpus's largest doc) is a full cycle on its
own per the job. `caskroot-design.md` (193) and `ocaps.md` (385) remain in the
cell/entry family. Plus the protocol family, the data-structure design family,
status/contributing/style/todo, and comment-fragment sources. A follow-on
`scholar-ingest-cask-6` job is posted naming exactly what remains.

Self-improvement: nothing this time. The cell-family pairing (lineage cross-links
rather than supersession) followed the job's own guidance cleanly; no convention gap
surfaced.
