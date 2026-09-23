---
section: monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
source: metamask-ocap-kernel--overview
topics: [daemon, captp, persistence]
status: current
title: The §queued-for-future-cycles ingestion plan
parent: metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
---

This first-pass overview ingest cycle (cycle 161 dispatch)
establishes the *reference-shelf entry*. Future cycles can
ingest deeper:

**Doc-level ingests** (each gets its own source page):

1. `docs/ken-protocol-assessment.md` — the most directly
   cross-comparable doc; would pair with cycle 149's
   unhandled-rejection-display and cycle 119's
   daemon-capability-bus.
2. `docs/kernel-guide.md` — host-app developer guide (689
   lines).
3. `docs/usage.md` — usage guide (691 lines).
4. `docs/glossary.md` — canonical vocabulary (240 lines).
5. `docs/identity-backup-recovery.md` — BIP39 backup/recovery
   (289 lines).
6. `docs/platform-specific.md` — Node.js vs browser split
   (92 lines).

**Per-package README ingests** for the cross-comparable
packages: `ocap-kernel`, `kernel-store`, `streams`,
`remote-iterables`, `kernel-utils/exo`, `kernel-rpc-methods`,
`kernel-test`, `service-discovery-types`.

**Code-comment-fragment ingests** for substantive source
files: `Kernel.ts`, `VatHandle.ts`, `VatSupervisor.ts`,
`KernelQueue.ts`, `KernelRouter.ts`, `KernelServiceManager.ts`,
`BaseDuplexStream.ts`.

**Test-file ingests** (per the maintainer's note about
adapting tests to our OCapN and slot machine libraries):
selected test files showing how ocap-kernel exercises
kernel/vat/channel scenarios.

The §queued-for-future-cycles discipline: this overview names
*what would come next* without committing to a sequence; the
loop can pick up any of these as future cycles see fit.
