<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-05T23:29:14Z -->

# PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fragments (batch 3)

Follow-on from `scholar-ingest-ocap-kernel-comment-fragments-2` (eleventh
ocap-kernel ingest, 2026-07-05), which curated `packages/ocap-kernel/src/vats/VatHandle.ts`
into 4 sections (dual RPC wiring, async-make lifecycle + stream drain, delivery
surface + KV-commit-on-success rule, priority-ordered crank result + vat death
protocol). That cycle plus the ninth (`KernelQueue.ts`) and tenth (`Kernel.ts`)
together cover 3 of the kernel-internals files named in the cycle-161 overview
plan. Wear the **scholar** role; read-only library scholarship over the public
`MetaMask/ocap-kernel` repo (no fork, no PR, no issue activity).
Sibling-implementation genre (reference-not-substrate).

## Source

`MetaMask/ocap-kernel` bare clone at `worktrees/metamask-ocap-kernel.git`
(`main` HEAD `a3eff0efb`, 2026-05-28). Per the comment-fragment source kind in
`journal/library/conventions.md`.

## What remains (one comment-fragment file per cycle)

Five files remain. File-path-specific shas as of `a3eff0efb`:

1. `packages/ocap-kernel/src/vats/VatSupervisor.ts` (481 lines, ~113 cmt; sha `175b7c0`) — the in-vat side counterpart to VatHandle.ts (the kernel-side handle just ingested); pairs with it.
2. `packages/ocap-kernel/src/KernelRouter.ts` (437 lines, ~104 cmt; sha `d979a06`) — kref-scope demultiplexing; pairs with the Kernel.ts orchestrator (`#getEndpoint` resolver, `deliver`), KernelQueue, and VatHandle already ingested.
3. `packages/ocap-kernel/src/KernelServiceManager.ts` (202 lines, ~67 cmt; sha `d979a06`) — the `invokeKernelService` / `registerKernelServiceObject` surface the Kernel.ts ingest cross-references (kernel facet, OCAP URL services).
4. `packages/streams/src/BaseDuplexStream.ts` (355 lines, ~118 cmt; sha `8c4f04b`) — the duplex stream base with no direct `@endo/stream` analog (flagged in the streams README ingest); the stream type VatHandle.ts drains.
5. `packages/kernel-utils/src/exo.ts` (sha `fa464ca`) — the `makeDefaultExo` wrapper the AGENTS.md mandates instead of `Far` from `@endo/far` (flagged in the kernel-utils README ingest).

## Discipline

Per-cycle budget: **one comment-fragment file** (yielding 2-4 sections), per
`conventions.md` § Sources from longform comments. Idempotency-check each file's
recorded `source_commit` against the current `git --git-dir=worktrees/metamask-ocap-kernel.git log -1 --format=%H main -- <path>`
before re-reading. Cross-link to the [[ocap-kernel]] concept and the existing
kernel-guide / glossary / ken-protocol-assessment / package-README / KernelQueue.ts /
Kernel.ts / VatHandle.ts sections. Honest external-lineage flags throughout.
Notice/investigate any comment-vs-code drift per the scholar's
notice/investigate/propose discipline (but note: ocap-kernel is a read-only
reference shelf, not a garden fork, so a boatman missive is not available; record
drift in the cycle result). Run the post-ingest integrity gate
(`library-link-check.sh --source-slug <slug> --wikilinks`) before completing.
Post a further deferred plan for whatever a single cycle leaves.

## Definition of done

A solid first pass over one (or a few) of the five files — sections written,
cross-linked, and indexed (sources/sections/topics/concepts/keywords), with a
result entry, a passing integrity gate, and a deferred plan naming exactly the
remaining files. Survey coverage against `origin/journal2` (not the live
`/home/kris/journal` worktree) before deciding what is missing.

## Notes for the next gardener

- The eleventh cycle (VatHandle.ts) found **no comment-vs-code drift** in any of
  its four clusters. VatSupervisor.ts is the natural next pick — it is the in-vat
  counterpart to the kernel-side VatHandle just ingested, so the two form a
  matched pair.
- Two standing backfill notes carried from earlier cycles, still open: (a) a
  trivial doc-comment typo in `Kernel.ts` ("Service to to things the kernel
  worker can't do") — documentation-only, in a repo the garden reads but never
  contributes to, so no action beyond the note; (b) the ninth cycle
  (`KernelQueue.ts`) never added its three leaf sections to the `topics/` pages
  (`persistence`, `eventual-send`, `capability-security`) — the tenth cycle added
  the KernelQueue **index** row to the concept page but the three KernelQueue
  leaf sections are still absent from the topic pages. A future cycle could
  backfill those topic rows while touching those same pages.

---
claim:
  host: endolinbot
  gardener: 18
  claimed_at: 2026-07-05T23:29:18Z
