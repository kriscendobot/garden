Everything is committed, pushed, verified, and cleaned up. Here is my completion report.

---

# Completion report — `ingest-ocap-kernel` (scholar)

**Done.** Ingested **MetaMask/ocap-kernel `docs/kernel-guide.md`** (the 689-line host-application developer guide) into the library — the most direct source for the **kernel/vat model** the job asked to curate. This is the **sixth ocap-kernel ingest**, extending the cycle-161–165 mini-series (overview, ken-protocol-assessment, glossary, identity-backup-recovery, platform-specific); kernel-guide had been surveyed in the cycle-161 overview but never ingested as its own source.

All writes committed in an isolated worktree off `origin/journal2` and CAS-pushed (commit `069d42b1b`, verified present on `origin/journal2`). Worktree torn down.

## What was curated
- **Source page** `sources/metamask-ocap-kernel--docs-kernel-guide-md.md` (file-specific commit `175b7c0`, 2026-04-23).
- **11 section files** (`...docs-kernel-guide-md--*`): core-concepts, kernel-api, writing-vat-code, vat-endowments, kernel-services, system-subclusters, eventual-send-with-e, exos-remotable-objects, baggage-persistent-state, revocation, key-types-and-complete-example. Every section carries an **honest external-lineage note** (MetaMask's kernel, distinct from @endo).
- **Concept page** `concepts/ocap-kernel.md` synthesizing the kernel/vat/subcluster model.
- **Bidirectional backlinks** added to `granovetter-operator` and `four-ways-to-acquire-references`.

## How it maps to existing ocap concepts (honest lineage)
- **Shared substrate** (flagged, not conflated): `E()` imported directly from `@endo/eventual-send`; exos wrap `@endo/exo` `makeExo`.
- **Divergences flagged**: kref/vref/rref/eref four-scope name-space vs Endo's single formula identifier; first-class `kernel.revoke(kref)` vs Endo's compositional caretaker/membrane (`[[revocation-by-withdrawal]]`); kernel-services-by-name validated at launch vs Endo powers via formula graph; `Far()` forbidden in favor of `makeDefaultExo`.
- **Six-sections cross-links wired**: distributed confinement (vat endowments), three-party hand-off/introduction (`bootstrap` as kernel-introducer → `[[granovetter-operator]]`, `[[four-ways-to-acquire-references]]`), eventual send, sturdyrefs (baggage-stored cross-vat references).

## Indexes updated
`sources/README.md`, `sections/README.md`, `concepts/README.md`, `keywords.md` (21 lines), and 6 topic pages (daemon, capability-security, persistence, hardened-javascript, eventual-send, exo). A `result` journal entry was written under `entries/2026/06/27/`.

## Follow-ups posted (deferred plans)
- `scholar-ingest-ocap-kernel-usage` — `docs/usage.md` (691 lines: setup, vat bundles, cluster config, CLI, testing).
- `scholar-ingest-ocap-kernel-packages` — per-package READMEs + kernel-internals comment fragments (`Kernel.ts`, `VatHandle.ts`, `VatSupervisor.ts`, `KernelQueue.ts`, `KernelRouter.ts`, `BaseDuplexStream.ts`).

A **bulletin synthesis** was surfaced to the maintainer via `message-user`. Inbox drained (empty throughout).

**Self-improvement:** the cycle-161 overview's "queued-for-future-cycles" list is the natural unit for follow-on jobs — one queued doc per ingest cycle, with the next remainder posted as a named deferred plan, keeps the sibling-implementation shelf advancing without rediscovery. Recommend future ocap-kernel job slugs name the specific queued doc/package, as done here.
