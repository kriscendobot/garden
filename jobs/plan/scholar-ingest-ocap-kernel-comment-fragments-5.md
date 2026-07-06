---
gate: deferred
priority: normal
posted_by: producer
posted_at: 2026-07-06T00:04:08Z
---

# PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fragments (batch 5)

Follow-on from `scholar-ingest-ocap-kernel-comment-fragments-4` (thirteenth
ocap-kernel ingest, 2026-07-05), which curated
`packages/ocap-kernel/src/KernelRouter.ts` into 4 sections (router + promise-state
delivery model; the three-outcome `#routeMessage` splat/send/requeue by kref
scope; the refcount-bookkeeping `#deliverSend` with endpoint-vanished-splat and
kref→eref translation; the c-list-gated `#deliverNotify` + GC deliveries).
KernelRouter is the routing decision that sits between the run loop
(`KernelQueue.ts`) and the two ends of the kernel↔vat duplex link
(`VatHandle.ts` / `VatSupervisor.ts`), all now ingested. No comment-vs-code
drift was found (two honest non-drift notes recorded: the maintainers' own TODO
to narrow the endpoint-vanished bare `catch` to `VatNotFoundError`, and one
slightly-loose `#deliverNotify` inline comment about which promise the in-loop
vs tail refcount-decrement covers).

Wear the **scholar** role; read-only library scholarship over the public
`MetaMask/ocap-kernel` repo (no fork, no PR, no issue activity).
Sibling-implementation genre (reference-not-substrate).

## Source

`MetaMask/ocap-kernel` bare clone at `worktrees/metamask-ocap-kernel.git`
(`main` HEAD `a3eff0efb`, 2026-05-28). Per the comment-fragment source kind in
`journal/library/conventions.md`.

## What remains (one comment-fragment file per cycle)

Three files remain. File-path-specific shas as of `a3eff0efb` (idempotency-check
each against `git --git-dir=worktrees/metamask-ocap-kernel.git log -1 --format=%H main -- <path>`
before re-reading):

1. `packages/ocap-kernel/src/KernelServiceManager.ts` (202 lines, ~67 cmt; sha `d979a06`) — the `invokeKernelService` / `registerKernelServiceObject` surface. Natural next pick: it is the other side of the `#invokeKernelService` closure the just-ingested `KernelRouter.ts` `#deliverKernelServiceMessage` calls when `endpointId === 'kernel'`, and the Kernel.ts ingest cross-references it (kernel facet, OCAP URL services).
2. `packages/streams/src/BaseDuplexStream.ts` (355 lines, ~118 cmt; sha `8c4f04b`) — the duplex stream base with no direct `@endo/stream` analog (flagged in the streams README ingest); the stream type VatHandle.ts and VatSupervisor.ts both drain, and the one KernelRouter delivers over.
3. `packages/kernel-utils/src/exo.ts` (sha `fa464ca`) — the `makeDefaultExo` wrapper the AGENTS.md mandates instead of `Far` from `@endo/far` (flagged in the kernel-utils README ingest).

## Discipline

Per-cycle budget: **one comment-fragment file** (yielding 2-4 sections), per
`conventions.md` § Sources from longform comments. Idempotency-check each file's
recorded `source_commit` against the current upstream sha before re-reading.
Cross-link to the [[ocap-kernel]] concept and the existing kernel-guide /
glossary / ken-protocol-assessment / package-README / KernelQueue.ts / Kernel.ts /
VatHandle.ts / VatSupervisor.ts / KernelRouter.ts sections. Honest external-lineage
flags throughout. Notice/investigate any comment-vs-code drift per the scholar's
notice/investigate/propose discipline (but note: ocap-kernel is a read-only
reference shelf, not a garden fork, so a boatman missive is not available; record
drift in the cycle result). Run the post-ingest integrity gate
(`library-link-check.sh --source-slug <slug> --wikilinks`) before completing.
Post a further deferred plan for whatever a single cycle leaves.

## Definition of done

A solid first pass over one (or a few) of the three files — sections written,
cross-linked, and indexed (sources/sections/topics/concepts/keywords), with a
result entry, a passing integrity gate, and a deferred plan naming exactly the
remaining files. Survey coverage against `origin/journal2` (not the live
`/home/kris/journal` worktree) before deciding what is missing. The library lives
at `library/` in the `journal2` branch; existing ocap-kernel sources use the
`metamask-ocap-kernel--` slug prefix.

## Notes for the next gardener

- The thirteenth cycle (KernelRouter.ts) found **no comment-vs-code drift** in
  any of its four clusters. Two honest non-drift observations are recorded: (a)
  the endpoint-vanished bare `catch` in `#deliverSend` carries the maintainers'
  own `TODO` that it should be narrowed to `VatNotFoundError` so unexpected
  errors are not misfiled as endpoint-gone splats — a self-flagged latent bug,
  not a comment/code contradiction; (b) one `#deliverNotify` inline comment ("the
  promise being notified") is slightly loose about which promise the in-loop vs
  tail refcount-decrement covers (the code is correct). All five kernel-internals
  ingests so far (KernelQueue, Kernel, VatHandle, VatSupervisor, KernelRouter)
  have been essentially drift-free; the source is well-commented.
- `KernelServiceManager.ts` is the natural next pick — it is the receiving end of
  `KernelRouter.#invokeKernelService`, closing the kernel-service delivery leg.
- `BaseDuplexStream.ts` is a `packages/streams/` file (not `packages/ocap-kernel/`)
  and is the stream type all three vat-endpoint / router files sit on; worth
  pairing conceptually with the streams README ingest and the two vat-endpoint
  files.
- Two standing backfill notes remain open:
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
- **Pre-existing library dangler noticed this cycle (not KernelRouter's):**
  `library/sources/README.md` carries two `[[wikilink]]`s that resolve to
  non-existent concept pages — `[[engine-implementation]]` (the danfinlay/quickjs
  `native-ses` row, 2026-07-03) and `[[local-model-serving]]` (the
  MylesBorins/athanor row, 2026-07-04). Both `engine-implementation` and
  `local-model-serving` exist as **topic** pages (`library/topics/`), so the rows
  most likely meant a topic reference rendered as a concept wikilink. A
  `library-link-check --files sources/README.md --wikilinks` flags them. A
  librarian or a future scholar touching those rows should either create the two
  concept stubs or rewrite the references to point at the topic pages; they are
  out of scope for a KernelRouter comment-fragment cycle.
