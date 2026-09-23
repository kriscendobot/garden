---
title: Realms and Compartments
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, compartments]
status: current
kind: index
section_count: 2
---

> Abstract: Conceptual material on JavaScript Realms (the underlying browser/runtime concept) and SES Compartments (the SES-specific isolation primitive built on top). Covers how Compartments share intrinsics with their host realm but have separate global scope and module map; the relationship between Compartment, Realm, and the start compartment. Foundational reading for understanding Endo's confinement model.

Sections:

- [Realms](endo--docs-guide--realms-and-compartments--realms.md)
- [Compartments](endo--docs-guide--realms-and-compartments--compartments.md)

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
