---
source_kind: paper
source_authors: [Ori Bernstein]
source_title: "GEFS: A Good Enough File System"
source_year: 2023
source_venue: "Plan 9 file-system paper; venue/year inferred as IWP9 2023 (see Provenance)"
source_url: https://orib.dev/gefs.pdf
source_pdf_sha256: 83a3b21a9abd34227f46cc9f2d93be228889d419031dcb6eb46b30443057cf1e
ingested: 2026-09-18
ingested_by: scholar
section_count: 6
status: current
notes: |
  PDF fetched cleanly via fetch-source.sh (direct, 85471 bytes). The body prose
  extracted well but the section HEADINGS and the worked-example key figures were
  rendered in an outline/figure font whose glyphs decode to unrelated names, so
  heading titles and the exact example key bytes could not be recovered; section
  boundaries and titles here are inferred from the surrounding body text. Title,
  venue, and year are likewise inferred (GEFS by Ori Bernstein, presented at IWP9
  2023) — the title glyph-line did not extract. Everything in the section bodies is
  from the recoverable prose.
---

Ori Bernstein's design paper for **GEFS**, a copy-on-write file system for Plan 9 that layers a traditional 9p interface over a forest of **Bεtrees** (write-optimized B+ trees with pivot-node write buffers). Its stated priorities, in order, are crash safety, corruption detection, simplicity, and fast snapshotting — "good enough for daily use," not optimal on every axis. The paper motivates itself against the existing Plan 9 file systems (CWFS, HJFS, fossil), each of which fails crash safety, space reclamation, corruption detection, or O(log n) directory lookup; then develops the Bεtree, the mapping of a file system onto a single flat key-value store (data/entry/up keys, qid-based path walking), ZFS-style deadlist snapshot reclamation with birth generations and a base-snapshot fix for mutable branching, a barrier-separated multi-phase commit protocol with arena header/footer two-phase commit and epoch-based reclamation, and the on-disk format.

This ingest was requested (kriskowal, 2026-09-18) specifically to **cross-reference the garden's CASK and virtual-file-system material**. The through-line of the comparison, drawn out in the section cross-reference blocks and concentrated in concepts [[betree]] and [[gefs]]:

- **On-disk structure (Q1).** GEFS uses a write-optimized Bεtree (buffer-and-flush); CASK uses Rabin-chunked sorted arrays / entries trees (content-defined boundaries, no rebalance); dialog-db uses probabilistic B-trees (prolly trees). All relax classic B-tree balance, but GEFS to make copy-on-write cheap, CASK/dialog-db to make content-addressed diff/sync cheap.
- **Chunking and dedup (Q2).** GEFS does **no** content-defined chunking and **no** deduplication — that absence is the interesting finding against CASK's Rabin approach.
- **Snapshots / GC (Q3).** GEFS reclaims via ZFS deadlists (birth-generation-sharded, merge-on-delete, no whole-disk scan); CASK reclaims via snapshot GC with a mandatory write quarantine (mark/sweep over pinned roots).
- **Crash consistency (Q4).** GEFS is crash-safe by construction: copy-on-write + a barrier-phased commit whose superblock write is the commit point, with arena header/footer as mutual backups and block-pointer hashes for corruption detection.
- **VFS modeling (Q5).** GEFS names by **qid in a single ambient namespace**; resolution is by key construction (concatenate qids and names) — ambient authority over the namespace. The garden's model (Endo formula graph, pet names, the read-only-directory `ebfb#1304` and blob-range `#826` attenuations) is capability-first: attenuable references, not ambient paths. **This is the difference the maintainer asked to be named.**
- **Adoptable vs incompatible (Q6).** A GEFS-style flat keyspace and its deadlist/epoch machinery are fine substrates a capability store could reuse; resolution-by-key-construction is the structurally incompatible part — it hands every holder the whole namespace.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/papers--bernstein-gefs-good-enough-file-system-2023--overview.md) | file-systems | current |
| [betree-write-optimized-data-structure](../sections/papers--bernstein-gefs-good-enough-file-system-2023--betree-write-optimized-data-structure.md) | file-systems, data-structures | current |
| [mapping-the-file-system-onto-betrees](../sections/papers--bernstein-gefs-good-enough-file-system-2023--mapping-the-file-system-onto-betrees.md) | file-systems | current |
| [snapshots-and-deadlist-space-reclamation](../sections/papers--bernstein-gefs-good-enough-file-system-2023--snapshots-and-deadlist-space-reclamation.md) | file-systems | current |
| [crash-safety-commit-protocol-and-concurrency](../sections/papers--bernstein-gefs-good-enough-file-system-2023--crash-safety-commit-protocol-and-concurrency.md) | file-systems | current |
| [on-disk-format](../sections/papers--bernstein-gefs-good-enough-file-system-2023--on-disk-format.md) | file-systems | current |

## Provenance

- Fetched 2026-09-18 from `https://orib.dev/gefs.pdf` via `scripts/jobs/fetch-source.sh` (direct, 85471 bytes; `source_fetched_via=direct`).
- PDF SHA-256 `83a3b21a9abd34227f46cc9f2d93be228889d419031dcb6eb46b30443057cf1e`.
- The PDF's body text is embedded as hex UTF-16 code points and extracted cleanly (179 KB of text). The **section headings** and the **worked-example key figures**, however, are set in an outline/figure font whose glyphs map to unrelated names (person names) rather than characters, so those did not extract — section titles here are inferred from the body prose, and the one worked key-value example is summarized rather than transcribed byte-for-byte. This is recorded honestly rather than reconstructed from memory.
- Title / venue / year are inferred: the paper is GEFS by Ori Bernstein (the domain `orib.dev` is Ori Bernstein's site), widely presented at IWP9 2023; the title glyph-line did not extract. Set `source_year: 2023` on that basis; treat as approximate.
- Ingested by `scholar-ingest-gefs-orib-20260918` per the maintainer's cross-reference-with-CASK-and-VFS request.
