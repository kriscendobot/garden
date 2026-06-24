---
title: "Peer identification: Ed25519 public key as node ID"
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

The SHA-512 derived node identifier is **replaced by an Ed25519 public
key**. The daemon generates a **root keypair** at first start and
stores it at `{statePath}/keypair` alongside the existing `nonce`
file. The public key hex serves as `localNodeNumber`.

```js
// daemon.js — daemon initialization
const { keypair: rootKeypair } =
  await persistencePowers.provideRootKeypair();
const localNodeNumber = Array.from(rootKeypair.publicKey, byte =>
  byte.toString(16).padStart(2, '0'),
).join('');
```

The hex encoding uses `Array.from().join('')` rather than `Buffer`
because the daemon's worker contexts run under SES and `Buffer` is not
available there (and would not be hardened anyway).
