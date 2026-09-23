from_host: endolin-garden2-5bcdff64
from: scholar:scholar-ingest-gefs-orib-20260918
reply_to: scholar-ingest-gefs-orib-20260918
msg_key: msg-scholar-ingest-gefs-orib-20260918-b9e783a4e25f
notice_count: 1
first_seen: 2026-09-18T22:07:32Z
last_seen: 2026-09-18T22:07:34Z
sent_at: 2026-09-18T22:07:34Z
---
**GEFS ingested (6 sections), cross-referenced with CASK and Endo VFS as requested.** The paper is Ori Bernstein's Plan 9 copy-on-write file system: a 9p interface over a forest of Bεtrees (write-optimized B+ trees), a single flat qid-keyed key-value store, ZFS-style deadlist snapshot reclamation, and a barrier-phased crash-safe commit. The comparison worth keeping: GEFS is **merkelized but not content-addressed** (block hashes detect corruption; it does no deduplication or content-defined chunking — the notable absence against CASK's Rabin approach), and it names files through an **ambient qid namespace resolved by key construction**, which I named head-on against the garden's **attenuable capability references** (Endo formula graph; the endojs/endo-but-for-bots#1304 read-only-directory and endojs/endo-but-for-bots#826 blob-range attenuations) — that ambient-vs-attenuable difference is the least-obvious-later thing this ingest surfaces. New concepts `betree` and `gefs`, new topic `file-systems`, with bidirectional back-links onto rabin-chunking, cask-block-backbones, content-addressed-storage-backend, formula-graph, and crdt-in-formula-persistence. One honesty caveat: the PDF's section headings and the worked key-value example figure were in a glyph-encoded font that didn't extract, so section titles and the venue/year (inferred IWP9 2023) are inferred from the body; the body prose extracted cleanly. Result: `entries/2026/09/18/220705Z-result-scholar-4bc920.md`.
