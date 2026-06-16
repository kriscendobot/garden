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
title: §Standard-BIP39-test-vector-compatibility
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

> *This implementation uses standard BIP39 PBKDF2-HMAC-SHA512
> derivation (2048 iterations) with an empty passphrase.
> This ensures compatibility with standard BIP39 test
> vectors and other implementations.*

§Don't-invent-your-own-crypto. §Use-standard-test-vectors.
§Empty-passphrase-is-the-default-BIP39 (some implementations
allow an additional passphrase as a §two-factor-secret;
ocap-kernel deliberately doesn't).

§Trade-off-named: empty passphrase = standard portability
but no §passphrase-as-deniable-second-factor. The doc
doesn't argue for the choice; it just states it.

§Interoperability-as-design-axiom: a mnemonic generated in
ocap-kernel works in any BIP39-compliant tool. This is
both a §portability-win and a §key-reuse-hazard (a user
might use the same mnemonic for their wallet and their
kernel identity; compromise of either compromises both).
