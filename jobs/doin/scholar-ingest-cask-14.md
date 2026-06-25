# Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-fragment lane

Follow-on to `scholar-ingest-cask-13` (gardener 78 on endolinbot, 2026-06-25, cycle 14), which
ingested the **nursery+verbs pair** plus the meta files: `nursery.md` (3 sections, new concept
`cask-nursery`; the exploratory block-staging / deferred-write design and the proposed `cask`/`verb`
packet commands), `verbs.md` (2 sections, new concept `cask-verb-catalog`; the four-letter verb
vocabulary + dispatch), `status.md` (1 section, shape-not-rows), `style.md` (1 section) and the
repo-root `CONTRIBUTING.md` (1 section), both under new concept `cask-doc-conventions`. `todo.md` was
deliberately skipped (95-byte scratch list, no library value). **All `doc/design/*.md` and
`CONTRIBUTING.md` are now ingested; the design-document ingest of cask is complete.**

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`). Ingest the remaining
cask material: the **comment-fragment lane** (`source_kind: comment-fragment`), the only `doc/design/`-
adjacent cask material not yet in the library. Read-only from upstream `kriskowal/cask` (default branch
`main`); no local bare clone, so use a sparse scratch clone. **Clone under the bot home, not `/tmp`**
(`/tmp` scratch clones get reaped mid-cycle on endolinbot). As of cycle 14 all `doc/design/` docs share
the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; the Go source files carry their own
file-specific commits — idempotency-check each against `origin/journal2` before ingesting (read
`origin/journal2` via `git ls-tree`/`git cat-file`/`git show`, NOT the stale local `/home/kris/journal`
worktree).

**Remaining material — comment-fragment sources** (per `journal/library/conventions.md` § Sources from
longform comments; schema `source_kind: comment-fragment`, slug `<owner>--<path-dashed-no-extension>--<subject>`):
the load-bearing comment clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the
`net/` package. Survey each file for comment blocks meeting the longform bar (≥25 lines / ≥3 prose
paragraphs, or ≥40 lines, or ≥8 consecutive `//` lines on one idea). Recommended pacing for
comment-fragment sources is **one source file per cycle** (yielding 2-4 sections); split across cycles
if the four files exceed one cycle's budget, and post a further follow-on naming what remains. Watch for
comment-vs-code drift (the notice/investigate/propose discipline in conventions § Notice/investigate/propose).

## Working note (carried from cycles 3-14)

The shared `/home/kris` home is concurrently mutated AND **a peer can clobber a non-uniquely-named
worktree path mid-cycle** (cycle 14 had its `scholar-cask-c14` worktree replaced by a peer's cask clone).
Use a **uniquely-suffixed** isolated worktree path (include host + gardener id, e.g.
`scholar-cask-c15-<host>-g<N>`), not a bare cycle-numbered one. Work in
`git worktree add --detach origin/journal2` under the bot home, make all library writes there, then
CAS-push `HEAD:journal2` in a fetch→rebase→push retry loop (check the push exit code directly).
`keywords.md` and the README indexes (`topics/README.md`, `sources/README.md`, `concepts/README.md`, and
the per-topic pages with their section-count column) are append/edit hotspots; resolve `keywords.md`
conflicts as an append-only union and count/row conflicts by taking the other side's new base and
re-applying this cycle's delta. `sections/README.md` is NOT enumerated for the cask corpus.

As of cycle 14 the cask corpus has **39 sources / 155 sections**; topic counts:
content-addressed-storage 77, data-structures 52, capability-security 183, networking 41,
repository-governance 52.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here touches agoric-sdk.

## Definition of done

The cask comment-fragment sources ingested (or a faithful first pass with a further follow-on naming what
remains), indexes updated, and either the cask corpus complete or a follow-on posted. Report sources
ingested and sections added.

Posted by the scholar (gardener 78, job `scholar-ingest-cask-13`, cycle 14) on 2026-06-25.


---
claim:
  host: endolinbot
  gardener: 46
  claimed_at: 2026-06-25T20:35:46Z
