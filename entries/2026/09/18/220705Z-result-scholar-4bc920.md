---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-09-18T22:07:07Z
---
# Scholar cycle result — ingest GEFS (orib.dev/gefs.pdf)

Job: `scholar-ingest-gefs-orib-20260918` (maintainer request, kriskowal 2026-09-18:
ingest GEFS, cross-referencing CASK and virtual-file-system material).

## Source ingested

- **GEFS: A Good Enough File System** (Ori Bernstein), `source_kind: paper`,
  fetched via `fetch-source.sh` from `https://orib.dev/gefs.pdf` (direct, 85471 B,
  PDF SHA-256 `83a3b21a9abd34227f46cc9f2d93be228889d419031dcb6eb46b30443057cf1e`).
  New source-index: `sources/papers--bernstein-gefs-good-enough-file-system-2023.md`.
  **6 section files** written:
  - `--overview` (motivation vs CWFS/HJFS/fossil; the four priorities; design summary)
  - `--betree-write-optimized-data-structure` (pivot write buffers, upsert messages, block layout)
  - `--mapping-the-file-system-onto-betrees` (flat KV store: data/entry/up keys; qid path walking)
  - `--snapshots-and-deadlist-space-reclamation` (ZFS deadlists, birth generations, base snapshot)
  - `--crash-safety-commit-protocol-and-concurrency` (barrier-phased commit, arenas, epoch reclamation)
  - `--on-disk-format` (superblocks, arena headers, logs, pivot/leaf blocks, key types, opcodes)

## Extraction honesty

The PDF body prose extracted cleanly (hex UTF-16 code points, decoded to 46 KB of
readable text). The section **headings** and the one worked-example **key figure**
were set in an outline/figure font whose glyphs decode to unrelated names, so those
did not extract: section titles are inferred from the surrounding body, and the
worked key-value example is summarized rather than transcribed byte-for-byte. Title,
venue, and year (GEFS, Ori Bernstein, IWP9 2023) are likewise inferred — the title
glyph-line did not extract. Recorded in the source-index `notes:`/Provenance.

## Concepts and topics

- New concept `concepts/betree.md` (Bεtree; compared to Rabin-chunked structures + prolly trees).
- New concept `concepts/gefs.md` (the file system; holds the CASK/VFS comparison and the
  ambient-namespace-vs-attenuable-reference difference, answering the ingest's six questions).
- New topic `topics/file-systems.md` (crash-safe on-disk file systems; 6 sections).
- Section `--betree-*` also filed under existing topic `data-structures` (row inserted via helper).

## Bidirectional cross-links added (the maintainer's ask)

Back-links landed on existing concepts/topics so a reader arriving from the CASK/Endo
side finds the comparison:
- `concepts/rabin-chunking.md` → `[[betree]]`
- `concepts/cask-block-backbones.md` → `[[betree]]`
- `concepts/content-addressed-storage-backend.md` → `[[gefs]]`
- `concepts/formula-graph.md` → `[[gefs]]`
- `concepts/crdt-in-formula-persistence.md` → `[[gefs]]`
- `topics/content-addressed-storage.md` See also → `file-systems`
The new `betree`/`gefs` concept pages and the `file-systems` topic point forward at
rabin-chunking, cask-block-backbones, cask-entry-type-capability, the cask GC/snapshot
sections, content-addressed-storage-backend, and formula-graph.

## Index updates

- `sources/README.md` (External papers row), `concepts/README.md` (betree + gefs bullets),
  `topics/README.md` (file-systems Index row), `keywords.md` (betree/gefs terms) — all landed
  via `land-journal-edit.sh`.
- Projected indexes regenerated as the final landing step: `regenerate-sections-index.sh`
  (landed `sections/README.md`) and `regenerate-topics-counts.sh` (landed `topics/README.md`).

## Integrity gate (step 8)

- `library-link-check.sh --all` → rc=0 (every must-resolve navigation/index/source-table
  link resolves; 205 dangling links are pre-existing upstream-verbatim body links, advisory only).
- `regenerate-topics-counts.sh --check` → stale counts only (informational; reconciled by the
  `--land` step above); no missing topic page.

## Follow-on / backlog

None. The paper is fully ingested in one cycle (6 sections, at the paper-cycle ceiling).
No deferred remainder.
