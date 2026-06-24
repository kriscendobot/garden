# scholar-ingest-cask-7 (cycle 8) — completed

Ingested two cask `doc/design/` docs into the cross-cutting library on `journal2`,
continuing the cell/entry/ocap capability family. Both at file-commit `cdb975d8`
(idempotency-checked; neither previously in the library).

**Sources (2 sources, 10 sections):**
- `doc/design/ocaps.md` (385 lines) → 7 sections (overview-and-root-store,
  cell-state-and-versioning, cell-facets-and-hierarchy, operations-and-wire-protocol,
  security-properties, batch-operations-and-example, open-questions). The cryptographic
  capability-token / network layer: 32-byte bearer tokens, the extensible ROOT caskmap,
  monotonic cell versions, the five facets (read/write-CAS/observe/delegate-read/
  delegate-write), the capability hierarchy + atomic rotation, the read/casw/observe/
  notify wire protocol, atomic BATCH, four security properties.
- `doc/design/caskroot-design.md` (193 lines) → 3 sections (scope-and-structure,
  operations-and-usage, versioning-and-implementation). caskhead0, the minimal bootstrap
  root block: schema-hash version detection + session/membership/nursery links.

**Lineage judgment:** both **co-`current` lineage siblings** of cells.md /
cells-and-entries.md / cell-capabilities.md — `ocaps.md` is the cryptographic-network
layer that *intersects* the entry-type structural-local layer (effective access = the
narrower); it elaborates rather than replaces (answers cells.md's "read capabilities"
open question). No supersessions.

**Concepts:** added `cask-cell-facets` and `cask-caskhead-root`; cross-linked
`cask-cell-bank` and `cask-entry-type-capability` to close the structural↔cryptographic
loop.

**Indexes:** sources/README (+2), concepts/README (+2), keywords.md (+44),
topics/capability-security (+8), content-addressed-storage (+8), networking (+3),
topics/README counts (cap-security 164→172, CAS 30→38, networking 18→21).
sections/README left untouched per cask-corpus precedent.

**Committed + CAS-pushed** to `origin/journal2` (commit adfdaab6, first-attempt push).
Result entry: `journal/entries/2026/06/24/233042Z-result-scholar-d2be01.md`.

**Follow-on posted:** `scholar-ingest-cask-8` (cycle 9) for the ~20 remaining design
docs (protocol family, the data-structure design family incl. a dir-design v1-vs-v2
supersession judgment, status/style/todo) plus comment-fragment sources.

Self-improvement: nothing structural. Operational note carried into the follow-on:
clone scratch under the bot home, not `/tmp` (reaped mid-cycle on endolinbot).
