---
title: Problem and original state — 512-bit identifiers were oversized and misaligned with OCapN-Noise
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
notes: This is the **prerequisite migration** for the locator-terminology rename ([[endo-but-for-bots--llm-designs-dlt--terminology-rename]]) — the 256-bit identifier sizes established here are what the Peer Key / Formula Address / Formula Key nomenclature renames. Marked **Complete** upstream.
kind: index
section_count: 2
---

The Endo daemon originally used **512-bit (128-character hex)**
identifiers for formula numbers, node identifiers, and content
addresses. The migration this design records reduces all of them to
**256-bit (64-character hex)**, aligning the daemon's identity scheme
with the OCapN-Noise network protocol's Ed25519 key length.

Sections:

- [Original state (before migration)](endo-but-for-bots--llm-designs-d256--problem-and-original-state--original-state-before-migration.md)
- [Target state (after migration)](endo-but-for-bots--llm-designs-d256--problem-and-original-state--target-state-after-migration.md)
