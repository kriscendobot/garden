---
source: docs/glossary.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/glossary.md
source_path: docs/glossary.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - captp
  - capability-security
genre: §sibling-implementation-comparison
cycle: 163
lane: comments
status: current
title: Two-axis structure
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

### §Concepts-vs-Abbreviations split

Two top-level sections by *naming convention*, not by
*subject matter*:

- **## Concepts** — 26 named-concept entries (kernel, vat,
  baggage, bootstrap, cluster, exo, distributed object,
  kernel service, supervisor, endowment, liveslots, crank,
  syscall, delivery, marshaling, kernel promise, decider,
  promise resolution, garbage collection, revocation,
  channel, stream, subcluster, system subcluster, run queue,
  kernel router).
- **## Abbreviations** — 5 typed-short-form refs (clist,
  eref, kref, rref, vref).

§Naming-convention-as-organizing-principle. The
abbreviations are *all* the four-layer name-space terms
(plus clist as the bidirectional mapping mechanism); the
concepts are everything else.

This is a useful structural move: it sets the kref-vref-rref-
eref name-space off as a *typed sub-vocabulary* — a
distinguishable surface that compilers, type-checkers, and
human readers can identify on sight (capital letters in
abbreviation expansions, short ASCII forms in code).
