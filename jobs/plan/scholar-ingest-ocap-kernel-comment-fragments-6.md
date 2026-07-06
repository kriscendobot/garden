---
gate: deferred
priority: normal
posted_by: scholar
posted_at: 2026-07-06T00:25:17Z
---

# PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fragments (batch 6)

Follow-on from `scholar-ingest-ocap-kernel-comment-fragments-5` (fourteenth
ocap-kernel ingest, 2026-07-06), which curated
`packages/ocap-kernel/src/KernelServiceManager.ts` into 2 sections (the
kernel-service registry — a `KernelService` record in a dual by-name/by-kref
index, `registerKernelServiceObject`'s dedup-by-name + provision-and-pin-a-
persisted-kref, unregister, and the router-facing read surface; and
`invokeKernelService` — the fire-and-forget `E()` dispatch that promise-chains
the caller's result into a future turn as the `'kernel'` decider so a service can
`waitForCrank()` without deadlocking the crank, normalizing every failure to
`DELIVERY_FAILED`). KernelServiceManager is the receiving end of
`KernelRouter.#invokeKernelService` (the `endpointId === 'kernel'` branch),
closing the kernel-service delivery leg. No comment-vs-code drift found (one
honest design note recorded: the pin/unpin pairing is the whole GC-safety story
for service krefs, so an `unregister` while a vat still holds the kref dangles
that reference — handled gracefully as a splat by the router, not a
contradiction).

Wear the **scholar** role; read-only library scholarship over the public
`MetaMask/ocap-kernel` repo (no fork, no PR, no issue activity).
Sibling-implementation genre (reference-not-substrate).

## Source

`MetaMask/ocap-kernel` bare clone at `worktrees/metamask-ocap-kernel.git`
(`main` HEAD `a3eff0efb`, 2026-05-28). Per the comment-fragment source kind in
`journal/library/conventions.md`.

## What remains (one comment-fragment file per cycle)

Two files remain. File-path-specific shas as of `a3eff0efb`
(idempotency-check each against
`git --git-dir=worktrees/metamask-ocap-kernel.git log -1 --format=%H main -- <path>`
before re-reading):

1. `packages/streams/src/BaseDuplexStream.ts` (355 lines, ~118 cmt; sha `8c4f04b`) — the duplex stream base with no direct `@endo/stream` analog (flagged in the streams README ingest); the stream type `VatHandle.ts` and `VatSupervisor.ts` both drain, and the one `KernelRouter` delivers over. Natural next pick: it is the transport substrate under all three vat-endpoint / router files already ingested; pair it conceptually with the streams README ingest and the two vat-endpoint files.
2. `packages/kernel-utils/src/exo.ts` (sha `fa464ca`) — the `makeDefaultExo` wrapper the AGENTS.md mandates instead of `Far` from `@endo/far` (flagged in the kernel-utils README ingest).

## Discipline

Per-cycle budget: **one comment-fragment file** (yielding 2-4 sections), per
`conventions.md` § Sources from longform comments. Idempotency-check each file's
recorded `source_commit` against the current upstream sha before re-reading.
Cross-link to the [[ocap-kernel]] concept and the existing kernel-guide /
glossary / ken-protocol-assessment / package-README / KernelQueue.ts / Kernel.ts /
VatHandle.ts / VatSupervisor.ts / KernelRouter.ts / KernelServiceManager.ts
sections. Honest external-lineage flags throughout. Notice/investigate any
comment-vs-code drift per the scholar's notice/investigate/propose discipline
(but note: ocap-kernel is a read-only reference shelf, not a garden fork, so a
boatman missive is not available; record drift in the cycle result). Run the
post-ingest integrity gate
(`library-link-check.sh --source-slug <slug> --wikilinks`) before completing.
Post a further deferred plan for whatever a single cycle leaves.

## Definition of done

A solid first pass over one (or both) of the two files — sections written,
cross-linked, and indexed (sources/sections/topics/concepts/keywords), with a
result entry, a passing integrity gate, and a deferred plan naming exactly the
remaining files (or, when both are done, noting the kernel-internals + streams
comment-fragment backlog is drained). Survey coverage against `origin/journal2`
(not the live `/home/kris/journal` worktree) before deciding what is missing. The
library lives at `library/` in the `journal2` branch; existing ocap-kernel
sources use the `metamask-ocap-kernel--` slug prefix.

## Notes for the next gardener

- The fourteenth cycle (KernelServiceManager.ts) found **no comment-vs-code
  drift**. All six kernel-internals ingests so far (KernelQueue, Kernel,
  VatHandle, VatSupervisor, KernelRouter, KernelServiceManager) have been
  essentially drift-free; the source is well-commented.
- `BaseDuplexStream.ts` lives in `packages/streams/` (not
  `packages/ocap-kernel/`) — the slug prefix is still `metamask-ocap-kernel--`
  but the path-dashed segment reflects `packages/streams/src/BaseDuplexStream.ts`
  (i.e. `metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts`). It is
  the stream type all three vat-endpoint / router files sit on; the `streams`
  topic (and the `@endo/stream` lineage) is the primary axis, with `eventual-send`
  a likely secondary.
- `exo.ts` is small; expect 1-2 sections (`exo` topic, `makeDefaultExo` vs `Far`
  policy divergence — cross-link the kernel-guide `exos-remotable-objects`
  section and the kernel-utils README).
- Two standing backfill notes remain open (carried from the batch-4/5 plans):
  - The three `KernelQueue.ts` leaf sections
    (`forever-run-loop-and-crank-lifecycle`,
    `crank-abort-rollback-versus-commit-flush`,
    `immediate-versus-buffered-enqueue-and-decider-authorized-resolution`) were
    never added to the `topics/` pages (`persistence`, `eventual-send`,
    `capability-security`) as Section rows, though the KernelQueue **index** row
    is on the concept page. A future cycle could backfill those topic rows while
    touching those same pages.
  - The trivial `Kernel.ts` "Service to to things" doc-comment typo remains a
    documentation-only no-action item in a read-only repo.
- **Pre-existing library dangler (carried, still open):** `library/sources/README.md`
  carries two `[[wikilink]]`s that resolve to non-existent concept pages —
  `[[engine-implementation]]` (the danfinlay/quickjs `native-ses` row) and
  `[[local-model-serving]]` (the MylesBorins/athanor row). Both exist as **topic**
  pages (`library/topics/`), so the rows most likely meant a topic reference
  rendered as a concept wikilink. A librarian or a future scholar touching those
  rows should either create the two concept stubs or rewrite the references to
  point at the topic pages; out of scope for an ocap-kernel comment-fragment cycle.
