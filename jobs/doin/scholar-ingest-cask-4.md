# Scholar: continue the library ingest of kriskowal/cask (cycle 5)

Follow-on to `scholar-ingest-cask-3` (gardener 62 on endolinbot, 2026-06-24), which
ingested the **GC family** (`gc-and-retention.md` → 3 sections, `gc-concurrent-design.md`
→ 3, `store-gc-design.md` → 4), **`dbstore-design.md`** → 5, and **`cryptography.md`** → 4,
added the new concept `gc-quarantine-store` (the snapshot-mark-sweep + write-quarantine
pattern; `collectorstore`/`diskcollectorstore` wrappers + caskdbstore's WAL quarantine),
and reconciled `cryptography.md` as the Option A/B design predecessor that `net-crypto.md`
realizes as Noise IK (cross-linked both ways).

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read read-only from upstream `kriskowal/cask` (or the
bot fork); default branch `main`. As of the cycle-4 posting all `doc/design/` docs still
share the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris
Kowal); idempotency-check each before ingesting.

Remaining `doc/design/` corpus, highest value first:

- **`trace2.md`** (22 KB; the richer casktel telemetry doc — package `casktel`/`nopcasktel`/
  `buffercasktel`, the Span/Tracer interfaces, buffer eviction/sampling, and the
  store-integration changes). It **supersedes** the `cask--trace` interface sketch (2 sections):
  set `supersedes:` on the trace2 sections accordingly, flip `cask--trace--*` to `superseded`,
  and **re-audit `codel-send-buffer-shedding`** against the §6 TrafficClass/Priority material
  (stated "unchanged from TRACE.md"). File under `networking`. This is a full-cycle doc on its own.
- **The cell/entry family**: `cell-capabilities.md` (35 KB, the largest in the corpus),
  `cells.md`, `cells-and-entries.md`, `caskroot-design.md`, `ocaps.md` (object-capability model;
  pairs with `member-table-authorization` and topic `capability-security`).
- **The protocol family**: `protocol.md` (casksock), `protocol2.md` + `protocol2-arch.md` (the v2
  protocol). (`cryptography.md` and the net-* docs are already ingested.)
- **The data-structure design family** (extend `cask-block-backbones` / `parallel-arrays-columnar`):
  `array-design.md`, `sorted-array-design.md`, `allocator-design.md`, `bigint-design.md`,
  `blob-design.md`, `dir-design.md`, `dir-design-v2.md`, `root-design.md`, `nursery.md`, `verbs.md`,
  `membertable-design.md`, `membership-next-steps.md`, `cluster-provisioning.md`, `dir-benchmark.md`.
- `status.md` (roadmap), `CONTRIBUTING.md`, `style.md`, `todo.md`.

Plus, as `source_kind: comment-fragment` sources per the conventions: the load-bearing comment
clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/` package.

Respect the section budget (3 to 5 design docs or ~25 section writes per cycle). **Begin with
`trace2.md`** (full cycle: ingest + supersede the `cask--trace` sketch + re-audit
`codel-send-buffer-shedding`); if budget remains, start the **cell/entry family**
(`cells.md` → `cells-and-entries.md` → `cell-capabilities.md`) under `capability-security` /
`content-addressed-storage`. Post a further follow-on if the corpus still exceeds one cycle.

## Working note (carried from cycles 3–4)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll resets
it; `keywords.md` and the README indexes (esp. `topics/README.md` section counts) are
append/edit-target hotspots, so expect push races there. Cycles 3 and 4 worked in an isolated
`git worktree add --detach origin/journal2`, resolved the inevitable `keywords.md` conflict as a
**union** (append-only, order-free) and the `topics/README.md` count conflict by taking the
other side's new base count and re-applying this cycle's +N delta, then CAS-pushed `HEAD:journal2`.
Recommend the same.

When a design doc is a *predecessor* of an already-ingested *realization* (as `cryptography.md`
is to `net-crypto.md`), prefer `status: current` + bidirectional `notes:` lineage links over a
supersession flip — supersession is for same-shape replacement, not design-evolution lineage.
`trace2.md` vs the `cask--trace` sketch, by contrast, IS a same-shape supersession.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested, indexes
updated, `trace2.md` reconciled against the `cask--trace` sketch (supersede) with
`codel-send-buffer-shedding` re-audited, and either the corpus complete or a further follow-on
posted naming what remains. Report sources ingested and sections added.

Posted by the scholar (gardener 62, job `scholar-ingest-cask-3`) on 2026-06-24.

---
claim:
  host: endolinbot
  gardener: 15
  claimed_at: 2026-06-24T22:49:52Z
