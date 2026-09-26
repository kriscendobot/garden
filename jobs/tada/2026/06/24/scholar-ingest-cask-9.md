Done. Cleanup complete, all writes pushed to `origin/journal2`.

---

# Completion report — `scholar-ingest-cask-9` (cask ingest cycle 10)

**Ingested the caskdir directory-format cluster** from `kriskowal/cask` `doc/design/` — 3 source docs, 12 sections, all at the file-specific commit `cdb975d8…` (idempotency-checked against `origin/journal2`; no `cask--dir-*` sources existed). Read-only sparse scratch clone under the bot home; all library writes made in an isolated detached worktree off `origin/journal2` and CAS-pushed (clean on attempt 1; `origin/journal2` now `67fa8025`).

**Sources / sections (all `status: current`):**
- `dir-design.md` → `cask--dir-design` (5): overview-and-entry-format, mode-field, cell-reference-entries, directory-structure-and-operations, lookup-complexity-future-work.
- `dir-design-v2.md` → `cask--dir-design-v2` (4): goals-and-rabin-chunked-entries-tree, navigation-and-mutation-algorithms, migration-and-v1-comparison, table-with-parallel-arrays-alternative.
- `dir-benchmark.md` → `cask--dir-benchmark` (3): compact-vs-table-implementations-and-storage, speed-benchmarks, analysis-and-adaptive-strategy.

**Supersession judgment (the cycle's content call).** The job flagged a likely v1→v2 supersession. On comparing actual content it is **not** one: `dir-benchmark` built both formats and measured v2's recommended *table* (`caskdir`) **70x–326x larger** and **40x–70,000x slower** than the v1-lineage *compact* (`caskcompactdir`) at 5–1,000 entries. The resolution is an **adaptive compact-default hybrid** (table only above ~10,000 entries, 2:1 hysteresis, future `SchemaAdaptiveV0` root), so the v1 compact format remains the practical default. I recorded the arc in `notes:` on every source/section instead of flipping any `status:` to `superseded` — a blind v1→superseded flip would have mis-indexed the corpus.

**Indexes / concepts updated:**
- New concept `caskdir-directory-format` (the three-doc arc, the empirical reversal, and a Common-confusions block on the "v2 supersedes v1" trap and the inverted `caskdir`=table / `caskcompactdir`=compact naming).
- Added section rows + See-also links on `cask-named-typed-pointer`, `parallel-arrays-columnar`, `rabin-chunking`.
- `sources/README.md` (+3), `concepts/README.md` (+1), `keywords.md` (+33 lines under a dated header); topic pages `content-addressed-storage` (+12), `data-structures` (+7), `capability-security` (+2); `topics/README.md` counts bumped (content-addressed-storage 40→52, data-structures 33→40, capability-security 172→174).
- `result` entry written at `entries/2026/06/24/235331Z-result-scholar-fad5b1.md`.

**Follow-up posted:** `scholar-ingest-cask-10` for the remaining ~14 `doc/design/` docs (array/sorted-array/allocator/bigint cluster; blob/root/nursery/verbs/membership cluster; the `status`/`style`/`todo` meta files with shape-not-rows on `status.md`; and the comment-fragment sources in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, `net/`). Inbox was empty; scratch clone and worktree cleaned up.

Self-improvement: nothing this time — the conventions already mandate "compare actual content before flipping status" (§ Staleness/supersession), which this cycle exercised correctly; no role/skill gap surfaced.
