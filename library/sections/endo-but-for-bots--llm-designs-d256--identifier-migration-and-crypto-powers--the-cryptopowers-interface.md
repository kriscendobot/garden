---
title: The CryptoPowers interface
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
// types.d.ts
export type Sha256 = {
  update: (chunk: Uint8Array) => void;
  updateText: (chunk: string) => void;
  digestHex: () => string;
};

export type Ed25519Keypair = {
  publicKey: Uint8Array;  // 32 bytes
  privateKey: Uint8Array; // 32 bytes (seed)
};

export type CryptoPowers = {
  makeSha256: () => Sha256;
  randomHex256: () => Promise<string>;
  generateEd25519Keypair: () => Promise<Ed25519Keypair>;
};
```

The interface is deliberately narrow: it generates and digests, but
does **not** persist. The design notes:

> *Key persistence is not a crypto concern — it belongs in
> `DaemonicPersistencePowers`. `CryptoPowers` only generates keypairs;
> the caller is responsible for storing them via the persistence
> layer.*

This is the **separated-power** pattern — split each power into the
narrowest interface that does one thing, and let composition (or
explicit cross-power calls) handle the rest. The same discipline shows
up in how the keypair *formulas* (see
[[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]) store key
material without touching the crypto layer.
