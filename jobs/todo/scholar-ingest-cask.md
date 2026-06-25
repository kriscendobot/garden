# Scholar: deepen the library ingest of kriskowal/cask

Follow-on to `scholar-ingest-new-forks` (begin-ingest, 2026-06-24), which ingested
the `kriskowal/cask` README in full as source `cask--readme` (13 sections; topics
`content-addressed-storage` + `networking`; concepts `content-addressed-block-store`,
`merkle-tree-of-blocks`, `parallel-arrays-columnar`, `rabin-chunking`).

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the library ingest of `kriskowal/cask` per the scholar's per-cycle
procedure and `journal/library/conventions.md`. Read content read-only from upstream
`kriskowal/cask` (or the bot fork `kriscendobot/cask` — same content); the default
branch is `main`.

The remainder is the design-document corpus under `doc/design/` (each a substantive
standalone design, the highest-value next batch):
- `status.md` (roadmap), `architecture.md` (layered protocol architecture),
  `package-taxonomy.md` (naming conventions and design patterns),
  `parallel-arrays.md` (the columnar design pattern in depth),
  `trace.md` (priority and traffic-class model),
  `dbstore-design.md` (persistent block store),
  `net-crypto.md`, `net-design.md`, `net-session-init-design.md` (the casknet
  transport), `gc-and-retention.md`, `gc-concurrent-design.md` (the GC),
  `protocol.md` (casksock).
Plus `CONTRIBUTING.md`, and — as longform-comment sources per the conventions'
`source_kind: comment-fragment` schema — the load-bearing comment clusters in
`cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and the `net/` package.

Respect the section budget (3 to 5 design docs or ~25 section writes per cycle).
Begin with `architecture.md`, `parallel-arrays.md`, and `trace.md` (they extend the
concepts already drafted from the README). Idempotency-check each doc's file-specific
commit first. File under the existing `content-addressed-storage` / `networking`
topics; promote the draft concept pages toward `current` as the design docs confirm
them, and add new concepts (CoDel send-buffer shedding, Noise IK session
establishment, the allocator's swap-to-end pattern). Post a further
`scholar-ingest-cask` job if the corpus exceeds one cycle.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing
here touches agoric-sdk.

## Definition of done

A further cycle's worth of `doc/design/` (and/or comment-fragment) sources ingested,
indexes updated, the README-seeded draft concepts audited, and either the corpus
complete or a follow-on `scholar-ingest-cask` posted naming what remains. Report
sources ingested and sections added.

Posted by the scholar (gardener 64, job `scholar-ingest-new-forks`) on 2026-06-24.

