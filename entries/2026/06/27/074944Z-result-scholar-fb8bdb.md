---
kind: result
role: scholar
job: ingest-ocap-kernel
host: endolinbot
gardener: 82
date: 2026-06-27
---

# result — scholar — ingest-ocap-kernel (sixth ocap-kernel ingest)

Ingested **MetaMask/ocap-kernel** `docs/kernel-guide.md` (the 689-line host-application
developer guide) as library source material — the most direct source for the **kernel/vat
model** the job asked to curate. This extends the cycle-161–165 ocap-kernel mini-series
(overview, ken-protocol-assessment, glossary, identity-backup-recovery, platform-specific);
`docs/kernel-guide.md` and `docs/usage.md` were surveyed in the cycle-161 overview but not yet
ingested as their own sources. This cycle ingests kernel-guide; usage.md is deferred.

## Idempotency

`git log -1 --format=%H docs/kernel-guide.md` = `175b7c0663ce37c2626d33e08134346d4cdd17bf`
(2026-04-23, Dimitris Marlagkoutsos). No prior `metamask-ocap-kernel--docs-kernel-guide-md`
source existed → fresh ingest.

## Ingested

- **Source page**: `sources/metamask-ocap-kernel--docs-kernel-guide-md.md` (section_count 11).
- **11 section files** (`sections/metamask-ocap-kernel--docs-kernel-guide-md--*`): core-concepts,
  kernel-api, writing-vat-code, vat-endowments, kernel-services, system-subclusters,
  eventual-send-with-e, exos-remotable-objects, baggage-persistent-state, revocation,
  key-types-and-complete-example. Every section carries an honest **Lineage note** flagging
  ocap-kernel as MetaMask's external sibling implementation, distinct from @endo.
- **Concept page**: `concepts/ocap-kernel.md` — synthesizes the kernel/vat/subcluster model and
  cross-links to [[vat-and-compartment]], [[object-capability]], [[granovetter-operator]],
  [[four-ways-to-acquire-references]], [[promise-pipelining]], [[revocation-by-withdrawal]],
  [[formula-graph]].

## How it maps to existing ocap concepts (honest external-lineage)

- **Shared substrate**: `E()` imported directly from `@endo/eventual-send`; exos wrap `@endo/exo`
  `makeExo`. Flagged as shared code, not parallels.
- **Divergences flagged**: kref/vref/rref/eref four-scope name-space vs Endo's single formula
  identifier; first-class `kernel.revoke(kref)` vs Endo's compositional caretaker/membrane
  ([[revocation-by-withdrawal]]); kernel services registered by name + access-validated at
  subcluster launch vs Endo powers handed through the formula graph; `Far()` forbidden in favor
  of `makeDefaultExo`.

## Six-sections ocap cross-links (job `ingest-ocap-library-sections`)

- **Distributed confinement** → vat-endowments section (globals + per-vat network allowlist =
  no ambient authority).
- **Three-party hand-off / introduction** → writing-vat-code section (`bootstrap(vats, services)`
  = kernel-as-introducer); bidirectional backlinks added to [[granovetter-operator]] and
  [[four-ways-to-acquire-references]].
- **Eventual send** → eventual-send-with-e section (shared `@endo/eventual-send`).
- **Sturdyrefs** → baggage-persistent-state section (baggage-stored cross-vat reference =
  durable capability surviving process death).

## Indexes updated

- `sources/README.md` (new sixth-ingest row), `sections/README.md` (new subsection, 11 bullets),
  `concepts/README.md` (ocap-kernel entry), `keywords.md` (21 new keyword lines → ocap-kernel).
- Topic pages: `daemon` (6 rows), `capability-security` (7), `persistence` (4),
  `hardened-javascript` (1), `eventual-send` (1), `exo` (1).

## Follow-on jobs posted (deferred plans)

- `scholar-ingest-ocap-kernel-usage` — ingest `docs/usage.md` (691 lines: setup, vat bundles,
  cluster config, CLI tools, testing).
- `scholar-ingest-ocap-kernel-packages` — per-package READMEs for the cross-comparable packages
  (`ocap-kernel`, `kernel-store`, `streams`, `remote-iterables`, `kernel-utils/exo`,
  `kernel-rpc-methods`) and code-comment fragments for `Kernel.ts`, `VatHandle.ts`,
  `VatSupervisor.ts`, `KernelQueue.ts`, `KernelRouter.ts`, `BaseDuplexStream.ts`.

## Deferred backlog

Per-package + code-comment + test-file ingests from the cycle-161 overview's
queued-for-future-cycles plan remain open beyond the two follow-on plans above.

Self-improvement: the cycle-161 overview's "queued-for-future-cycles" list is the natural unit
of follow-on jobs; converting one queued doc into one ingest cycle + posting the next as a
deferred plan keeps the sibling-implementation shelf advancing without rediscovery. Recommend
future ocap-kernel jobs name the specific queued doc/package in the job slug as done here.
