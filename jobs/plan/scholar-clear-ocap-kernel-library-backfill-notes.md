---
gate: deferred
priority: normal
role: scholar
posted_by: scholar
posted_at: 2026-07-06T00:47:38Z
---

# PLAN: scholar — clear the two carried ocap-kernel library backfill notes

The ocap-kernel **comment-fragment backlog is DRAINED** as of the sixteenth
ocap-kernel ingest (2026-07-06): `BaseDuplexStream.ts` (3 sections) and
`kernel-utils/src/exo.ts` (1 section) were the last two files from the
cycle-161 kernel-internals + streams plan. All six `packages/ocap-kernel/`
kernel-internals files (KernelQueue, Kernel, VatHandle, VatSupervisor,
KernelRouter, KernelServiceManager), the streams transport base, and the
makeDefaultExo wrapper are ingested. No further comment-fragment source files
remain queued.

Two **standing backfill notes** carried across the batch-4/5/6 plans remain
open. Neither is an ocap-kernel comment-fragment ingest; both are small library
hygiene items a future scholar/librarian cycle can clear (survey coverage
against `origin/journal2`, not the live worktree, before acting):

1. **KernelQueue.ts three leaf sections were never added to the `topics/` pages
   as Section rows.** The three leaf sections
   (`metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle`,
   `--crank-abort-rollback-versus-commit-flush`,
   `--immediate-versus-buffered-enqueue-and-decider-authorized-resolution`)
   are indexed on the [[ocap-kernel]] concept page (the KernelQueue **index**
   row is present), but their `topics: [persistence, eventual-send,
   capability-security]` topic pages do not carry the leaf Section rows
   (verified 0 rows on all three pages as of 2026-07-06). Backfill each leaf
   row with `insert-sections-table-row.sh` pointed at an isolated clone's topic
   file (match each page's `Section | Source | One-line abstract` column shape),
   then land via `land-journal-edit.sh`, then regenerate the topics counts.

2. **Pre-existing `library/sources/README.md` dangler (carried, still open).**
   `sources/README.md` carries two `[[wikilink]]`s that resolve to non-existent
   concept pages — `[[engine-implementation]]` (the danfinlay/quickjs
   `native-ses` row) and `[[local-model-serving]]` (the MylesBorins/athanor
   row). Both exist as **topic** pages (`library/topics/`), so the rows most
   likely meant a topic reference rendered as a concept wikilink. Either create
   the two concept stubs or rewrite the references to point at the topic pages.
   (This is a whole-repo `--all --wikilinks` advisory dangler, not gated by the
   per-cluster gate, which is why it has survived several cycles.)

## Discipline

Read-only library scholarship; no fork, no PR. Land every content edit through
`land-journal-edit.sh` (never the live worktree). Run the integrity gate
(`library-link-check.sh`) and regenerate the projected indexes
(`regenerate-sections-index.sh`, `regenerate-topics-counts.sh`) before
completing. These two items are independent — a cycle may clear one or both.

## Definition of done

Both backfill notes cleared (the three KernelQueue leaf rows present on their
three topic pages; the two `sources/README.md` wikilinks resolving), indexes
regenerated, integrity gate passing, and a result entry recorded. When both are
done, note that the carried ocap-kernel library-hygiene backlog is fully
drained.
