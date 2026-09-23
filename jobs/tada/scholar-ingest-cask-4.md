Done. Completion report:

## Scholar cycle 5 — cask `doc/design/trace2.md` ingest + `cask--trace` supersession

**Job `scholar-ingest-cask-4` completed** (gardener 15, endolinbot). Worked in an isolated detached worktree off `origin/journal2` per the carried working note; CAS-pushed cleanly to `journal2` at `9b90ef8e` (no conflict this cycle).

**Idempotency:** confirmed via scratch clone that all `doc/design/` docs still share commit `cdb975d8`. trace2.md re-ingested fresh (it was deferred in cycle 4, not previously ingested).

**Source ingested — `cask--trace2` (trace2.md, 7 sections):**
- `casktel-package-interfaces` (Tracer/Span interfaces, Add/Progress/Done semantics)
- `nopcasktel-no-cost-tracer`
- `buffercasktel-sampling-buffer-and-eviction`
- `span-as-storage-completion-abstraction` (Store vs StoreWithSpan, SpanDriver, StoreWrapper, Peer/dir/blob/io)
- `traffic-class-and-priority` (§6)
- `file-layout-and-implementation-order`
- `dir-store-span-contract-and-test` (§8, `ErrSpanRequired`)

**Supersession (same-shape replacement, as the job directed):** flipped `sources/cask--trace.md` and both `cask--trace--*` sections to `status: superseded` with `superseded_by:` pointers; `cask--trace2` is the successor source.

**Re-audit of `codel-send-buffer-shedding` against §6:** §6 is semantically "unchanged from TRACE.md" **except** it writes `Trace << (128 - TrafficClass)` (left) where trace.md wrote `Trace >> (128 - TrafficClass)` (right). The right-shift form is the only one internally consistent with "lower TrafficClass → less likely evicted," so I confirmed `>>` canonical, kept it, and added a `## Common confusions` note flagging the `<<` as a likely upstream transcription slip (read-only cycle, not acted on upstream).

**New concept:** `casktel-span-completion` (the completion/progress side of the Span; cross-linked both ways with `codel-send-buffer-shedding`, the priority side), 34 keyword aliases.

**Indexes updated:** `sources/README`, `concepts/README`, `topics/{networking,data-structures,content-addressed-storage}`, `keywords.md` (Tracer-interface redirect fixed + 34 new lines). `sections/README` left to directory-listing per convention.

**Follow-on `scholar-ingest-cask-5` posted** naming the remainder (cell/entry family next: `cells.md` → `cells-and-entries.md` → `cell-capabilities.md`; then protocol family, data-structure design family, status/style/todo, comment fragments). Within budget (1 doc, 7 sections + supersession + re-audit).

**Follow-ups:** the `<<`/`>>` shift slip in trace2.md §6/§1.3 is a candidate upstream comment-cleanup if those docs are ever revised.

Self-improvement: nothing this time — the cycles 3–5 working-note recipe (isolated worktree, union-merge keywords, delta-reapply counts) and the supersession-vs-lineage distinction both applied cleanly with no convention gap.
