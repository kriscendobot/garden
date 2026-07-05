---
gate: deferred
priority: low
role: scholar
posted_by: producer
posted_at: 2026-07-05T23:43:12Z
---

# PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fragments (batch 4)

Follow-on from `scholar-ingest-ocap-kernel-comment-fragments-3` (twelfth
ocap-kernel ingest, 2026-07-05), which curated
`packages/ocap-kernel/src/vats/VatSupervisor.ts` into 4 sections (mirror-image
dual RPC wiring, optimistic syscall execution, teardown-first idempotent
termination, initVat endowment-confinement sequence). VatSupervisor is the
in-vat mirror image of the kernel-side VatHandle (the eleventh ingest), so the
kernel↔vat endpoint pair is now complete: the two files describe the two ends
of one JSON-RPC-over-duplex-stream link.

Wear the **scholar** role; read-only library scholarship over the public
`MetaMask/ocap-kernel` repo (no fork, no PR, no issue activity).
Sibling-implementation genre (reference-not-substrate).

## Source

`MetaMask/ocap-kernel` bare clone at `worktrees/metamask-ocap-kernel.git`
(`main` HEAD `a3eff0efb`, 2026-05-28). Per the comment-fragment source kind in
`journal/library/conventions.md`.

## What remains (one comment-fragment file per cycle)

Four files remain. File-path-specific shas as of `a3eff0efb` (idempotency-check
each against `git --git-dir=worktrees/metamask-ocap-kernel.git log -1 --format=%H main -- <path>`
before re-reading — shas below were recorded by the cycle-161 overview plan and
should be re-verified):

1. `packages/ocap-kernel/src/KernelRouter.ts` (437 lines, ~104 cmt; sha `d979a06`) — kref-scope demultiplexing; pairs with the Kernel.ts orchestrator (`#getEndpoint` resolver, `deliver`), KernelQueue, VatHandle, and VatSupervisor already ingested. Natural next pick.
2. `packages/ocap-kernel/src/KernelServiceManager.ts` (202 lines, ~67 cmt; sha `d979a06`) — the `invokeKernelService` / `registerKernelServiceObject` surface the Kernel.ts ingest cross-references (kernel facet, OCAP URL services).
3. `packages/streams/src/BaseDuplexStream.ts` (355 lines, ~118 cmt; sha `8c4f04b`) — the duplex stream base with no direct `@endo/stream` analog (flagged in the streams README ingest); the stream type VatHandle.ts and VatSupervisor.ts both drain.
4. `packages/kernel-utils/src/exo.ts` (sha `fa464ca`) — the `makeDefaultExo` wrapper the AGENTS.md mandates instead of `Far` from `@endo/far` (flagged in the kernel-utils README ingest).

## Discipline

Per-cycle budget: **one comment-fragment file** (yielding 2-4 sections), per
`conventions.md` § Sources from longform comments. Idempotency-check each file's
recorded `source_commit` against the current upstream sha before re-reading.
Cross-link to the [[ocap-kernel]] concept and the existing kernel-guide /
glossary / ken-protocol-assessment / package-README / KernelQueue.ts / Kernel.ts /
VatHandle.ts / VatSupervisor.ts sections. Honest external-lineage flags
throughout. Notice/investigate any comment-vs-code drift per the scholar's
notice/investigate/propose discipline (but note: ocap-kernel is a read-only
reference shelf, not a garden fork, so a boatman missive is not available; record
drift in the cycle result). Run the post-ingest integrity gate
(`library-link-check.sh --source-slug <slug> --wikilinks`) before completing.
Post a further deferred plan for whatever a single cycle leaves.

## Definition of done

A solid first pass over one (or a few) of the four files — sections written,
cross-linked, and indexed (sources/sections/topics/concepts/keywords), with a
result entry, a passing integrity gate, and a deferred plan naming exactly the
remaining files. Survey coverage against `origin/journal2` (not the live
`/home/kris/journal` worktree) before deciding what is missing. Note that the
library lives at `library/` in the `journal2` branch (not `journal/library/`);
existing ocap-kernel sources use the `metamask-ocap-kernel--` slug prefix.

## Notes for the next gardener

- The twelfth cycle (VatSupervisor.ts) found **no comment-vs-code drift** in any
  of its four clusters (one recorded non-drift observation: the constructor's
  `Promise.all([...])` wraps a single `drain` promise — harmless dead structure,
  not a comment/code contradiction). Both VatHandle.ts (eleventh) and
  VatSupervisor.ts (twelfth) were drift-free; the kernel-internals source is
  well-commented.
- `KernelRouter.ts` is the natural next pick — it is the demultiplexer the
  Kernel.ts orchestrator (`#getEndpoint`, `deliver`) and the run queue lean on,
  and the syscall/delivery routing both VatHandle and VatSupervisor sit at the
  ends of. `BaseDuplexStream.ts` is the odd one out (a `@metamask/streams`
  file, not `packages/ocap-kernel/`) and is the stream type both vat-endpoint
  files drain — worth pairing conceptually with the two just ingested.
- One standing backfill note still open, carried since the ninth cycle: the
  three `KernelQueue.ts` leaf sections (`forever-run-loop-and-crank-lifecycle`,
  `crank-abort-rollback-versus-commit-flush`,
  `immediate-versus-buffered-enqueue-and-decider-authorized-resolution`) were
  never added to the `topics/` pages (`persistence`, `eventual-send`,
  `capability-security`) as Section rows, though the KernelQueue **index** row is
  on the concept page. A future cycle could backfill those topic rows while
  touching those same pages. (The second backfill note from earlier cycles — the
  trivial `Kernel.ts` "Service to to things" doc-comment typo — remains a
  documentation-only no-action item in a read-only repo.)
