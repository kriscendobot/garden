---
title: Branded types in `types.d.ts`
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

```typescript
/** A 64-character hex string identifying a formula within a node */
export type FormulaNumber = string & { [FormulaNumberBrand]: true };

/** A 64-character hex string (Ed25519 public key) identifying a node */
export type NodeNumber = string & { [NodeNumberBrand]: true };
```

The brand is what prevents arbitrary strings from being assigned where
identifiers are expected — and it is what the
[[endo-but-for-bots--llm-designs-dlt--terminology-rename]] later preserves
when aliasing `NodeNumber → PeerKey`, `FormulaNumber → FormulaAddress`.
The bridging-via-type-aliases discipline named in that design relies
on the brand being stable across the rename.
