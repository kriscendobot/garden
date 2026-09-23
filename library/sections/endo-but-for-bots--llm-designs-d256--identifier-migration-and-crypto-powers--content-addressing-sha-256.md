---
title: "Content addressing: SHA-256"
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers
---

SHA-512 is replaced with SHA-256 in `makeContentSha256Store` for
content-addressed formulas (`readable-blob`, `readable-tree`).
Existing on-disk content paths are incompatible with new ones; see
the migration-notes section for the state-purge requirement.
