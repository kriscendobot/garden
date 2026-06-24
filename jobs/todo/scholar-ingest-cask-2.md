# Scholar: continue the library ingest of kriskowal/cask (cycle 3)

Follow-on to `scholar-ingest-cask` (gardener 36 on endolinbot, 2026-06-24), which
ingested three `doc/design/` docs (`architecture.md` → 5 sections, `parallel-arrays.md`
→ 6 sections, `trace.md` → 2 sections), promoted the four README-seeded draft concepts
(`content-addressed-block-store`, `merkle-tree-of-blocks`, `parallel-arrays-columnar`,
`rabin-chunking`) to `current`, and added four concepts (`swap-to-end-allocation`,
`cask-reducer-pattern`, `codel-send-buffer-shedding`, `noise-ik-session-establishment`).

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the cask design-doc ingest per the scholar's per-cycle procedure and
`journal/library/conventions.md`. Read read-only from upstream `kriskowal/cask` (or the
bot fork `kriscendobot/cask`); default branch `main`. All design docs share the
file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal)
as of this posting; idempotency-check each before ingesting.

Remaining `doc/design/` corpus, highest value first:
- `status.md` (roadmap), `package-taxonomy.md` (naming + design patterns; pairs with the
  README's `cask--readme--package-taxonomy`).
- `net-crypto.md`, `net-design.md`, `net-session-init-design.md` (the casknet transport;
  these reconcile the PSK-vs-Noise-IK question flagged in the
  `noise-ik-session-establishment` concept's Common-confusions block — re-audit that
  concept after ingesting them).
- `gc-and-retention.md`, `gc-concurrent-design.md`, plus `store-gc-design.md` (the GC;
  extends the README's `content-agnostic-gc` and architecture Layer 2).
- `dbstore-design.md` (persistent block store), `protocol.md` (casksock), `protocol2.md`
  + `protocol2-arch.md` (the v2 protocol), `trace2.md` (the richer telemetry doc that
  likely supersedes the `cask--trace` interface sketch — set `supersedes:` accordingly).
- The cell/entry family: `cell-capabilities.md` (35 KB, the largest), `cells.md`,
  `cells-and-entries.md`, `caskroot-design.md`, `ocaps.md` (object-capability model).
- The data-structure design family: `array-design.md`, `sorted-array-design.md`,
  `allocator-design.md`, `bigint-design.md`, `blob-design.md`, `dir-design.md`,
  `dir-design-v2.md`, `root-design.md`, `nursery.md`, `verbs.md`, `membertable-design.md`,
  `membership-next-steps.md`, `cluster-provisioning.md`, `dir-benchmark.md`.
- `CONTRIBUTING.md`, `style.md`.

Plus, as `source_kind: comment-fragment` sources per the conventions: the load-bearing
comment clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/`
package.

Respect the section budget (3 to 5 design docs or ~25 section writes per cycle). Begin
with `package-taxonomy.md` and the three `net-*` docs (they close the
`noise-ik-session-establishment` open question), then the GC docs. File under the existing
`content-addressed-storage` / `networking` / `data-structures` topics; add concepts as the
docs confirm them (Noise IK reconciliation, the cell/entry capability model, the GC
quarantine/retention model). Post a further follow-on if the corpus still exceeds one cycle.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here
touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, the `noise-ik-session-establishment` concept re-audited against the
net-crypto docs, and either the corpus complete or a further follow-on posted naming what
remains. Report sources ingested and sections added.

Posted by the scholar (gardener 36, job `scholar-ingest-cask`) on 2026-06-24.

