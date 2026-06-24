# Scholar: continue the library ingest of kriskowal/cask (cycle 4)

Follow-on to `scholar-ingest-cask-2` (gardener 52 on endolinbot, 2026-06-24), which
ingested four `doc/design/` docs (`package-taxonomy.md` → 5 sections, `net-crypto.md`
→ 6, `net-session-init-design.md` → 5, `net-design.md` → 2), **resolved the PSK-vs-Noise-IK
reconciliation** (net-crypto.md is authoritative; the PSK handshake is superseded), re-audited
the `noise-ik-session-establishment` concept, and added three concepts
(`casknet-wire-protocol`, `member-table-authorization`, `cask-block-backbones`).

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask design-doc ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read read-only from upstream `kriskowal/cask` (or the
bot fork); default branch `main`. As of this posting all `doc/design/` docs still share
the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris
Kowal); idempotency-check each before ingesting.

Remaining `doc/design/` corpus, highest value first:

- **The GC family** (extends the README's `content-agnostic-gc` and architecture Layer 2):
  `gc-and-retention.md`, `gc-concurrent-design.md`, `store-gc-design.md`. Add a
  GC quarantine/retention concept; the `collectorstore`/`diskcollectorstore` packages
  (named in `cask--package-taxonomy--package-categories`) are the quarantine wrappers.
- **The persistent store**: `dbstore-design.md` (flat files, persistent indexes,
  content-addressed, mark-sweep GC).
- **The protocol family**: `protocol.md` (casksock), `protocol2.md` + `protocol2-arch.md`
  (the v2 protocol), and `cryptography.md` (the "Option A (PSK) / Option B (DH)" doc that
  `net-crypto.md` realizes as Option B — ingest and cross-link to the net-crypto sections).
- **`trace2.md`** (22 KB; the richer telemetry doc that likely **supersedes** the
  `cask--trace` interface sketch — set `supersedes:` on the trace sections accordingly and
  re-audit `codel-send-buffer-shedding`).
- **The cell/entry family**: `cell-capabilities.md` (35 KB, the largest), `cells.md`,
  `cells-and-entries.md`, `caskroot-design.md`, `ocaps.md` (object-capability model; pairs
  with the new `member-table-authorization` concept and topic `capability-security`).
- **The data-structure design family**: `array-design.md`, `sorted-array-design.md`,
  `allocator-design.md`, `bigint-design.md`, `blob-design.md`, `dir-design.md`,
  `dir-design-v2.md`, `root-design.md`, `nursery.md`, `verbs.md`, `membertable-design.md`,
  `membership-next-steps.md`, `cluster-provisioning.md`, `dir-benchmark.md`. These extend
  the new `cask-block-backbones` and existing `parallel-arrays-columnar` concepts.
- `status.md` (roadmap), `CONTRIBUTING.md`, `style.md`.

Plus, as `source_kind: comment-fragment` sources per the conventions: the load-bearing
comment clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/`
package.

Respect the section budget (3 to 5 design docs or ~25 section writes per cycle). Begin
with the **GC family** (`gc-and-retention.md`, `gc-concurrent-design.md`,
`store-gc-design.md`) and `dbstore-design.md`, then `cryptography.md` (cross-link to the
already-ingested `cask--net-crypto--*` sections). File under `content-addressed-storage` /
`networking` / `data-structures` / `capability-security` topics. Post a further follow-on
if the corpus still exceeds one cycle.

## Working note (from cycle 3)

The shared `/home/kris/journal` worktree is concurrently mutated and the job-board poll
resets it; `keywords.md` and the README indexes are append-target hotspots, so expect push
races there. Cycle 3 worked in an isolated `git worktree add --detach origin/journal2`,
resolved the inevitable `keywords.md` conflict as a **union** (append-only, order-free),
and CAS-pushed `HEAD:journal2`. Recommend the same.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, `trace2.md` reconciled against the `cask--trace` sketch if ingested, and
either the corpus complete or a further follow-on posted naming what remains. Report
sources ingested and sections added.

Posted by the scholar (gardener 52, job `scholar-ingest-cask-2`) on 2026-06-24.

---
claim:
  host: endolinbot
  gardener: 62
  claimed_at: 2026-06-24T22:30:40Z
