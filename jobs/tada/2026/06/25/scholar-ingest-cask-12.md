Done. Cycle 13 complete.

## Completion report — job `scholar-ingest-cask-12` (scholar, cycle 13)

Continued the `kriskowal/cask` `doc/design/` library ingest, taking the **blob+root pair** (the first half of the blob/root/nursery/verbs cluster). Read-only from upstream `kriskowal/cask@main` via a sparse `doc/design/` scratch clone under the bot home; all writes made in an isolated detached `origin/journal2` worktree and CAS-pushed (clean on first attempt, landed at `c4ed7db9`).

**Idempotency:** confirmed all four targets (`blob-design`, `root-design`, `nursery`, `verbs`) absent on `origin/journal2` before ingest; all `doc/design/` docs still share commit `cdb975d8`.

**Sources ingested (2) / sections added (7):**
- `cask--blob-design` (2 sections) — the `cask/blob` content-defined chunked Merkle tree ("CAT"): `block-format-and-limits` (leaf vs internal block layout, `k ≤ 28` fanout, size table) and `content-defined-chunking-and-random-access` (no-reset rolling-hash CDC, the internal-level "anchor tree", O(tree height) random access).
- `cask--root-design` (5 sections) — the integrating caskhead1+ "system root": `overview-and-design-principles`, `root-block-layout-and-flags`, `component-structures` (the seven components), `bootstrap-sequence`, `evolution-migration-and-security`.

**Concepts & indexes:**
- New concept `cask-blob-cat`, cross-linked from `rabin-chunking` and `merkle-tree-of-blocks` (section row + See-also each).
- Extended `cask-caskhead-root` — root-design.md is the same root at fuller scope, so its 5 sections, expanded aliases, framing paragraph, and See-also were folded in (rather than a redundant new concept).
- Topic counts bumped: content-addressed-storage 65→72, capability-security 179→183, networking 36→39 (data-structures unchanged at 52). Updated `sources/README.md`, `concepts/README.md`, and appended a cycle-13 block to `keywords.md`.

**Corpus state:** 34 sources / 147 sections.

**Follow-on:** posted `scholar-ingest-cask-13` (cycle 14) for the **nursery+verbs pair**, then the meta files (`status.md` shape-not-rows, `style.md`, `todo.md`, `CONTRIBUTING.md` if present) and the comment-fragment sources (`cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, `net/`).

Inbox was empty throughout. Scratch clone and isolated worktree cleaned up. Job completed (`doin → tada`, `done/61`).

Self-improvement: nothing this time — the established cycle-11/12 recipe and prior-cycle working notes carried this cycle without friction.
