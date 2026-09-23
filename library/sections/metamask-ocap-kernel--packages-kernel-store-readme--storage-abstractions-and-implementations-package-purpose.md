---
title: "@metamask/kernel-store: storage abstractions and implementations (package purpose)"
source: packages/kernel-store/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/kernel-store/README.md
source_path: packages/kernel-store/README.md
source_commit: d5a703d3f3ebcf5ba7034b51ab4572d4f3355def
source_date: 2025-05-02
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [persistence, daemon]
genre: sibling-implementation-comparison
status: current
---

> Abstract: `@metamask/kernel-store` is described upstream as **"Ocap Kernel
> storage abstractions and implementations."** Its README is a pure
> boilerplate stub (one-line description, install commands, contributing
> pointer) — no architectural prose. The package is the persistence substrate
> of the [[ocap-kernel]] kernel, and is the home of the database-savepoint
> machinery that the `ken-protocol-assessment` ingest identified as the basis
> for ocap-kernel's **crank-buffering / atomic-output-or-rollback** discipline.
> This section records the package identity and points the persistence
> interest at `KernelQueue.ts` / the store's savepoint API as comment-fragment
> follow-on targets.

`@metamask/kernel-store` provides ocap-kernel's "storage abstractions and
implementations." The README carries no detail beyond that line.

The persistence substance lives elsewhere and is cross-referenced here: the
[ken-protocol-assessment](metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline--the-crank-buffering-centerpiece.md)
ingest documented that ocap-kernel wraps each turn's output in a **database
savepoint** so that a turn either commits its output atomically or rolls back —
the kernel-store layer is what provides those savepoints. This is the package
most directly cross-comparable with the garden's daemon-persistence and
formula-graph work; the kernel-internals comment-fragment ingest (`KernelQueue.ts`)
will reach the savepoint usage.

External-lineage flag: read for reference; not imported.

Source: [packages/kernel-store/README.md](https://github.com/MetaMask/ocap-kernel/blob/d5a703d3f3ebcf5ba7034b51ab4572d4f3355def/packages/kernel-store/README.md) at commit `d5a703d`.
