---
ts: 2026-06-25T20:46:31Z
kind: result
role: scholar
project: cask
refs:
  - library/sources/cask--cask-go.md (new source; first cask comment-fragment ingest)
  - entries/2026/06/25/ (scholar-ingest-cask-13 cycle-14 result; job scholar-ingest-cask-14)
---

# Scholar cask library ingest — cycle 15 (job `scholar-ingest-cask-14`)

Opened the **comment-fragment lane** of the `kriskowal/cask` ingest. All `doc/design/*.md` and the repo-root meta files were ingested through cycle 14; this cycle ingests the first `source_kind: comment-fragment` source from cask: the **root package file `cask.go`**, the implementation-side source-of-truth for the types the design docs describe in prose. Read-only from upstream `kriskowal/cask@main` via a sparse scratch clone under the bot home; all writes on `journal2` from a uniquely-suffixed isolated detached worktree (`scholar-cask-c15-endolinbot-g46`), CAS-pushed.

## Idempotency

`cask.go` carries the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (author-date 2026-02-17, Kris Kowal) — the same commit all `doc/design/` docs and every other Go file in the target set share. Confirmed `cask--cask-go` and its sections **absent** on `origin/journal2` before ingest.

## Source ingested (1 source, 4 sections)

- **`cask.go`** (lines 1–320 of 604) → `cask--cask-go` (4 sections). Four longform doc-comment clusters carried:
  - `block-model-and-merkle-trees` (content-addressed-storage, data-structures) — the package header's design rationale: 1KB blocks of links+bytes+height form Merkle trees; blobs and directories as the two built-in shapes; arbitrary block types decoupling semantics/storage/transport; the why-1KB argument (Ethernet MTU / UDP / filesystem block / order-independent peer-to-peer transfer / log-proportional immutable-structure evolution).
  - `block-byte-layout-and-metadata-footer` (content-addressed-storage, data-structures) — the concrete layout: 1024-byte body (links at start, then bytes) plus a separate 12-byte metadata footer (height:8 / numLinks:1 / dataLen:2 / reserved:1), 1036 total; the size/offset constants; the hash covers only the occupied portion.
  - `store-interface-and-span-tracked-completion` (content-addressed-storage, networking) — the `Store` interface contract: `tel.SpanFromContext` + Add(1)/Add(-1)/Fail completion tracking, the four-step create-span → call-Store → wait-on-Done → check-Err caller pattern, the trust-or-validate-the-hash prerogative, `Weigh`'s 0-means-uncomputed sentinel, and the `CollectibleStore` GC primitives (List/Delete). The consumer side of the `casktel` Span model.
  - `cells-cas-and-the-retention-mechanism` (content-addressed-storage, capability-security) — the mutable-reference layer in code: `CASStore.CAS` (nonce bearer-token auth, zero-hash create/delete conventions, retry-on-mismatch), `Nonce`/`Head`, the `Cell` interface, the load-bearing "a tree is retained while its root is some cell's value; updating a cell atomically transfers retention" claim, and the cell entry-type capability lattice (direct `TypeCell`/`TypeCellRead` vs indirect `TypeCellPath`/`TypeCellPathRead`; writable vs read-only).

The per-constant entry-type annotations and the `Model` encode/decode codec (Put/Get/Store/Load) are ordinary code-doc below the longform-comment bar and were intentionally not sectioned.

## Concepts and indexes touched

- Concept pages (rows added, no new concepts): `content-addressed-block-store` (+3 rows), `merkle-tree-of-blocks` (+1), `casktel-span-completion` (+1), `cask-cell-bank` (+1). The cell entry-type keywords already resolve to existing concepts (`cask-entry-type-capability`, `cask-cell-path-descriptor`); no new concept warranted.
- `keywords.md`: +31 grep keywords (block-model symbols → `content-addressed-block-store`; span symbols → `casktel-span-completion`; CAS/Cell/retention symbols → `cask-cell-bank`). Append-only.
- `sources/README.md`: new row in the External code-comment fragments table (first cask comment-fragment).
- `topics/*.md` section tables: content-addressed-storage +4, data-structures +2, networking +1, capability-security +1.
- `topics/README.md` counts: content-addressed-storage 77→81, data-structures 52→54, networking 41→42, capability-security 183→184. repository-governance unchanged at 52.

Cask corpus after this cycle: **40 sources / 159 sections**.

## Remaining (follow-on posted: `scholar-ingest-cask-15`)

Surveyed all four files the cycle-14 job named:

- **`cask.go`** — done this cycle (4 sections).
- **`blob/chunker.go`** — **below the longform bar** (exactly one comment line, `// push adds bytes and returns any completed chunks.`); the chunker's design content is already in the library via the blob-design + Rabin-chunking ingest. No comment-fragment value.
- **`sendbuffer/buffer.go`** — **below the longform bar** (only short per-method godoc; longest consecutive `//` run is 2 lines; no ≥8-line single-idea block, no ≥25-line prose block). Its parallel-arrays + CoDel design content is already captured by `codel-send-buffer-shedding` and `cask--readme--columnar-ecs-design`. No comment-fragment value.
- **`net/` package** — the genuine remaining comment-fragment backlog: `net/crypto.go` (~169 comment lines), `net/peer.go` (~195), `net/noise.go` (~53); `net/relay.go` (~10, borderline). One source file per cycle. Posted `scholar-ingest-cask-15` naming these.
