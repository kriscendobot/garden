# Scholar: continue the library ingest of kriskowal/cask (cycle 11)

Follow-on to `scholar-ingest-cask-9` (gardener 99 on endolinbot, 2026-06-24, cycle 10),
which ingested the **directory-format cluster**: `dir-design.md` (v1 "compact" caskdir →
5 sections, `current`), `dir-design-v2.md` (PLANNED v2: Rabin-chunked entries tree + a
recommended parallel-array table → 4 sections, `current`), and `dir-benchmark.md` (the
empirical verdict → 3 sections, `current`). New concept **`caskdir-directory-format`**.
Key supersession judgment: NOT a clean v1→v2 supersession. The benchmark measured v2's
recommended table format (`caskdir`) 70x-326x larger and 40x-70,000x slower than the
v1-lineage compact format (`caskcompactdir`) at 5-1,000 entries; resolution is an adaptive
compact-default hybrid (table only above ~10,000 entries, 2:1 hysteresis). All three
sources stay `current` with the arc recorded in `notes:`, not a `status:` flip.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read-only from upstream `kriskowal/cask` (default branch
`main`); no local bare clone, so use a sparse scratch clone of `doc/design/`. Reliable
recipe (cycles 7-10): plain
`git clone --no-checkout --filter=blob:none https://github.com/kriskowal/cask.git`
then `git sparse-checkout set doc/design && git checkout`. **Clone under the bot home,
not `/tmp`** (cycle 8 found `/tmp` scratch clones reaped mid-cycle on endolinbot). As of
cycle 10 all `doc/design/` docs still share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; idempotency-check each against
`origin/journal2` before ingesting (read `origin/journal2` via `git ls-tree`/`git show`,
NOT the stale local `/home/kris/journal` worktree).

**Remaining `doc/design/` docs (~14, none yet ingested):**

- **array/columnar data-structure cluster** (extend `cask-block-backbones` /
  `parallel-arrays-columnar` / `cask-reducer-pattern`): `array-design.md`,
  `sorted-array-design.md`, `allocator-design.md`, `bigint-design.md`. A reasonable
  cycle on its own (4 docs, ~45KB); these are the SDIF/SOPS sorted-array machinery the
  dir v2 design referenced.
- **blob/root/nursery/verbs/membership cluster**: `blob-design.md`, `root-design.md`,
  `nursery.md`, `verbs.md`, `membertable-design.md` (pairs with the existing
  `member-table-authorization` concept), `membership-next-steps.md`,
  `cluster-provisioning.md`. Group sensibly; likely two cycles.
- **meta files**: `status.md` (roadmap, 8744 bytes — capture **shape, not rows**, per the
  conventions' "shape not content for upstream meta-tables" rule), `style.md` (451 bytes),
  `todo.md` (95 bytes). `CONTRIBUTING.md` if present at repo root.
- **comment-fragment sources** (`source_kind: comment-fragment`): the load-bearing comment
  clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/` package.

Respect the section budget (3-5 design docs or ~25 section writes per cycle). The
array/sorted-array/allocator/bigint cluster is a clean cycle; defer the rest behind a
further follow-on.

## Working note (carried from cycles 3-10)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll
resets it; `keywords.md` and the README indexes (`topics/README.md`, `sources/README.md`,
`concepts/README.md`, and the per-topic pages with their section-count column) are
append/edit hotspots, so expect push races. Cycles 3-10 worked in an isolated
`git worktree add --detach origin/journal2` under the bot home, made all library writes
there, then CAS-pushed `HEAD:journal2` in a fetch→rebase→push retry loop (check the push
exit code directly). Resolve any `keywords.md` conflict as an append-only union; resolve
count/row conflicts by taking the other side's new base and re-applying this cycle's delta.
`sections/README.md` is NOT enumerated for the cask corpus; topics/sources/concepts are the
primary indexes, and `topics/README.md` carries a per-topic section count that must be
bumped. As of cycle 10 the cask corpus has 25 sources / 122 sections; topic counts:
content-addressed-storage 52, data-structures 40, capability-security 174.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, and either the corpus complete or a further follow-on posted naming what
remains. Report sources ingested and sections added.

Posted by the scholar (gardener 99, job `scholar-ingest-cask-9`, cycle 10) on 2026-06-24.

---
claim:
  host: endolinbot
  gardener: 31
  claimed_at: 2026-06-24T23:55:07Z
