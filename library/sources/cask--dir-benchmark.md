---
source: doc/design/dir-benchmark.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 3
status: current
notes: The empirical verdict on the v1-vs-v2 directory question. Measures the compact (caskcompactdir, v1-lineage) and table (caskdir, v2-table) implementations; the table is slower and larger at every tested size. Resolution is an adaptive hybrid (compact default, table only above 10,000 entries), NOT a v1→v2 supersession. This is why the dir cluster's sources all stay current. See concept caskdir-directory-format.
---

Benchmark observations comparing the two built caskdir implementations, the compact (`caskcompactdir`, inline streaming Merkle tree, full-rebuild mutation) and the table (`caskdir`, parallel-array columns + sorted index over an allocator, incremental mutation), and the adaptive strategy they motivate. The table format is 70x-326x larger in block count and 40x-70,000x slower across build/insert/delete/list at 5-1,000 entries; its O(log n) lookup and incremental-mutation advantages only pay off at very large directories. The proposed resolution uses compact by default and switches to table only above a high threshold (grow at N > 10,000, shrink at N < 5,000, 2:1 hysteresis) via a future `SchemaAdaptiveV0` root. This is the document that empirically reverses `dir-design-v2`'s "use table" recommendation.

| Section | Topics | Status |
|---------|--------|--------|
| [compact-vs-table-implementations-and-storage](../sections/cask--dir-benchmark--compact-vs-table-implementations-and-storage.md) | content-addressed-storage, data-structures | current |
| [speed-benchmarks](../sections/cask--dir-benchmark--speed-benchmarks.md) | data-structures, content-addressed-storage | current |
| [analysis-and-adaptive-strategy](../sections/cask--dir-benchmark--analysis-and-adaptive-strategy.md) | content-addressed-storage, data-structures | current |
