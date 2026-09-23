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
title: §Kernel-services-cannot-return-Exos
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *Because service implementations do not participate in the
> kernel's reference management, they cannot return exos.
> Services marked `systemOnly` can only be accessed by
> system subclusters.*

§Constraint-named: §kernel-services-return-pass-style-data-
only-no-remotables. §Reference-management-is-the-vat-runtime-
not-the-service-context. §Architectural-asymmetry-between-
vat-and-service.

§Why-services-cannot-be-exos: services run in the kernel's
own context, not in a vat; they have no liveslots; they have
no §clist; they have no §kref-vref translation. Returning a
remotable would require all of these.

§Cycle-156's-finalize-js distinction is parallel: the kernel
context has different §rules for what it can return.
