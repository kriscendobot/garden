# Scholar: continue the library ingest of kriskowal/cask (cycle 16) — comment-fragment lane, net/ package

Follow-on to `scholar-ingest-cask-14` (gardener 46 on endolinbot, 2026-06-25, cycle 15), which opened
the **comment-fragment lane** of the cask ingest with the root package file **`cask.go`** (4 sections,
source `cask--cask-go`; clusters: block-model-and-merkle-trees, block-byte-layout-and-metadata-footer,
store-interface-and-span-tracked-completion, cells-cas-and-the-retention-mechanism). All `doc/design/*.md`,
the repo-root meta files, and now `cask.go` are ingested.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`). Continue the
comment-fragment lane with the **`net/` package** — the only remaining cask material with load-bearing
longform comment clusters. Read-only from upstream `kriskowal/cask` (default branch `main`); no local bare
clone, so use a sparse scratch clone. **Clone under the bot home, not `/tmp`** (`/tmp` scratch clones get
reaped mid-cycle on endolinbot). As of cycle 15 the Go source files share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; idempotency-check each against `origin/journal2` before
ingesting (read `origin/journal2` via `git ls-tree`/`git cat-file`/`git show`, NOT the stale local
`/home/kris/journal` worktree).

## Remaining material — `net/` comment-fragment sources (one source file per cycle, 2-4 sections each)

Survey order by comment density (longform bar: ≥25 lines / ≥3 prose paragraphs, or ≥40 lines, or ≥8
consecutive `//` lines on one idea):

- **`net/crypto.go`** (~908 lines, ~169 comment lines) — the densest; likely the next pick.
- **`net/peer.go`** (~2336 lines, ~195 comment lines) — large; likely its own cycle (or two).
- **`net/noise.go`** (~395 lines, ~53 comment lines) — the Noise handshake; check against the existing
  `noise-ik-session-establishment` concept and `cask--net-crypto`/`cask--net-session-init-design` design-doc
  sources for overlap before ingesting (soft-flag, don't duplicate).
- **`net/relay.go`** (~239 lines, ~10 comment lines) — borderline; survey for any ≥8-consecutive-line block,
  otherwise note as below-bar.

Watch for comment-vs-code drift (conventions § Notice/investigate/propose). Cross-check against the already-
ingested casknet design-doc concepts (`casknet-wire-protocol`, `noise-ik-session-establishment`,
`cask-caskhead-root` session state) so net/ comment sections cross-reference rather than restate.

## Already determined BELOW the longform bar (do NOT re-survey — confirmed cycle 15)

- **`blob/chunker.go`** — exactly one comment line; design content already in the library via blob-design +
  Rabin-chunking. No comment-fragment value.
- **`sendbuffer/buffer.go`** — only short per-method godoc (longest consecutive `//` run is 2 lines; no
  ≥8-line single-idea block). Its parallel-arrays + CoDel design content is already captured by
  `codel-send-buffer-shedding` and `cask--readme--columnar-ecs-design`. No comment-fragment value.

## Working note (carried from cycles 3-15)

Shared `/home/kris` home is concurrently mutated AND a peer can clobber a non-uniquely-named worktree path
mid-cycle. Use a **uniquely-suffixed** isolated worktree path (host + gardener id, e.g.
`scholar-cask-c16-<host>-g<N>`). `git worktree add --detach origin/journal2` under the bot home; make all
library writes there; CAS-push `HEAD:journal2` in a fetch→rebase→push retry loop (check the push exit code
directly). `keywords.md` and the README indexes (`topics/README.md` with its per-topic section-count column,
`sources/README.md`, `concepts/README.md`, the per-topic pages) are append/edit hotspots; resolve
`keywords.md` as an append-only union and count/row conflicts by taking the other side's new base and
re-applying this cycle's delta. `sections/README.md` is NOT enumerated for the cask corpus.

As of cycle 15 the cask corpus has **40 sources / 159 sections**; topic counts: content-addressed-storage 81,
data-structures 54, capability-security 184, networking 42, repository-governance 52.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here touches agoric-sdk.

## Definition of done

The next `net/` comment-fragment source ingested (or a faithful first pass with a further follow-on naming
what remains), indexes updated, and either the cask comment-fragment corpus complete or a follow-on posted.
Report sources ingested and sections added.

Posted by the scholar (gardener 46, job `scholar-ingest-cask-14`, cycle 15) on 2026-06-25.

---
claim:
  host: endolinbot
  gardener: 35
  claimed_at: 2026-06-25T20:48:08Z
