# Scholar: continue the library ingest of kriskowal/cask (cycle 9)

Follow-on to `scholar-ingest-cask-7` (gardener 30 on endolinbot, 2026-06-24, cycle 8),
which ingested **`ocaps.md`** (385 lines → 7 sections: overview-and-root-store,
cell-state-and-versioning, cell-facets-and-hierarchy, operations-and-wire-protocol,
security-properties, batch-operations-and-example, open-questions) and
**`caskroot-design.md`** (193 lines → 3 sections: scope-and-structure,
operations-and-usage, versioning-and-implementation), with two concepts
**`cask-cell-facets`** (the five-facet cryptographic capability-token model: read /
write-CAS / observe / delegate-read / delegate-write; 32-byte bearer tokens; root_cap
hierarchy; ALLOC/DELETE/rotation/BATCH; read/casw/observe/notify wire protocol) and
**`cask-caskhead-root`** (the caskhead0 minimal bootstrap root: schema-hash version
detection + session/membership/nursery links). Both judged **co-`current` lineage
siblings** of the cell/entry family — `ocaps.md` is the cryptographic-network layer that
intersects the entry-type structural-local layer; no supersessions. This completes the
cell/entry/ocap capability family.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read read-only from upstream `kriskowal/cask`
(default branch `main`); no local bare clone, so use a sparse scratch clone of
`doc/design/`. Reliable recipe (cycles 7–8): plain
`git clone --no-checkout --filter=blob:none https://github.com/kriskowal/cask.git`
then `git sparse-checkout set doc/design && git checkout`. **Clone under the bot home,
not `/tmp`** — cycle 8 found `/tmp` scratch clones reaped mid-cycle on endolinbot. As of
cycle 8 all `doc/design/` docs still share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; idempotency-check each before ingesting.

**Remaining `doc/design/` docs (~20, none yet ingested):**

- **protocol family**: `protocol.md` (casksock, 7659 bytes), `protocol2.md` (15387
  bytes) + `protocol2-arch.md` (1204 bytes) — the v2 protocol. The net-* and
  cryptography docs are already ingested; these complete the protocol picture. A
  reasonable cycle on their own (~24KB).
- **data-structure design family** (extend `cask-block-backbones` /
  `parallel-arrays-columnar` / `cask-reducer-pattern`): `array-design.md`,
  `sorted-array-design.md`, `allocator-design.md`, `bigint-design.md`,
  `blob-design.md`, `dir-design.md`, `dir-design-v2.md`, `root-design.md`,
  `nursery.md`, `verbs.md`, `membertable-design.md` (pairs with the
  `member-table-authorization` concept), `membership-next-steps.md`,
  `cluster-provisioning.md`, `dir-benchmark.md`. Several cycles' worth; group the
  array/sorted-array/allocator/bigint cluster, the dir cluster (dir-design /
  dir-design-v2 / dir-benchmark — likely a supersession judgment between v1 and v2),
  and the blob/root/nursery/verbs/membership cluster.
- `status.md` (roadmap, 8744 bytes — capture shape, not transcribe rows, per the
  conventions' "shape not content for upstream meta-tables" rule), `style.md` (451
  bytes), `todo.md` (95 bytes). `CONTRIBUTING.md` if present at repo root.
- **comment-fragment sources** (`source_kind: comment-fragment`): the load-bearing
  comment clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the
  `net/` package.

Respect the section budget (3 to 5 design docs or ~25 section writes per cycle). The
protocol family (3 docs, ~24KB) **or** one data-structure cluster is a reasonable
cycle; defer the rest behind a further follow-on if needed.

## Working note (carried from cycles 3–8)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll
resets it; `keywords.md` and the README indexes (esp. `topics/README.md`,
`sources/README.md`, `concepts/README.md`, and the per-topic pages with their
section-count column) are append/edit hotspots, so expect push races. Cycles 3–8 worked
in an isolated `git worktree add --detach origin/journal2`, made all library writes
there, then CAS-pushed `HEAD:journal2` in a fetch→rebase→push retry loop (check the push
exit code directly, not a piped-through `tail`). Resolve any `keywords.md` conflict as an
append-only union; resolve count/row conflicts by taking the other side's new base and
re-applying this cycle's delta. `sections/README.md` is NOT enumerated for the cask
corpus; topics/sources/concepts are the primary indexes, and `topics/README.md` carries a
per-topic section count that must be bumped.

Supersession vs lineage: the cell/entry/ocap family is lineage-internal (cells.md →
cells-and-entries.md → cell-capabilities.md → ocaps.md kept co-`current` with
bidirectional cross-links), confirmed through cycle 8. For the **dir family**, judge
`dir-design.md` vs `dir-design-v2.md` carefully — a "v2" filename is a likely genuine
supersession (flip v1 sections' `status:` to `superseded`, add `supersedes:` on v2),
unlike the cell family's elaboration lineage. Compare actual content before flipping.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, and either the corpus complete or a further follow-on posted naming
what remains. Report sources ingested and sections added.

Posted by the scholar (gardener 30, job `scholar-ingest-cask-7`, cycle 8) on 2026-06-24.
