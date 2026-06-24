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
title: §Crank-can-be-aborted-and-rolled-back
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *Cranks can be aborted and rolled back if errors occur.*

§Crank-as-transactional-unit. Cycle 162's §savepoint-with-
named-rollback-on-throw is the receive-side instance; this
glossary entry confirms cranks generally are §rollback-
capable. The §atomic-checkpoint-includes-output-queue
invariant (cycle 162) extends: cranks themselves are
atomic-or-not, and the kernel guarantees §all-or-nothing
crank execution.
