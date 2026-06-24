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
title: BIP39 mnemonic identity portability with verify-before-recovery and resetStorage conflict guard
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

> §Sibling-implementation-comparison genre (fourth ingest;
> §ocap-kernel-mini-series cycles 161/162/163/164).
> §Queued-doc-3 from cycle 161's overview's plan.

`docs/identity-backup-recovery.md` (289 lines) is the
**§human-portable-cryptographic-identity-surface** doc. It
describes ocap-kernel's BIP39 mnemonic-based identity
backup and recovery story — a feature Endo does not yet
have an analog for. The doc covers the four scenarios
(create / random / recover / verify), the API surface
(generateMnemonic / isValidMnemonic / mnemonicToSeed +
Kernel.make options), and the operational disciplines
around it (§existing-identity-conflict-guard, §verify-
before-recovery, six §security-best-practices).
