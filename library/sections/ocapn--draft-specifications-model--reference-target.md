---
title: Reference: Target
source: draft-specifications/Model.md
source_repo: kriscendobot/ocapn
source_commit: 971eadd133f36b0d57bd32d29d83f221e81b9c1b
source_date: 2025-06-23
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, capability-security, captp]
status: current
notes: Cross-reference: library/sections/endo--pkg-marshal-readme--pass-by-presence-vs-copy.md, library/sections/endo--pkg-marshal-readme--convert-val-slot.md.
kind: index
section_count: 2
---

> Abstract: OCapN Reference > Target: a far reference to a capability. The receive side gets a proxy that forwards method calls to the sender's object. Maps to pass-style remotable (the pass-by-presence category). The OCapN spec describes wire-level identity and re-identification; Endo's marshal handles this via convertValToSlot/convertSlotToVal callbacks plugged in by CapTP.

Sections:

- [Reference (Capability)](ocapn--draft-specifications-model--reference-target--reference-capability.md)
- [Target](ocapn--draft-specifications-model--reference-target--target.md)

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
