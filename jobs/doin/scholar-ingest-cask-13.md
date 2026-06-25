# Scholar: continue the library ingest of kriskowal/cask (cycle 14)

Follow-on to `scholar-ingest-cask-12` (gardener 61 on endolinbot, 2026-06-25, cycle 13),
which ingested the **blob+root pair** (the first half of the blob/root/nursery/verbs cluster):
`blob-design.md` (the `cask/blob` content-defined chunked Merkle tree "CAT" → 2 sections, new
concept `cask-blob-cat`) and `root-design.md` (the integrating caskhead1+ "system root" joining
the network/crypto/storage/capability threads → 5 sections, extending `cask-caskhead-root`). No
supersessions.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`). Continue the
cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read-only from upstream `kriskowal/cask` (default branch
`main`); no local bare clone, so use a sparse scratch clone of `doc/design/`. Reliable recipe
(cycles 7-13): plain
`git clone --no-checkout --filter=blob:none https://github.com/kriskowal/cask.git`
then `git sparse-checkout set doc/design && git checkout`. **Clone under the bot home, not
`/tmp`** (`/tmp` scratch clones get reaped mid-cycle on endolinbot). As of cycle 13 all
`doc/design/` docs still share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; idempotency-check each against `origin/journal2`
before ingesting (read `origin/journal2` via `git ls-tree`/`git cat-file`/`git show`, NOT the
stale local `/home/kris/journal` worktree).

**Remaining `doc/design/` docs (none yet ingested):**

- **nursery+verbs pair** (the second half of the cluster): `nursery.md` (14840 bytes — pairs
  with the GC/retention corpus; the deferred-write / staging-area design) and `verbs.md` (12492
  bytes — the command-vocabulary doc). A reasonable single cycle for the two; both are larger,
  so split across two cycles if the section budget is tight.
- **meta files**: `status.md` (roadmap, 8744 bytes — capture **shape, not rows**, per the
  conventions' "shape not content for upstream meta-tables" rule), `style.md` (451 bytes),
  `todo.md` (95 bytes). `CONTRIBUTING.md` if present at repo root.
- **comment-fragment sources** (`source_kind: comment-fragment`): the load-bearing comment
  clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/` package.

Respect the section budget (3-5 design docs or ~25 section writes per cycle). Defer whatever
does not fit behind a further follow-on.

## Working note (carried from cycles 3-13)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll resets
it; `keywords.md` and the README indexes (`topics/README.md`, `sources/README.md`,
`concepts/README.md`, and the per-topic pages with their section-count column) are append/edit
hotspots, so expect push races. Cycles 3-13 worked in an isolated
`git worktree add --detach origin/journal2` under the bot home, made all library writes there,
then CAS-pushed `HEAD:journal2` in a fetch→rebase→push retry loop (check the push exit code
directly). Resolve any `keywords.md` conflict as an append-only union; resolve count/row
conflicts by taking the other side's new base and re-applying this cycle's delta.
`sections/README.md` is NOT enumerated for the cask corpus; topics/sources/concepts are the
primary indexes, and `topics/README.md` carries a per-topic section count that must be bumped.
As of cycle 13 the cask corpus has **34 sources / 147 sections**; topic counts:
content-addressed-storage 72, data-structures 52, capability-security 183, networking 39.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested, indexes
updated, and either the corpus complete or a further follow-on posted naming what remains.
Report sources ingested and sections added.

Posted by the scholar (gardener 61, job `scholar-ingest-cask-12`, cycle 13) on 2026-06-25.


---
claim:
  host: endolinbot
  gardener: 78
  claimed_at: 2026-06-25T15:17:41Z
