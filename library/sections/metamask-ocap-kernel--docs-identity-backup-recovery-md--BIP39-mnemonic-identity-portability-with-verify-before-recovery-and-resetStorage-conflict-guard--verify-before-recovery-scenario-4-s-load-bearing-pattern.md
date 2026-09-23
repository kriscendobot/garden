---
source: docs/identity-backup-recovery.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/identity-backup-recovery.md
source_path: docs/identity-backup-recovery.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - persistence
genre: §sibling-implementation-comparison
cycle: 164
lane: comments
status: current
title: §verify-before-recovery — Scenario 4's load-bearing pattern
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

```typescript
async function getPeerIdFromMnemonic(mnemonic: string): Promise<string> {
  if (!isValidMnemonic(mnemonic)) {
    throw new Error('Invalid mnemonic');
  }

  const seed = mnemonicToSeed(mnemonic);
  const keyPair = await generateKeyPairFromSeed('Ed25519', fromHex(seed));
  return peerIdFromPrivateKey(keyPair).toString();
}

const recoveredPeerId = await getPeerIdFromMnemonic(recoveryMnemonic);
if (recoveredPeerId === expectedPeerId) {
  console.log('Mnemonic verified! Safe to proceed with recovery.');
} else {
  console.log('Warning: This mnemonic produces a different peer ID.');
}
```

§Dry-run-derive-without-init. §Compare-with-known-good-
identity. §Don't-trust-user-input-blindly even after
isValidMnemonic.

§The-side-quest-shape: the doc shows the user how to
*compose* the public utility functions (mnemonicToSeed +
generateKeyPairFromSeed + peerIdFromPrivateKey) to perform
verification *outside* the Kernel.make path. §The-utility-
functions-are-pieces-not-just-private-implementation.

§Synthesis-target: §verify-derivation-before-commit-pattern
generalizes beyond mnemonics. Any derivation-based identity
system benefits from §dry-run-derive-step.
