---
title: Analysis and the Adaptive Strategy
source: doc/design/dir-benchmark.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
notes: This section is the empirical verdict that reverses dir-design-v2's "use table" recommendation. The compact (v1-lineage) format is the practical default; the table format's O(log n)/incremental advantages only pay off at very large directories. The resolution is an adaptive hybrid, not a v1→v2 supersession. See concept caskdir-directory-format.
---

> Abstract: The benchmark's conclusion and the adaptive design it motivates. The table format is slower and larger at every tested size; its real advantages (O(log n) point lookup without deserializing the whole directory, incremental mutation without loading all entries, column independence, extensibility) matter only for very large directories or lookup/incremental-dominated workloads. For small-to-medium directories (under ~1,000 entries) the compact format is overwhelmingly better on every metric. Compact's O(n) rebuild is not a practical bottleneck (a 1,000-entry rebuild is ~300 microseconds); the table's O(log n) per-op cost loses because its constant factor (~50 microseconds per tree op) pushes the crossover far beyond typical sizes. The proposed resolution is **adaptive**: use compact by default, switch to table only above a high size threshold, with 2:1 hysteresis (grow at N > 10,000, shrink at N < 5,000) to avoid thrashing. A future `SchemaAdaptiveV0` root records the current mode (0 compact, 1 table) and delegates; migration is an O(n) list-and-rebuild in either direction, run only on a threshold crossing. For the vast majority of directories the adaptive format behaves exactly like compact with no overhead.

## Analysis

The table format is slower and larger at every tested size. Its structural advantages are: (1) O(log n) point lookup by name without deserializing the whole directory; (2) incremental mutation without loading all entries into memory; (3) column independence (type, name, hash columns read or updated independently); (4) extensibility (adding columns like timestamps or permissions does not change the entry format). These matter for very large directories or workloads dominated by point lookups and incremental updates.

For small-to-medium directories (under ~1,000 entries), the compact format is overwhelmingly better on every metric. The compact format's O(n) rebuild is not a practical bottleneck because the constant factor is tiny (rebuilding a 1,000-entry directory takes ~300 microseconds). The table format's O(log n) per-operation cost is theoretically superior, but its constant factor (~50 microseconds per tree operation) means the crossover point is far beyond typical directory sizes.

## Proposed Adaptive Strategy

Use the compact format by default and switch to the table format only when a directory exceeds a size threshold. Apply hysteresis at the boundary to prevent thrashing.

| Transition | Threshold |
|------------|-----------|
| Compact to table | N > 10,000 entries (grow threshold) |
| Table to compact | N < 5,000 entries (shrink threshold) |

The grow threshold is high because compact remains practical well beyond 1,000 entries; the 2:1 ratio provides hysteresis.

### Schema Versioning and Root Layout

The root block already holds a schema hash (link 0). The compact format uses the `caskio.Writer` streaming format (no schema link; height and link count distinguish it); the table format uses `SchemaV0` in link 0. A future adaptive implementation introduces a new schema identifier (`SchemaAdaptiveV0`) whose root records the current mode and delegates:

```
ADAPTIVE_DIRECTORY_ROOT
 +-- Links[0]  : schema_hash (SchemaAdaptiveV0)
 +-- Links[1]  : inner_root (compact or table root hash)
 +-- Bytes[0]  : mode (0 = compact, 1 = table)
```

### Migration

On growth past the grow threshold: list all entries from the compact directory, build a new table directory, write a new adaptive root with mode = table. On shrink below the shrink threshold: list all entries from the table directory, build a new compact directory, write a new adaptive root with mode = compact. Migration is O(n) in both directions, acceptable because it happens infrequently (only on a threshold crossing after hysteresis). For the vast majority of directories (under 10,000 entries), the adaptive format behaves identically to compact with no overhead.

## Future Work

1. **Reduce table constant factors** by batching column updates into one transaction or caching intermediate tree nodes.
2. **Compact format point lookup** by adding boundary keys to branch nodes (O(log n) lookup without the full table machinery), reducing the table format's motivation at moderate sizes.
3. **Benchmark at larger sizes** (10,000 and 100,000 entries) to validate the thresholds and see whether the table's asymptotic advantage materializes.
4. **Network transfer cost**: the table's higher block count means more UDP packets for sync; measure sync latency/bandwidth for both formats.

## Reproduction

All benchmarks are in `dir/bench_test.go`:

```bash
# Storage size and incremental cost tables
go test ./dir/ -run 'TestStorageSize|TestIncrementalBlockCost' -v
# Speed benchmarks
go test ./dir/ -bench . -benchmem -timeout=600s
```

Source: [doc/design/dir-benchmark.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-benchmark.md) at commit `cdb975d8`.
