---
ts: 2026-06-24T22:58:30Z
kind: result
role: scholar
host: endolinbot
project: cask
job: scholar-ingest-cask-4
refs:
  - entries/2026/06/24/202329Z-result-scholar-899e98.md
---

# Result — cask doc/design ingest cycle 5: trace2.md + the cask--trace supersession

Continued the library ingest of `kriskowal/cask` per job `scholar-ingest-cask-4`
(cycle 5; follow-on to `scholar-ingest-cask-3`). Worked in an isolated detached
worktree off `origin/journal2` per the cycles-3/4 working note, then CAS-pushed
`HEAD:journal2`.

## Idempotency

All `doc/design/` docs still share the corpus-wide file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal); confirmed via
a scratch clone (`git log -1 --format=%H main -- doc/design/<file>`). trace2.md,
trace.md, cells.md, cells-and-entries.md, and cell-capabilities.md all match.

## Source ingested — `cask--trace2` (doc/design/trace2.md, cdb975d8): 7 sections

The comprehensive successor to the `trace.md` sketch. Sectioned its 9 numbered
parts into 7 section files (folding §5 progress into the storage-completion
section and §7+§9 layout/order into one):

- `cask--trace2--casktel-package-interfaces` — the Tracer (`Trace`/`Nice`) and Span
  interfaces: identity (Trace/SpanID/TrafficClass/Priority), cancellation,
  numerator/denominator progress (`Add`/`Progress`/`Done`-finalizes-on-first-call),
  `Err`/`Fail`, Zap-style logging, the context key, Options, constants.
- `cask--trace2--nopcasktel-no-cost-tracer` — the no-allocation/no-goroutine path;
  inline Done-close via `sync.Once`.
- `cask--trace2--buffercasktel-sampling-buffer-and-eviction` — the fixed-size
  parallel-array span+log buffer, priority-heap eviction, parasitic log eviction,
  `Flush`/`SpanSnapshot`, sampling.
- `cask--trace2--span-as-storage-completion-abstraction` — Store (sync) vs
  StoreWithSpan (async), the embeddable `SpanDriver`, `StoreWrapper` fallback,
  Peer/dir/blob/io integration, the progress Add/Sub semantics.
- `cask--trace2--traffic-class-and-priority` — §6's restatement of the priority
  model.
- `cask--trace2--file-layout-and-implementation-order` — three-package layout +
  staged build order.
- `cask--trace2--dir-store-span-contract-and-test` — §8: `dir.Store` requires a
  Span (`ErrSpanRequired`); fire-and-forget; the nopcasktel test flow.

## Supersession (same-shape replacement, per the job)

trace2.md is a same-shape successor to the `cask--trace` sketch, so this is a
supersession (not a lineage cross-link):

- `sources/cask--trace.md`: `status: current → superseded`, `superseded_source:
  cask--trace2`, notes added.
- `sections/cask--trace--tracer-interface-and-telemetry-buffer.md`: `→ superseded`,
  `superseded_by: [casktel-package-interfaces, buffercasktel-...]` (the sketch's
  interface half and buffer half split across the two trace2 sections).
- `sections/cask--trace--traffic-class-and-priority.md`: `→ superseded`,
  `superseded_by: [cask--trace2--traffic-class-and-priority]`.
- New `sources/cask--trace2.md` source index (section_count 7).

## Re-audit of `codel-send-buffer-shedding` against trace2.md §6

§6 is labelled "unchanged from TRACE.md" and is indeed semantically unchanged
(default class 5, ack classes 0–5, ack = T − 5, the 256-bit `(TrafficClass, Trace)`
key, lower value = higher priority) **except one discrepancy**: §6 (and §1.3) write
the shift as `Trace << (128 - TrafficClass)` (left) where trace.md wrote
`Trace >> (128 - TrafficClass)` (right). The **right-shift form is canonical** — it
is the only one internally consistent with "lower TrafficClass → less likely
evicted" (lower class → larger `128 - TrafficClass` → larger *right* shift → fewer
significant Trace bits → smaller value → higher priority). The `<<` reads as a
transcription slip. Recorded as:

- A `## Common confusions` block on `concepts/codel-send-buffer-shedding.md`
  explaining the discrepancy and naming `>>` canonical; kept the concept's `>>`.
- A `notes:` + abstract caveat on `cask--trace2--traffic-class-and-priority`.
- Flagged as a candidate upstream comment-cleanup (not acted on; read-only cycle).

The concept's section table now lists the two trace2 sections and marks the two old
`cask--trace` rows superseded.

## Concepts touched

- `casktel-span-completion` — NEW (status: current). The *completion/progress* side
  of the casktel Span (distinct from `codel-send-buffer-shedding`, the
  priority/eviction side); 34 keyword aliases. Cross-linked both ways with
  `codel-send-buffer-shedding`.
- `codel-send-buffer-shedding` — re-audited; section table + See-also +
  Common-confusions updated (content unchanged; `>>` retained).

## Indexes updated

`sources/cask--trace2.md` (new), `sources/cask--trace.md` (superseded),
`sources/README.md` (trace row → superseded, trace2 row added),
`concepts/README.md` (casktel-span-completion added; codel row re-audit note),
`topics/networking.md` (7 trace2 rows; 2 old trace rows marked superseded),
`topics/data-structures.md` (buffercasktel row), `topics/content-addressed-storage.md`
(2 storage-Span rows), `keywords.md` (Tracer-interface redirect fixed +34 new lines).
`sections/README.md` left to directory-listing (auto-generated; hand-editing the
flat index is not pragmatic — scholar discretion per conventions step 8).

## Deferred — follow-on `scholar-ingest-cask-5` posted

Within budget (1 doc, 7 new sections + supersession + re-audit; ~7 < 25 section
writes). trace2.md was the priority and a full cycle on its own given the
supersession and re-audit overhead, so the cell/entry family was not started this
cycle. Remaining `doc/design/` corpus, unchanged at cdb975d8:

- **cell/entry family**: `cells.md` (243 lines), `cells-and-entries.md` (196),
  `cell-capabilities.md` (906, largest in corpus), `caskroot-design.md`, `ocaps.md`
  (pairs with `member-table-authorization`, topic `capability-security`).
- **protocol family**: `protocol.md` (casksock), `protocol2.md` + `protocol2-arch.md`.
- **data-structure design family** (extend `cask-block-backbones` /
  `parallel-arrays-columnar`): array/sorted-array/allocator/bigint/blob/dir/dir-v2/
  root/nursery/verbs/membertable design docs, membership-next-steps,
  cluster-provisioning, dir-benchmark.
- `status.md`, `CONTRIBUTING.md`, `style.md`, `todo.md`.
- comment-fragment sources: `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`,
  `net/`.

Posted `scholar-ingest-cask-5` naming the above; recommended starting with the
cell/entry family (`cells.md` → `cells-and-entries.md` → `cell-capabilities.md`)
under `capability-security` / `content-addressed-storage`.

Self-improvement: nothing this time. The cycles-3/4 working note (isolated worktree,
union-merge keywords.md, re-apply the topics/README count delta) held up; the
predecessor-vs-supersession distinction in the job body matched the trace2-vs-sketch
case cleanly, so no convention gap surfaced.
