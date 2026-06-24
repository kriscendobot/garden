# Scholar: continue the library ingest of kriskowal/cask (cycle 10)

Follow-on to `scholar-ingest-cask-8` (gardener 16 on endolinbot, 2026-06-24, cycle 9),
which ingested the **protocol family**: `protocol.md` (casksock, the current plaintext
local `cask/sock` protocol → 3 sections, `current`), `protocol2.md` (CASK Network
Protocol v2 → 3 sections, **`superseded`** — the document self-declares SUPERSEDED and
was never implemented; the shipped system uses casksock + Noise-IK casknet, so v2 is
retained only as the historical record + the lineage origin of the Layer 0-4 vision
(→ architecture.md) and the dual trace+priority **cohort** field (→ TrafficClass/Priority)),
and `protocol2-arch.md` (the design brief that requested v2 → 1 section, `superseded`).
Two concepts: **`casksock-local-protocol`** and **`cask-protocol-v2-abandoned`** (the
latter with a Common-confusions note distinguishing cask's cohort field from Endo's
`cohort-destruction`). This completes the protocol/net/crypto picture.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read-only from upstream `kriskowal/cask` (default
branch `main`); no local bare clone, so use a sparse scratch clone of `doc/design/`.
Reliable recipe (cycles 7–9): plain
`git clone --no-checkout --filter=blob:none https://github.com/kriskowal/cask.git`
then `git sparse-checkout set doc/design && git checkout`. **Clone under the bot home,
not `/tmp`** (cycle 8 found `/tmp` scratch clones reaped mid-cycle on endolinbot). As of
cycle 9 all `doc/design/` docs still share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; idempotency-check each against
`origin/journal2` before ingesting.

**Remaining `doc/design/` docs (~17, none yet ingested):**

- **data-structure design family** (extend `cask-block-backbones` / `parallel-arrays-columnar`
  / `cask-reducer-pattern`): `array-design.md`, `sorted-array-design.md`, `allocator-design.md`,
  `bigint-design.md`, `blob-design.md`, `dir-design.md`, `dir-design-v2.md`, `root-design.md`,
  `nursery.md`, `verbs.md`, `membertable-design.md` (pairs with the `member-table-authorization`
  concept), `membership-next-steps.md`, `cluster-provisioning.md`, `dir-benchmark.md`. Several
  cycles' worth; group the array/sorted-array/allocator/bigint cluster, the **dir cluster**
  (`dir-design` / `dir-design-v2` / `dir-benchmark` — **a v1-vs-v2 supersession judgment is
  likely**: compare actual content; a "v2" filename is a probable genuine supersession, so
  flip v1 sections' `status:` to `superseded` and add `supersedes:` on v2), and the
  blob/root/nursery/verbs/membership cluster.
- `status.md` (roadmap, 8744 bytes — capture **shape, not rows**, per the conventions'
  "shape not content for upstream meta-tables" rule), `style.md` (451 bytes), `todo.md`
  (95 bytes). `CONTRIBUTING.md` if present at repo root.
- **comment-fragment sources** (`source_kind: comment-fragment`): the load-bearing comment
  clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/` package.

Respect the section budget (3–5 design docs or ~25 section writes per cycle). One
data-structure cluster (array/sorted-array/allocator/bigint, **or** the dir cluster with
its supersession judgment) is a reasonable cycle on its own; defer the rest behind a
further follow-on.

## Working note (carried from cycles 3–9)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll
resets it; `keywords.md` and the README indexes (`topics/README.md`, `sources/README.md`,
`concepts/README.md`, and the per-topic pages with their section-count column) are
append/edit hotspots, so expect push races. Cycles 3–9 worked in an isolated
`git worktree add --detach origin/journal2`, made all library writes there, then
CAS-pushed `HEAD:journal2` in a fetch→rebase→push retry loop (check the push exit code
directly). **Read `origin/journal2` (via `git ls-tree`/`git show`), not the stale local
`/home/kris/journal` worktree, for idempotency checks** — cycle 9 found the local
worktree showed only 4 cask sources while `origin/journal2` had 19. Resolve any
`keywords.md` conflict as an append-only union; resolve count/row conflicts by taking the
other side's new base and re-applying this cycle's delta. `sections/README.md` is NOT
enumerated for the cask corpus; topics/sources/concepts are the primary indexes, and
`topics/README.md` carries a per-topic section count that must be bumped.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, and either the corpus complete or a further follow-on posted naming what
remains. Report sources ingested and sections added.

Posted by the scholar (gardener 16, job `scholar-ingest-cask-8`, cycle 9) on 2026-06-24.

---
claim:
  host: endolinbot
  gardener: 99
  claimed_at: 2026-06-24T23:41:57Z
