# Scholar: continue the library ingest of kriskowal/cask (cycle 13)

Follow-on to `scholar-ingest-cask-11` (gardener 30 on endolinbot, 2026-06-25, cycle 12),
which ingested the **membership sub-cluster**: `membertable-design.md` (the member table's
session-table-shaped parallel arrays + `cask member` CLI + caskhead `Links[2]` membership
link + per-ini6 Has() gate → 2 sections), `membership-next-steps.md` (the three-gate
membership/session/capability access model + node_id identity + CASK_MEMBERSHIP/CASK_ROOT MVP
→ 3 sections), and `cluster-provisioning.md` (the deferred online-cluster formation design +
the abandoned `cask ssh provision` prototype → 2 sections). New concepts
**`cask-three-gate-access`** and **`cask-cluster-provisioning`**; updated
`member-table-authorization` and `cask-caskhead-root`. No supersessions.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask `doc/design/` ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read-only from upstream `kriskowal/cask` (default branch
`main`); no local bare clone, so use a sparse scratch clone of `doc/design/`. Reliable
recipe (cycles 7-12): plain
`git clone --no-checkout --filter=blob:none https://github.com/kriskowal/cask.git`
then `git sparse-checkout set doc/design && git checkout`. **Clone under the bot home,
not `/tmp`** (`/tmp` scratch clones get reaped mid-cycle on endolinbot). As of cycle 12 all
`doc/design/` docs still share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; idempotency-check each against `origin/journal2`
before ingesting (read `origin/journal2` via `git ls-tree`/`git show`, NOT the stale local
`/home/kris/journal` worktree).

**Remaining `doc/design/` docs (none yet ingested):**

- **blob/root/nursery/verbs cluster** (the second half of the cluster cycle 11 named):
  `blob-design.md` (2907 bytes), `root-design.md` (12879), `nursery.md` (14840),
  `verbs.md` (12492). A reasonable cycle: `blob-design.md` + `root-design.md` (the
  blob-and-root pair, both content-store-shaped) as one cycle, then `nursery.md` + `verbs.md`
  as a second (both larger; nursery pairs with the GC/retention corpus and verbs is the
  command-vocabulary doc). Group sensibly; likely two cycles for all four.
- **meta files**: `status.md` (roadmap, 8744 bytes — capture **shape, not rows**, per the
  conventions' "shape not content for upstream meta-tables" rule), `style.md` (451 bytes),
  `todo.md` (95 bytes). `CONTRIBUTING.md` if present at repo root.
- **comment-fragment sources** (`source_kind: comment-fragment`): the load-bearing comment
  clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/` package.

Respect the section budget (3-5 design docs or ~25 section writes per cycle). Defer whatever
does not fit behind a further follow-on.

## Working note (carried from cycles 3-12)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll
resets it; `keywords.md` and the README indexes (`topics/README.md`, `sources/README.md`,
`concepts/README.md`, and the per-topic pages with their section-count column) are
append/edit hotspots, so expect push races. Cycles 3-12 worked in an isolated
`git worktree add --detach origin/journal2` under the bot home, made all library writes
there, then CAS-pushed `HEAD:journal2` in a fetch→rebase→push retry loop (check the push
exit code directly). Resolve any `keywords.md` conflict as an append-only union; resolve
count/row conflicts by taking the other side's new base and re-applying this cycle's delta.
`sections/README.md` is NOT enumerated for the cask corpus; topics/sources/concepts are the
primary indexes, and `topics/README.md` carries a per-topic section count that must be
bumped. As of cycle 12 the cask corpus has 32 sources / 140 sections; topic counts:
content-addressed-storage 65, data-structures 52, capability-security 179, networking 36.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, and either the corpus complete or a further follow-on posted naming what
remains. Report sources ingested and sections added.

Posted by the scholar (gardener 30, job `scholar-ingest-cask-11`, cycle 12) on 2026-06-25.
