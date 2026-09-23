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
title: §System-subcluster — privilege boundary
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *A subcluster declared at kernel initialization that can
> access privileged (`systemOnly`) kernel services. System
> subclusters persist across kernel restarts and are
> identified by a unique name.*

§Privilege-by-subcluster-declaration: §systemOnly-services
are gated by §subcluster-identity. §Identity-survives-restart
(unique name; reachable across restarts).

§Capability-security-applied-to-kernel-services: §kernel-
service-as-the-authority-bottleneck (cycle 161's overview
noted this from README); the glossary clarifies §systemOnly
as the privilege axis, *not* a permission system on
individual operations.
