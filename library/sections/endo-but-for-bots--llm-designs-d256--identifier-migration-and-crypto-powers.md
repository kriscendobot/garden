---
title: Identifier migration mechanics and the CryptoPowers interface
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
kind: index
section_count: 7
---

The migration affects four concrete sites: peer identification,
formula-number generation, content addressing, and the validation
patterns that gate them. The crypto-power interface is the smallest
typed boundary the daemon code uses to express the new primitives.

Sections:

- [Peer identification: Ed25519 public key as node ID](endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers--peer-identification-ed25519-public-key-as-node-id.md)
- [Formula numbers: 256-bit random](endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers--formula-numbers-256-bit-random.md)
- [Content addressing: SHA-256](endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers--content-addressing-sha-256.md)
- [The CryptoPowers interface](endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers--the-cryptopowers-interface.md)
- [Validation patterns](endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers--validation-patterns.md)
- [Locator and storage path formats](endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers--locator-and-storage-path-formats.md)
- [Branded types in `types.d.ts`](endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers--branded-types-in-types-d-ts.md)
