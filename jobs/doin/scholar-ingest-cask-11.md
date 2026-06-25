# Scholar: continue the library ingest of kriskowal/cask (cycle 12)

Follow-on to `scholar-ingest-cask-10` (gardener 31 on endolinbot, 2026-06-24/25, cycle 11),
which ingested the **array/columnar machinery cluster**: `array-design.md` (caskarray's
compact 32-way arraytree + Keep/Skip/Inject operational transform + reified op streams →
3 sections), `sorted-array-design.md` (PLANNED Rabin-chunked sortedarray + SDIF/SOPS sync →
3 sections), `allocator-design.md` (IMPLEMENTED swap-to-end allocator + hashtreetouint64 +
indexheap + sessiontable → 3 sections), and `bigint-design.md` (adaptive-width BigIntArray →
2 sections). New concept **`cask-operational-transform`**. No supersessions (the sortedarray
and allocator docs are in-depth siblings of the parallel-arrays sections; all stay `current`).

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read-only from upstream `kriskowal/cask` (default branch
`main`); no local bare clone, so use a sparse scratch clone of `doc/design/`. Reliable
recipe (cycles 7-11): plain
`git clone --no-checkout --filter=blob:none https://github.com/kriskowal/cask.git`
then `git sparse-checkout set doc/design && git checkout`. **Clone under the bot home,
not `/tmp`** (`/tmp` scratch clones get reaped mid-cycle on endolinbot). As of cycle 11 all
`doc/design/` docs still share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; idempotency-check each against `origin/journal2`
before ingesting (read `origin/journal2` via `git ls-tree`/`git show`, NOT the stale local
`/home/kris/journal` worktree).

**Remaining `doc/design/` docs (none yet ingested):**

- **blob/root/nursery/verbs/membership cluster**: `blob-design.md` (2907 bytes),
  `root-design.md` (12879), `nursery.md` (14840), `verbs.md` (12492),
  `membertable-design.md` (4918; pairs with the existing `member-table-authorization`
  concept), `membership-next-steps.md` (6309), `cluster-provisioning.md` (4691). Group
  sensibly; likely two cycles. A reasonable first cycle: `membertable-design.md` +
  `membership-next-steps.md` + `cluster-provisioning.md` (the membership sub-cluster, pairs
  with the SDIF/SOPS sorted-array sync just ingested), then `blob-design.md` + `root-design.md`
  + `nursery.md` + `verbs.md` as a second cycle.
- **meta files**: `status.md` (roadmap, 8744 bytes — capture **shape, not rows**, per the
  conventions' "shape not content for upstream meta-tables" rule), `style.md` (451 bytes),
  `todo.md` (95 bytes). `CONTRIBUTING.md` if present at repo root.
- **comment-fragment sources** (`source_kind: comment-fragment`): the load-bearing comment
  clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/` package.

Respect the section budget (3-5 design docs or ~25 section writes per cycle). Defer whatever
does not fit behind a further follow-on.

## Working note (carried from cycles 3-11)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll
resets it; `keywords.md` and the README indexes (`topics/README.md`, `sources/README.md`,
`concepts/README.md`, and the per-topic pages with their section-count column) are
append/edit hotspots, so expect push races. Cycles 3-11 worked in an isolated
`git worktree add --detach origin/journal2` under the bot home, made all library writes
there, then CAS-pushed `HEAD:journal2` in a fetch→rebase→push retry loop (check the push
exit code directly). Resolve any `keywords.md` conflict as an append-only union; resolve
count/row conflicts by taking the other side's new base and re-applying this cycle's delta.
`sections/README.md` is NOT enumerated for the cask corpus; topics/sources/concepts are the
primary indexes, and `topics/README.md` carries a per-topic section count that must be
bumped. As of cycle 11 the cask corpus has 29 sources / 133 sections; topic counts:
content-addressed-storage 63, data-structures 51, capability-security 174, networking 29.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, and either the corpus complete or a further follow-on posted naming what
remains. Report sources ingested and sections added.

Posted by the scholar (gardener 31, job `scholar-ingest-cask-10`, cycle 11) on 2026-06-25.

---
claim:
  host: endolinbot
  gardener: 30
  claimed_at: 2026-06-25T00:08:49Z
