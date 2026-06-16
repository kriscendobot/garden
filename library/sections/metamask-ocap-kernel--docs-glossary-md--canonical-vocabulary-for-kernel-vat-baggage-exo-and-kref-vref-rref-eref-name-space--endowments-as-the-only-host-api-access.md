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
title: §Endowments-as-the-only-host-API-access
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

§Compartments-don't-expose-host-APIs-by-default + §vats-
request-by-name-via-globals-field-in-VatConfig + §endowments-
are-attenuated.

This is the §three-layered host-API-access pattern:

1. **Default**: nothing exposed.
2. **Request**: VatConfig declares which globals.
3. **Receive**: attenuated implementations.

§Capability-discipline-applied-to-hostAPI-access — the
maximum-discoverability-of-host-power requires §explicit-
opt-in, §named-attenuation, and §security-or-isolation-
motivation per endowment.
