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
title: §BIP39-mnemonic-as-identity-substrate
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

> *A BIP39 mnemonic is a human-readable sequence of words
> (typically 12 or 24 words) that represents cryptographic
> entropy.*

§Human-readable-entropy-encoding is the §primary-affordance.
§Twelve-or-twenty-four-words; §write-down-on-paper as the
backup mechanism.

§Standard-BIP39-compliance: §PBKDF2-HMAC-SHA512 / §2048-
iterations / §empty-passphrase / §standard-BIP39-test-
vector-compatibility. §Interoperability-with-other-BIP39-
implementations is a deliberate design choice — the same
mnemonic can be used in other wallets and tools (which is
both a feature for portability and a §threat-surface for
key-reuse).

§Five-supported-lengths: 12, 15, 18, 21, 24 words. §128-256-
bits-of-entropy range. The doc only exposes 12 or 24 in
the generator API — §sensible-defaults-not-all-options.
