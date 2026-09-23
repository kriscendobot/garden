---
title: Formulation flow
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, persistence, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-d256--per-agent-keypairs
---

When a host or guest is formulated, `formulateKeypair()` generates a
fresh Ed25519 keypair, hex-encodes the keys SES-safely, and writes it
as a keypair formula:

```js
const formulateKeypair = async () => {
  const keypair = await generateEd25519Keypair();
  const publicKeyHex = Array.from(keypair.publicKey, byte =>
    byte.toString(16).padStart(2, '0'),
  ).join('');
  const privateKeyHex = Array.from(keypair.privateKey, byte =>
    byte.toString(16).padStart(2, '0'),
  ).join('');
  const keypairFormulaNumber = await randomHex256();
  const formula = {
    type: 'keypair',
    publicKey: publicKeyHex,
    privateKey: privateKeyHex,
  };
  const { id: keypairId } = await formulate(keypairFormulaNumber, formula);
  return { keypairId };
};
```

The returned `keypairId` is then included in
`formulateHostDependencies` and `formulateGuestDependencies`, then
stored on the host/guest formula.
