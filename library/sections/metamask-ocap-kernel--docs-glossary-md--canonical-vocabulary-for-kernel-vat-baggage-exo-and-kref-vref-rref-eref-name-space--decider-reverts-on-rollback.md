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
title: §Decider-reverts-on-rollback
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *After crank rollback, the decider reverts to its pre-
> delivery value, which matters for error handling (e.g.,
> rejecting the kernel promise of a message sent to a
> terminated vat).*

§Decider-as-authorization-target — only the §decider can
settle a kernel promise; the decider authority is §rollback-
aware. §Authorization-snapshot-restored-on-abort discipline.
§Rollback-restores-decider-too — not just the database state.

§Cycle-162's-revert-in-memory-state-too-not-just-the-
database has a sibling here: §revert-the-authorization-
target-too. Both are instances of §rollback-must-cover-
non-database-state-too.

§Concrete-motivating-example-given: rejecting the kernel
promise of a message sent to a terminated vat. §When-the-
decider-vat-dies-mid-delivery, the kernel needs to know
which authority to invoke to reject the promise; that
authority must be the *pre-delivery* decider, not the just-
attempted-and-failed decider.
