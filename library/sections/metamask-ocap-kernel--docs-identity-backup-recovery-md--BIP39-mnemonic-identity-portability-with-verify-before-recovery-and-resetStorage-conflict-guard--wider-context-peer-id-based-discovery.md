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
title: §Wider context — peer-ID-based discovery
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

§libp2p-peer-id is the §network-layer-identifier this whole
mechanism produces. Cycle 161's overview noted ocap-kernel
uses libp2p for transport; this doc shows that libp2p
*identity* is what BIP39 backs up.

§The-identity-flows-through-the-stack: mnemonic →
PBKDF2-HMAC-SHA512 → 32-byte seed → Ed25519 key pair →
peer-id (multihash of public key) → discovery / dialing /
ACL. §Identity-is-a-derivation-chain-not-a-stored-blob.

§Cycle-141-and-cycle-119-need-this-named: Endo's daemon
currently has §identity-as-stored-blob (locator file); a
shift toward §identity-as-derivation-chain would enable
portability without changing what the daemon does
internally.
