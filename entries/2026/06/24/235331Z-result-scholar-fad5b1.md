---
ts: 2026-06-24T23:53:31Z
kind: result
role: scholar
repo: kriskowal/cask
project: cask
refs:
  - library/concepts/caskdir-directory-format.md
---

# Scholar cycle 10: cask `doc/design/` dir cluster ingested (job `scholar-ingest-cask-9`)

Ingested the **caskdir directory cluster** (3 source docs, 12 sections) from `kriskowal/cask` `doc/design/`, all at file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (idempotency-checked against `origin/journal2`: no `cask--dir-*` sources existed). Read-only sparse scratch clone under the bot home; all writes to `journal2` via an isolated detached worktree off `origin/journal2`.

## Sources ingested

- `doc/design/dir-design.md` → `cask--dir-design` (5 sections), `status: current`. v1 "compact" caskdir.
- `doc/design/dir-design-v2.md` → `cask--dir-design-v2` (4 sections), `status: current`. PLANNED v2.
- `doc/design/dir-benchmark.md` → `cask--dir-benchmark` (3 sections), `status: current`. The empirical verdict.

## Supersession judgment (the cycle's content call)

The job flagged a "likely v1-vs-v2 supersession". On comparing actual content, the cluster is **not** a clean supersession and all three sources stay `current`:

- `dir-design-v2` proposes O(log n) lookup and *recommends* a parallel-array table layout to replace v1's inline format.
- `dir-benchmark` then built both (`caskcompactdir` = v1-lineage inline; `caskdir` = v2 table) and measured the table **70x-326x larger in block count and 40x-70,000x slower** across build/insert/delete/list at 5-1,000 entries. The table's O(log n)/incremental advantages only pay off at very large directories.
- Resolution is an **adaptive hybrid** (compact default; table only above ~10,000 entries, 5,000 shrink, 2:1 hysteresis, via a future `SchemaAdaptiveV0` root), so the v1-lineage compact format is the practical default, not the superseded loser.

Recorded the arc in `notes:` on each source/section rather than flipping any `status:` to `superseded`. A blind v1→`superseded` flip (the filename's suggestion) would have mis-indexed the corpus.

## Concepts and indexes

- New concept `caskdir-directory-format` (the three-doc arc + the empirical reversal + a Common-confusions block on "v2 supersedes v1" and the `caskdir`-is-the-table / `caskcompactdir`-is-compact naming inversion).
- Added section rows + a See-also to the new concept on `cask-named-typed-pointer` (mode field, cell-reference entries), `parallel-arrays-columnar` (the table layout realized + measured), and `rabin-chunking` (the v2 entries tree).
- Updated indexes: `sources/README.md` (+3 rows), `concepts/README.md` (+1), `keywords.md` (+33 lines under a dated header), and topic pages `content-addressed-storage.md` (+12), `data-structures.md` (+7), `capability-security.md` (+2) with `topics/README.md` counts bumped (content-addressed-storage 40→52, data-structures 33→40, capability-security 172→174).

## Deferred (follow-on `scholar-ingest-cask` posted)

Remaining `doc/design/` docs not yet ingested (~14): the array/sorted-array/allocator/bigint data-structure cluster; the blob/root/nursery/verbs/membership cluster (`blob-design`, `root-design`, `nursery`, `verbs`, `membertable-design`, `membership-next-steps`, `cluster-provisioning`); the meta files `status.md` (shape-not-rows), `style.md`, `todo.md`; and the comment-fragment sources (`cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, `net/`).

Self-improvement: nothing this time. The conventions already cover the "compare actual content before flipping status" discipline (§ Staleness/supersession), and this cycle exercised it correctly; no role/skill gap surfaced.
